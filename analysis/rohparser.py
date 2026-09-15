#!/bin/bash
# =============================================================================
# SLURM JOB SUBMISSION: RUNS OF HOMOZYGOSITY (combined cohort)
#
# Split out of 08_pca_roh.sh's Steps 3-6 (ANGSD BCF calling -> allele freqs
# -> bcftools roh -> per-sample parsing) into its own script, since the ROH
# path doesn't depend on the beagle/pcangsd (PCA) steps at all.
#
# If 08_pca_roh.sh already produced ${ROH_DIR}/joint.bcf, this script will
# find and reuse it (Step 3 below is a no-op in that case) rather than
# recalling variants from scratch -- remove that file first if you want a
# genuinely clean rerun. If you're running this instead of 08_pca_roh.sh
# doing its own ROH steps, drop 08's Steps 3-6 so ANGSD variant calling
# doesn't happen twice.
#
# Two fixes applied relative to the original ROH steps in 08_pca_roh.sh:
#   1. bcftools roh's output is streamed straight through `grep "^RG"`
#      instead of being written to disk first -- the original wrote the
#      full ST+RG output (30 GB+ for a whole-genome, multi-sample cohort)
#      to disk, then re-read that entire file once per sample in a loop.
#   2. Per-sample splitting is now a single awk pass keyed on bcftools'
#      own sample-name column, instead of one grep per sample keyed on a
#      name parsed from the CRAM filename -- this removes both the
#      N-times-re-scan cost and the risk of the CRAM-filename-derived
#      name silently not matching the BCF's actual sample name (which
#      would produce empty per-sample files with no error).
#
# USAGE:
#   sbatch 09_roh.sh
# =============================================================================
#SBATCH --job-name=old.new_roh
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH -A dewoody
#SBATCH -t 5-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=250G
#SBATCH -p cpu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=blackan@purdue.edu

# =============================================================================
# ENVIRONMENT SETUP
# =============================================================================
set -euo pipefail

ml biocontainers
ml bcftools
ml angsd/0.940
ml htslib
# RCAC's xalt accounting hook injects LD_PRELOAD (libxalt_init.so) into
# every command, including containerized ones. singularity forwards it
# into the container by default, and the container's older glibc lacks
# the GLIBC_2.33/2.34 symbols that library needs, so angsd aborts before
# running. Blanking it inside the container via these two env vars is the
# reliable fix (a plain `unset LD_PRELOAD` on the host doesn't hold --
# xalt is sticky and re-injects it):
export SINGULARITYENV_LD_PRELOAD=""
export APPTAINERENV_LD_PRELOAD=""

# =============================================================================
# USER-DEFINED VARIABLES
# =============================================================================
PROJECT_DIR="${CLUSTER_SCRATCH}/GROUSE/old_vs_new"
REF_FASTA="${PROJECT_DIR}/ref/GCF_026119805.1_pur_lepc_1.0_genomic.fna"
FINAL_CRAMLIST="${PROJECT_DIR}/final_cramlist.txt"
ROH_DIR="${PROJECT_DIR}/roh"

# rohparser.py -- vendored verbatim from the original repo rather than
# reimplemented, so ROH size-class/FROH logic matches exactly. Its one
# hardcoded path (a .fai file, for total genome length) is patched below
# to point at our reference instead of the original's (different cluster).
ROHPARSER_URL="https://raw.githubusercontent.com/Andrew-N-Black/LEPC-popgen/main/analysis/rohparser.py"
ROHPARSER="${ROH_DIR}/rohparser.py"
ROHPARSER_ORIG_FAI="${PROJECT_DIR}/ref/GCF_026119805.1_pur_lepc_1.0_genomic.fna.fai"

THREADS=$SLURM_CPUS_PER_TASK
ROH_PARALLEL_JOBS=8

mkdir -p logs "$ROH_DIR"

echo ">>> 09_roh.sh"
echo ">>> Start time: $(date)"

if [[ ! -f "$FINAL_CRAMLIST" ]]; then
    echo "ERROR: ${FINAL_CRAMLIST} not found. Run 06_downsample_and_finalize.sh first."
    exit 1
fi
if [[ ! -f "${REF_FASTA}.fai" ]]; then
    echo "ERROR: ${REF_FASTA}.fai not found. Run 05_combined_alignment_array.sh's prep step first."
    exit 1
fi

N_SAMPLES=$(wc -l < "$FINAL_CRAMLIST")
echo ">>> N samples : ${N_SAMPLES}"

# =============================================================================
# STEP 1: ANGSD genome-wide variant calling -> BCF (flags match ROH.sh
# exactly, extracted directly from its source -- no -doGeno needed)
# =============================================================================
echo ">>> Step 1: ANGSD variant calling (BCF output)"

JOINT_OUT="${ROH_DIR}/joint"
JOINT_BCF="${JOINT_OUT}.bcf"

if [[ ! -f "$JOINT_BCF" ]]; then
    angsd -bam "$FINAL_CRAMLIST" -ref "$REF_FASTA" \
        -GL 1 -dobcf 1 -dopost 1 -domajorminor 1 -domaf 1 \
        -minQ 30 -SNP_pval 1e-6 -P "$THREADS" -out "$JOINT_OUT"
else
    echo "  ${JOINT_BCF} already exists -- skipping ANGSD call. Delete it first for a clean rerun."
fi

if [[ ! -f "$JOINT_BCF" ]]; then
    echo "ERROR: ANGSD did not produce expected output: ${JOINT_BCF}"
    exit 1
fi

# =============================================================================
# STEP 2: Allele frequency file for bcftools roh
# =============================================================================
echo ">>> Step 2: Building allele-frequency file"

FREQS="${ROH_DIR}/freqs.tab.gz"
if [[ ! -f "$FREQS" ]]; then
    bcftools query -f '%CHROM\t%POS\t%REF,%ALT\t%AF\n' "$JOINT_BCF" | bgzip -c > "$FREQS"
    tabix -s1 -b2 -e2 "$FREQS"
else
    echo "  ${FREQS} already exists -- skipping."
fi

# =============================================================================
# STEP 3: bcftools roh (flags match ROH.sh exactly), streamed through grep
# so the multi-GB per-site ST output never touches disk -- only the RG
# (called-region) lines, which is all downstream parsing actually needs.
# =============================================================================
echo ">>> Step 3: bcftools roh"

ROH_RG_ONLY="${ROH_DIR}/ROH_GROUSE_PL_regions.txt"
bcftools roh --AF-file "$FREQS" --threads "$THREADS" "$JOINT_BCF" \
    | grep "^RG" > "$ROH_RG_ONLY"

echo "  RG (called-region) lines: ${ROH_RG_ONLY}"
echo "  $(wc -l < "$ROH_RG_ONLY") regions called across all samples"

# =============================================================================
# STEP 4: Per-sample ROH parsing with rohparser.py (vendored from the
# original repo, patched to use our reference's .fai for genome length)
# =============================================================================
echo ">>> Step 4: Per-sample ROH parsing"

if [[ ! -f "$ROHPARSER" ]]; then
    echo ">>> Downloading rohparser.py"
    wget -q -O "$ROHPARSER" "$ROHPARSER_URL"
    sed -i "s|${ROHPARSER_ORIG_FAI}|${REF_FASTA}.fai|g" "$ROHPARSER"
    # sed doesn't error or warn if ROHPARSER_ORIG_FAI didn't actually match
    # anything in the downloaded file -- it just silently leaves the
    # original (wrong-cluster) path in place. Fail loudly instead of
    # discovering this later as silently-wrong ROH results.
    if ! grep -qF "${REF_FASTA}.fai" "$ROHPARSER"; then
        echo "ERROR: rohparser.py patch did not take -- ROHPARSER_ORIG_FAI" >&2
        echo "  ('${ROHPARSER_ORIG_FAI}') was not found verbatim in the" >&2
        echo "  downloaded script. Check the source hasn't changed its" >&2
        echo "  hardcoded path, update ROHPARSER_ORIG_FAI to match, and" >&2
        echo "  delete ${ROHPARSER} to force a fresh download+patch." >&2
        exit 1
    fi
fi

# Single pass over the RG-only file, splitting by bcftools' own sample-name
# column (RG lines: RG, sample, chrom, start, end, length, n_markers,
# quality -- matches rohparser.py's expected field[5]=length, field[7]=
# quality). Using bcftools' own sample name as the filename also removes
# any dependency on CRAM filenames matching the BCF's sample names.
awk -v dir="$ROH_DIR" '{print > (dir"/"$2"ROH.txt")}' "$ROH_RG_ONLY"

N_SAMPLE_FILES=$(find "$ROH_DIR" -maxdepth 1 -name "*ROH.txt" ! -empty | wc -l)
echo "  Split into ${N_SAMPLE_FILES} non-empty per-sample files (expected ${N_SAMPLES})"
if [[ "$N_SAMPLE_FILES" -ne "$N_SAMPLES" ]]; then
    echo "  WARNING: sample-file count doesn't match N_SAMPLES -- a sample may" >&2
    echo "  have zero called ROH regions (possible, not necessarily a bug)," >&2
    echo "  or something upstream is off. Compare against:" >&2
    echo "    bcftools query -l ${JOINT_BCF}" >&2
fi

run_rohparser() {
    # rohparser.py builds its own input path internally from a hardcoded
    # directory + a bare filename (matching its documented usage: `cd` into
    # the ROH directory, then `python ROHparser.py SAMPLEROH.txt`). Passing
    # it a full path instead -- as a naive `find`-based invocation would --
    # makes it concatenate a doubled, nonexistent path and fail. So: cd into
    # the file's directory and pass only the basename.
    local roh_file="$1"
    local bn
    bn=$(basename "$roh_file")
    (cd "$(dirname "$roh_file")" && python3 "$ROHPARSER" "$bn") > "${roh_file}_results.txt"
}
export -f run_rohparser
export ROHPARSER

find "$ROH_DIR" -maxdepth 1 -name "*ROH.txt" ! -empty \
    | xargs -I{} -P "$ROH_PARALLEL_JOBS" bash -c 'run_rohparser "$@"' _ {}

N_ROH_RESULTS=$(find "$ROH_DIR" -maxdepth 1 -name "*ROH.txt_results.txt" | wc -l)
echo "  Parsed ROH results for ${N_ROH_RESULTS} samples"

echo ""
echo ">>> ROH analysis complete."
echo "    Joint BCF        : ${JOINT_BCF}"
echo "    RG (regions only): ${ROH_RG_ONLY}"
echo "    Per-sample ROH   : ${ROH_DIR}/*ROH.txt_results.txt"
echo ">>> End time: $(date)"

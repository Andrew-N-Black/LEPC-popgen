#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --error=align.err
#SBATCH --output=align.out
#SBATCH --job-name=produce_align_SLURMM_jobs


module purge
module load bioinfo
module load bwa
module load picard-tools
module load bedops
module load GATK/3.6.0
module load samtools

#Move to fastq containing directory
cd /scratch/bell/blackan/LEPC/shotgun/raw
#Make sample list
ls -1 *.fastq.gz | sed "s/_R[1-2]_001.fastq.gz//g" | uniq > sample.list
#Make directory to hold all SLURMM jobs
mkdir jobs
#Define variables to shorten commands
REF=/scratch/bell/blackan/LEPC/shotgun/ncbi/ref.fa
DICT=/scratch/bell/blackan/LEPC/shotgun/ncbi/ref.fa.dict
FILT=/scratch/bell/blackan/LEPC/shotgun/ncbi/ok.bed
#bwa index $REF
#samtools faidx $REF
#PicardCommandLine CreateSequenceDictionary reference=$REF output=$DICT


while read -a line
do 
	echo "#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 10
#SBATCH -t 05-00:00:00
#SBATCH --job-name=${line[0]}_aln
#SBATCH --error=${line[0]}_aln.e
#SBATCH --output=${line[0]}_aln.o
#SBATCH --mem=18G
module --force purge
module load bioinfo
module load bwa
module load picard-tools
module load bedops
module load GATK/3.6.0
module load samtools
#Move to the paired-end fastq containing folder
cd /scratch/bell/blackan/LEPC/shotgun/raw
# Align sample to indexed reference genome
bwa mem -t 10 -M -R \"@RG\tID:group1\tSM:${line[0]}\tPL:illumina\tLB:lib1\tPU:unit1\" \
/scratch/bell/blackan/LEPC/shotgun/ncbi/ref.fa \
${line[0]}_R1_001.fastq.gz ${line[0]}_R2_001.fastq.gz > ../aligned/${line[0]}.sam
#Move to aligned directory
cd ../aligned/
#Validate sam file
PicardCommandLine ValidateSamFile I=${line[0]}.sam MODE=SUMMARY O=${line[0]}.sam.txt
#Sort validated sam file by read coordinate
PicardCommandLine SortSam INPUT=${line[0]}.sam OUTPUT=sorted_${line[0]}.bam SORT_ORDER=coordinate
#Get summary stats on initial alignments:
samtools flagstat sorted_${line[0]}.bam > ${line[0]}_mapped.txt

samtools depth -a sorted_${line[0]}.bam \
| awk '{c++;s+=\$3}END{print s/c}' \
> ${line}.pre.meandepth.txt

samtools depth -a sorted_${line[0]}.bam \
| awk '{c++; if(\$3>0) total+=1}END{print (total/c)*100}' \
> ${line}.pre.1xbreadth.txt


#Mark duplicates
PicardCommandLine MarkDuplicates INPUT=sorted_${line[0]}.bam OUTPUT=dedup_${line[0]}.bam METRICS_FILE=metrics_${line[0]}.bam.txt OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500
#Index in prep for realignment
PicardCommandLine BuildBamIndex INPUT=dedup_${line[0]}.bam
# local realignment of reads
GenomeAnalysisTK -T RealignerTargetCreator -nt 10 -R /scratch/bell/blackan/LEPC/shotgun/ncbi/ref.fa -I dedup_${line[0]}.bam -o ${line[0]}_forIndelRealigner.intervals
#Realign with established intervals
GenomeAnalysisTK -T IndelRealigner -R /scratch/bell/blackan/LEPC/shotgun/ncbi/ref.fa -I dedup_${line[0]}.bam -targetIntervals ${line[0]}_forIndelRealigner.intervals -o ${line[0]}_indel.bam
#Make new directory
#Fix mate info
PicardCommandLine FixMateInformation INPUT=dedup_${line[0]}.bam OUTPUT=${line[0]}.fixmate.bam SO=coordinate CREATE_INDEX=true
#   Remove unmapped (4), secondary (256), QC failed (512), duplicate (1024), and
#   supplementary (2048) reads from indel-realigned BAMs, and keep only reads
#   mapped in a proper pair (2) to regions in a BED file (produced from QC_reference.sh)
samtools view -@ 10 -q 30 -b -F 3844 -f 2 -L $FILT ${line[0]}.fixmate.bam > ../final_bams/${line[0]}_filt.bam 
#Move into the final directory
cd ../final_bams/
#Index bam file
PicardCommandLine BuildBamIndex INPUT=${line[0]}_filt.bam

samtools depth -a ${line[0]}_filt.bam \
| awk '{c++;s+=\$3}END{print s/c}' \
> ${line}.post.meandepth.txt

samtools depth -a ${line[0]}_filt.bam \
| awk '{c++; if(\$3>0) total+=1}END{print (total/c)*100}' \
> ${line}.post.1xbreadth.txt

echo done" > ./jobs/${line[0]}_aln.sh

done < ./sample.list

#for i in `ls -1 *sh`; do  echo "sbatch $i" ; done > jobs ; source ./jobs
blackan@bell-fe03:/scratch/bell/blackan/LEPC/shotgun/raw $ cd ../angsd_out/
blackan@bell-fe03:/scratch/bell/blackan/LEPC/shotgun/angsd_out $ cat beagle_filtered.sh 
#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --error=beagle.err
#SBATCH --output=beagle.out
#SBATCH --job-name=produce_regions_SLURMM_jobs


mkdir jobs_beagle
while read -a line
do 
	echo "#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 10
#SBATCH -t 10-00:00:00
#SBATCH --job-name=Beagle_${line[0]}
#SBATCH --error=Beagle_${line[0]}.e
#SBATCH --output=Beagle_${line[0]}.o
#SBATCH --mem=20G
module load biocontainers
module load angsd

#Move to bam folder
cd /scratch/bell/blackan/LEPC/shotgun/angsd_out
angsd -GL 1 -out BEAGLE/${line[0]} -r ${line[0]} -minQ 30 -P 10 \
-minInd 348 -doGlf 2 -doMajorMinor 1 -doMaf 1 -minMaf 0.01 -SNP_pval 1e-6 -bam bamlist_filtered.txt  \
-ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa "  > ./jobs_beagle/filtered_${line[0]}.sh
done < ./regions.txt

for i in `ls -1 *sh`; do  echo "sbatch $i" ; done > jobs ; source ./jobs

cd /scratch/bell/blackan/LEPC/shotgun/angsd_out/BEAGLE/
for f in *.beagle.gz; do zcat ${f} | sed 1d   > tmpfile; mv tmpfile ${f}_trim; done
zcat NW_026294820.1.beagle.gz | head -n 1 > beagle.header
cat beagle.header  *_trim > filtered.beagle ; gzip filtered.beagle 

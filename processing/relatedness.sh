#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -n 128
#SBATCH -t 10-00:00:00
#SBATCH --job-name=LEPC_relate
#SBATCH --error=LEPC_relate.e
#SBATCH --output=LEPC_relate.o
#SBATCH --mem=200G
module load biocontainers
module load angsd

#Move to bam folder
cd /scratch/bell/blackan/LEPC/shotgun/angsd_out_serial
mkdir relate
angsd -GL 1 -out relate/grouse -rf regions.txt -minQ 30 -doGlf 3 -P 128 \
-ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa \
-doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6  -minmaf 0.01 -bam bamlist.txt 


zcat grouse.mafs.gz | sed 1d | cut if 6 > full_freq
 ~/ngsRelate/ngsRelate -g grouse.glf.gz -p 128 -f full_freq  -O relate_results -n 481 -z ids.txt

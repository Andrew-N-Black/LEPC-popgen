#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -n 128
#SBATCH -t 14-00:00:00
#SBATCH --job-name=bcf
#SBATCH --error=bcf.e
#SBATCH --output=bcf.o
#SBATCH --mem=240G
module load biocontainers
module load angsd


angsd -GL 1 -dobcf 1 -dopost 1 -domajorminor 1 -domaf 1 -minQ 30 -P 128 \
-SNP_pval 1e-6 -bam bamlist_filtered.txt -ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa

module purge
module load bioinfo
module load bcftools
module load samtools

bcftools query -f'%CHROM\t%POS\t%REF,%ALT\t%INFO/AF\n' angsdput.bcf | bgzip -c > grouse.freqs.tab.gz
tabix -s1 -b2 -e2 grouse.freqs.tab.gz
bcftools roh --AF-file grouse.freqs.tab.gz --output ROH_GROUSE_PLraw.txt --threads 128 angsdput.bcf

awk '$1=="RG"' ROH_GROUSE_PLraw.txt > ROH_RG_all.txt
for i in `cat sample.names`; do  grep $i ROH_RG_all.txt  > $i.ROH.txt ; done
for i in `ls -1 *ROH.txt`; do python ROHparser.py $i > ${i}_results.txt ; done

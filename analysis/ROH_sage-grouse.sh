#!/bin/sh
#SBATCH -A fnrpredator
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 14-00:00:00
#SBATCH --job-name=SG_roh
#SBATCH -e roh.e
#SBATCH -o roh.o
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=

for sp in GRSG GUSG; do
REF=/scratch/bell/dewoody/LEPC/JY-test/GRSG/ref/ref_100kb.fa

ml biocontainers
ml angsd

cd /scratch/bell/dewoody/LEPC/JY-test/${sp}/
mkdir -p ./roh/
cd ./roh/

angsd -GL 1 -dobcf 1 -dopost 1 -domajorminor 1 -domaf 1 -minQ 30 -P 128 -SNP_pval 1e-6 -bam ../final_bams/bams.${sp} -ref $REF

module purge
module load bioinfo
module load bcftools
module load samtools

bcftools query -f'%CHROM\t%POS\t%REF,%ALT\t%INFO/AF\n' angsdput.bcf | bgzip -c > ${sp}.freqs.tab.gz
tabix -s1 -b2 -e2 ${sp}.freqs.tab.gz
bcftools roh --AF-file ${sp}.freqs.tab.gz --output ROH_${sp}_PLraw.txt --threads 64 angsdput.bcf

awk '$1=="RG"' ROH_${sp}_PLraw.txt > ROH_${sp}_RG_all.txt
for i in `cat ../sra/sample.list`; do  grep $i ROH_${sp}_RG_all.txt  > $i.ROH.txt ; done
for i in `ls -1 *ROH.txt`; do python ../../ROHparser.py $i $sp > ${i}_results.txt ; done
done

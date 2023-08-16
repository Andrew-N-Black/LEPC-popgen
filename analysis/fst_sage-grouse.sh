#!/bin/sh
#SBATCH -A highmem
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 1-00:00:00
#SBATCH --job-name=SG_Fst
#SBATCH -e Fst.e
#SBATCH -o Fst.o
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=

REF=/scratch/bell/dewoody/LEPC/JY-test/GRSG/ref/ref_100kb.fa

ml biocontainers
ml angsd

cd /scratch/bell/dewoody/LEPC/JY-test/GRSG/
mkdir -p ./fst/

angsd -P 128 -out fst/GRSG \
-minInd 60 -minQ 30 \
-bam ./bams.GRSG -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF

angsd -P 128 -out fst/GUSG \
-minInd 12 -minQ 30 \
-bam ./bams.GUSG -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF


calculate the 1D SFS from allele freq likelihoods
realSFS fst/GRSG.saf.idx -P 128 -fold 1 > fst/GRSG.sfs
realSFS fst/GUSG.saf.idx -P 128 -fold 1 > fst/GUSG.sfs

calculate the 2D SFS
realSFS fst/GRSG.saf.idx fst/GUSG.saf.idx -P 128 > fst/GRSG.GUSG.ml

#Now pairwise Fsts

#Index sample so same sites are analyzed for each pop
realSFS fst index fst/GRSG.saf.idx fst/GUSG.saf.idx -sfs fst/GRSG.GUSG.ml -fstout fst/GRSG.GUSG

#Global pairwise estimates
realSFS fst stats fst/GRSG.GUSG.fst.idx

#per-site Fsts
realSFS fst print GRSG.GUSG.fst.idx > GRSG.GUSG.per-site_fst.txt

#sliding window analyses
realSFS fst stats2 fst/GRSG.GUSG.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_GR_GU_T2



#!/bin/sh
#SBATCH -A highmem
#SBATCH -N 1
#SBATCH -n 128
#SBATCH -t 1-00:00:00
#SBATCH --job-name=Thetas
#SBATCH -e Thetas.e
#SBATCH -o Thetas.o
#SBATCH --mem=500G

ml biocontainers
ml angsd

REF=/scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa


#All allopatric GRPC and Southern DPS LEPC
#wc -l ./bams_allo.south
#159
#159*.8=127
angsd -P 128 -out ex \
-minInd 127 -minQ 30\
-bam ./bams_allo.south -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF -rf regions.txt

#calculate the 1D SFS from allele freq likelihoods
realSFS ex.saf.idx -P 128 -fold 1 > ex.sfs

#Allele freq for theta
realSFS saf2theta ex.saf.idx -outname ex -sfs ex.sfs -fold 1

thetaStat do_stat ex.thetas.idx -win 50000 -step 10000  -outnames ex.thetasWindow.t2 -type 2
#Divide each window by number of sites in R

#Allopatric GRPC only
#wc -l ./bams_allopatric
#18
#18*.8=14
angsd -P 128 -out ALLO \
-minInd 14 -minQ 30\
-bam ./bams_allopatric -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF -rf regions.txt

#calculate the 1D SFS from allele freq likelihoods
realSFS ALLO.saf.idx -P 128 -fold 1 > ALLO.sfs

#Allele freq for theta
realSFS saf2theta ALLO.saf.idx -outname ALLO -sfs ALLO.sfs -fold 1

thetaStat do_stat ALLO.thetas.idx -win 50000 -step 10000  -outnames ALLO.thetasWindow.t2 -type 2
#Divide each window by number of sites in R

#Southern DPS only
#wc -l ./bams_south
#151
#151*.8=121
angsd -P 128 -out south \
-minInd 121 -minQ 30\
-bam ./bams_south -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF -rf regions.txt

#calculate the 1D SFS from allele freq likelihoods
realSFS south.saf.idx -P 128 -fold 1 > south.sfs

#Allele freq for theta
realSFS saf2theta south.saf.idx -outname south -sfs south.sfs -fold 1

thetaStat do_stat south.thetas.idx -win 50000 -step 10000  -outnames south.thetasWindow.t2 -type 2
#Divide each window by number of sites in R



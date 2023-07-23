#!/bin/bash
#SBATCH -N 1
#SBATCH -p EM
#SBATCH -t 5-00:00:00
#SBATCH --ntasks-per-node=96
#SBATCH -J Fsts_final
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out

REF=../ncbi/ref_100kb.fa

#wc-l ./south
#150
/jet/home/blackan/angsd/angsd -P 96 -out fst/south \
-minInd 120 -minQ 30 \
-bam ./south -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF

#wc -l ./north
#269
/jet/home/blackan/angsd/angsd -P 96 -out fst/north \
-minInd 209 -minQ 30 \
-bam ./north -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF

#wc -l ./bams_sympatric
#13
/jet/home/blackan/angsd/angsd -P 96 -out fst/SYM \
-minInd 10 -minQ 30 \
-bam ./bams_sympatric -doCounts 1 -GL 1 -doSaf 1 -ref $REF

#wc -l ./bams_allopatric
#9
/jet/home/blackan/angsd/angsd -P 96 -out fst/ALLO \
-minInd 7 -minQ 30 \
-bam ./bams_allopatric -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF


#calculate the 1D SFS from allele freq likelihoods
/jet/home/blackan/angsd/misc/realSFS fst/south.saf.idx -P 96 -fold 1 > fst/south.sfs
/jet/home/blackan/angsd/misc/realSFS fst/north.saf.idx -P 96 -fold 1 > fst/north.sfs
/jet/home/blackan/angsd/misc/realSFS fst/SYM.saf.idx -P 96 -fold 1 > fst/SYM.sfs
/jet/home/blackan/angsd/misc/realSFS fst/ALLO.saf.idx -P 96 -fold 1 > fst/ALLO.sfs

#calculate the 2D SFS
/jet/home/blackan/angsd/misc/realSFS fst/south.saf.idx fst/north.saf.idx -P 96 > fst/south.north.ml
/jet/home/blackan/angsd/misc/realSFS fst/ALLO.saf.idx fst/north.saf.idx -P 96 > fst/ALLO.north.ml
/jet/home/blackan/angsd/misc/realSFS fst/ALLO.saf.idx fst/SYM.saf.idx -P 96 > fst/ALLO.SYM.ml
/jet/home/blackan/angsd/misc/realSFS fst/ALLO.saf.idx fst/south.saf.idx -P 96 > fst/ALLO.south.ml
/jet/home/blackan/angsd/misc/realSFS fst/SYM.saf.idx fst/south.saf.idx -P 96 > fst/SYM.south.ml
/jet/home/blackan/angsd/misc/realSFS fst/SYM.saf.idx fst/north.saf.idx -P 96 > fst/SYM.north.ml

#Now pairwise Fsts

#Index sample so same sites are analyzed for each pop
/jet/home/blackan/angsd/misc/realSFS fst index fst/south.saf.idx fst/north.saf.idx -sfs fst/south.north.ml -fstout fst/south.north
/jet/home/blackan/angsd/misc/realSFS fst index fst/ALLO.saf.idx fst/north.saf.idx -sfs fst/ALLO.north.ml -fstout fst/ALLO.north
/jet/home/blackan/angsd/misc/realSFS fst index fst/ALLO.saf.idx fst/south.saf.idx -sfs fst/ALLO.south.ml -fstout fst/ALLO.south
/jet/home/blackan/angsd/misc/realSFS fst index fst/ALLO.saf.idx fst/SYM.saf.idx -sfs fst/ALLO.SYM.ml -fstout fst/ALLO.SYM
/jet/home/blackan/angsd/misc/realSFS fst index fst/SYM.saf.idx fst/south.saf.idx -sfs fst/SYM.south.ml -fstout fst/SYM.south
/jet/home/blackan/angsd/misc/realSFS fst index fst/SYM.saf.idx fst/north.saf.idx -sfs fst/SYM.north.ml -fstout fst/SYM.north

#Global pairwise estimates
/jet/home/blackan/angsd/misc/realSFS fst stats fst/south.north.fst.idx
/jet/home/blackan/angsd/misc/realSFS fst stats fst/ALLO.north.fst.idx
/jet/home/blackan/angsd/misc/realSFS fst stats fst/ALLO.south.fst.idx
/jet/home/blackan/angsd/misc/realSFS fst stats fst/ALLO.SYM.fst.idx
/jet/home/blackan/angsd/misc/realSFS fst stats fst/SYM.south.fst.idx
/jet/home/blackan/angsd/misc/realSFS fst stats fst/SYM.south.fst.idx

#sliding window analyses
/jet/home/blackan/angsd/misc/realSFS fst stats2 fst/south.north.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_S_N_LEPC.txt
/jet/home/blackan/angsd/misc/realSFS fst stats2 fst/ALLO.north.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_ALLO_north_T2
/jet/home/blackan/angsd/misc/realSFS fst stats2 fst/ALLO.south.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_ALLO_south_T2
/jet/home/blackan/angsd/misc/realSFS fst stats2 fst/ALLO.SYM.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_ALLO_SYM_T2
/jet/home/blackan/angsd/misc/realSFS fst stats2 fst/ALLO.south.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_SYM_south_T2
/jet/home/blackan/angsd/misc/realSFS fst stats2 fst/SYM.north.fst.idx -win 50000 -step 10000 -type 2 > fst/slidingwindow_SYM_north_T2

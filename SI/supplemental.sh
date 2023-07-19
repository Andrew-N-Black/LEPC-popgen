############################################ Figure S1 ###################################################################

samtools index GCF_026119805.1_pur_lepc_1.0_genomic.fna
cat GCF_026119805.1_pur_lepc_1.0_genomic.fna.fai | cut -d " " -f 1,2 > seqs
#modify 'seqs' with excel for plotting

############################################ Figure S2 ###################################################################
NA

############################################ Figure S3 ###################################################################

#!/bin/sh -l
#SBATCH -A fnrpupfish
#SBATCH -n 64
#SBATCH -t 1-00:00:00
#SBATCH --job-name=unfiltered_PCA
#SBATCH --error=pca.e
#SBATCH --output=pca.o
#SBATCH --mem=120G

module load biocontainers
module load pcangsd

pcangsd -b unfiltered.beagle.gz -o unfiltered --threads 128 --minMaf 0.01

############################################ Figure S4 ###################################################################
NA

############################################ Figure S5 ###################################################################
NA

############################################ Figure S6 ###################################################################
NA
############################################ Figure S7 ###################################################################
NA

############################################ Figure S8 ###################################################################
#!/bin/sh
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 30
#SBATCH -t 1-00:00:00
#SBATCH --job-name=Dsuite
#SBATCH -e abba2.e
#SBATCH -o abba2.o
#SBATCH --mem=60G


module purge
module load biocontainers
ml angsd

#Below was run when grouping by allopatric, sympatric, northern, southern
angsd -doAbbababa2 1 -bam bam.filelist -sizeFile sizeFile.size -doCounts 1 -out bam.Angsd2 -useLast 0 -minMapQ 30 -p 128

Rscript estAvgError.R angsdFile="bam.Angsd" sizeFile=sizeFile.size nameFile=names out="results" main="Prairie-Chicken"


############################################ Figure S9 ###################################################################
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

#Allopatric GRPC only
#wc -l ./bams_allopatric
#9
#9*.8=7
angsd -P 128 -out ALLO \
-minInd 7 -minQ 30\
-bam ./bams_allopatric -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF -rf regions.txt

#Southern DPS only
#wc -l ./bams_south
#151
#151*.8=121
angsd -P 128 -out south \
-minInd 121 -minQ 30\
-bam ./bams_south -doCounts 1 -GL 1 -doSaf 1 -anc $REF -ref $REF -rf regions.txt

#calculate the 1D SFS from allele freq likelihoods
realSFS ex.saf.idx -P 128 -fold 1 > ex.sfs
realSFS ALLO.saf.idx -P 128 -fold 1 > ALLO.sfs
realSFS south.saf.idx -P 128 -fold 1 > south.sfs

#Allele freq for theta
realSFS saf2theta ex.saf.idx -outname ex -sfs ex.sfs -fold 1
realSFS saf2theta ALLO.saf.idx -outname ALLO -sfs ALLO.sfs -fold 1
realSFS saf2theta south.saf.idx -outname south -sfs south.sfs -fold 1

thetaStat do_stat ex.thetas.idx -win 50000 -step 10000  -outnames ex.thetasWindow.t2 -type 2
thetaStat do_stat ALLO.thetas.idx -win 50000 -step 10000  -outnames ALLO.thetasWindow.t2 -type 2
thetaStat do_stat south.thetas.idx -win 50000 -step 10000  -outnames south.thetasWindow.t2 -type 2
#Divide each window by number of sites in R



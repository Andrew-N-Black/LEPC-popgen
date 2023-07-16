#Figure S1

samtools index GCF_026119805.1_pur_lepc_1.0_genomic.fna
cat GCF_026119805.1_pur_lepc_1.0_genomic.fna.fai | cut -d " " -f 1,2 > seqs
#modify seqs with excel for plotting


#Figure S3

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

#Figure S8
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






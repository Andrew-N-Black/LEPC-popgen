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





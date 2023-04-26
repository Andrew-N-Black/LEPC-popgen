#!/bin/sh -l
#SBATCH -A fnrpupfish
#SBATCH -n 64
#SBATCH -t 1-00:00:00
#SBATCH --job-name=seelction
#SBATCH --error=pca.e
#SBATCH --output=pca.o
#SBATCH --mem=120G

module load biocontainers
module load pcangsd

pcangsd -b final.beagle.gz -o final --threads 128 --minMaf 0.01 --admix

#For inbreeding estimate:
pcangsd -b final.beagle.gz -o final_inbreed --threads 128 --minMaf 0.01 --maf_tole 1e-9 --tole 1e-9 --inbreedSamples --inbreedSites --iter 5000 --maf_iter 5000 --inbreed_iter 5000 --inbreed_tole 1e-9
 
 

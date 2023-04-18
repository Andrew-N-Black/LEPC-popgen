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

pcangsd -b final.beagle.gz -o final --threads 128 --minMaf 0.01 --admix --tree --tree_samples dps.txt

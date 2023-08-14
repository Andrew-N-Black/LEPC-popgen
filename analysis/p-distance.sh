#!/bin/bash
#SBATCH -N 1
#SBATCH -p EM
#SBATCH -t 5-00:00:00
#SBATCH --ntasks-per-node=96
#SBATCH -J Dist
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out

~/ngsDist/ngsDist  --geno final.beagle.gz --n_ind 433 --out final_dist_tree --n_threads 128 --n_sites 18448339 --probs

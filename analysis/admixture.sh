#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -N 1
#SBATCH -n 126
#SBATCH -t 14-00:00:00
#SBATCH --job-name=admix_all
#SBATCH --error=%x_%j.out
#SBATCH --output=%x_%j.out
#SBATCH --mem=220G
#for  ((i=1;i<=10;i++));  do mkdir R_$i; done
j="1"
while [ $j -lt 100 ]
do
  	for i in {1..10}
        do
                 /depot/fnrdewoody/apps/angsd/misc/NGSadmix -P 126  \
                -K ${i} -minMaf 0.01 -maxiter 50000 -tol 1e-9 -tolLike50 1e-9 \
                -likes final.beagle.gz \
                -outfiles  ADX/R_${j}/K${i}_R${j}
                i=$[$i+1]

        done
	j=$[$j+1]
done

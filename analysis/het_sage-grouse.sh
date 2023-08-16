#!/bin/bash
#SBATCH -A fnrdewoody
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --error=het.err
#SBATCH --output=het.out
#SBATCH --job-name=produce_het_SLURMM_jobs

for i in GRSG GUSG; do
cd /scratch/bell/dewoody/LEPC/JY-test/${i}/

mkdir -p HET/jobs_het
cd ./HET/

while read -a line
do 
	echo "#!/bin/sh -l
#SBATCH -A fnrdewoody
#SBATCH -n 10
#SBATCH -t 14-00:00:00
#SBATCH --job-name=${line[0]}_het_stats
#SBATCH --error=${line[0]}_het_stats.e
#SBATCH --output=${line[0]}_het_stats.o
#SBATCH --mem=50G

#Move to the angsd_output folder containing folder
cd /scratch/bell/dewoody/LEPC/JY-test/${i}/

/depot/fnrdewoody/apps/angsd/angsd -i ./final_bams/${line[0]}_filt.bam -ref /scratch/bell/dewoody/LEPC/JY-test/GRSG/ref/ref_100kb.fa  -anc /scratch/bell/dewoody/LEPC/JY-test/GRSG/ref/ref_100kb.fa  -dosaf 1 -minMapQ 30 -GL 1 -P 26 -out HET/${line[0]} -doCounts 1 -setMinDepth 3

/depot/fnrdewoody/apps/angsd/misc/realSFS -P 26 -fold 1 HET/${line[0]}.saf.idx > HET/${line[0]}_est.ml" > ./jobs_het/${line[0]}_alignment.sh

done < /scratch/bell/dewoody/LEPC/JY-test/${i}/sra/sample.list
done

#for i in GRSG GUSG; do
#cd /scratch/bell/dewoody/LEPC/JY-test/${i}/HET/jobs_het/
#for i in `ls -1 *sh`; do  echo "sbatch $i" ; done > jobs ; source ./jobs
#done

#!/bin/bash
#SBATCH -A fnrpredator
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 14-00:00:00
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.err
#SBATCH --job-name=mitogenome_LEPC
#SBATCH --mail-type=ALL
#SBATCH --mail-user=

cd $SLURM_SUBMIT_DIR
module --force purge
module load bioinfo


while read -a line
do
        echo "#!/bin/sh -l
#SBATCH -A fnrpredator
#SBATCH -N 1
#SBATCH -n 10
#SBATCH -t 01-00:00:00
#SBATCH --job-name=${line[0]}_mito_LEPC
#SBATCH --error=${line[0]}_mito.err
#SBATCH --output=${line[0]}_mito.out

module --force purge
module load bioinfo
module load MITObim/1.8
module load bioinfo
module load bwa
module load picard-tools
module load bedops
module load GATK/3.6.0
module load samtools
export coalpath=/scratch/bell/amularo/LEPC/mtDNA_mitobim_Cminimus_reference/CoalQC/scripts
cd $SLURM_SUBMIT_DIR
mkdir ${line[0]}
cd ${line[0]}

#Preparing the bam alignment file - use available reference mitogenome in NCBI and mapped the reads to it.

/scratch/bell/amularo/LEPC/mtDNA_mitobim_Cminimus_reference/CoalQC/scripts/coalqc map -g /scratch/bell/amularo/LEPC/mtDNA_practice/CM016737.1.fasta -f /scratch/bell/amularo/LEPC/OLD_fastq_files/${line}_*_R1_001.fastq -r /scratch/bell/amularo/LEPC/OLD_fastq_files/${line}_*_R2_001.fastq -p ./mapped_${line[0]} -n 5



samtools view -b -F 4 mapped_${line[0]}/mapped_${line[0]}.sort.bam > mapped_${line[0]}.bam



#Convert bam files over to fastq

samtools bam2fq ./mapped_${line[0]}.bam > mapped_${line[0]}.fastq

#modify headers for forward and paired reads

cat mapped_${line[0]}.fastq | grep '^@.*/1$' -A 3 --no-group-separator > mapped_${line[0]}_r1.fastq
cat mapped_${line[0]}.fastq | grep '^@.*/2$' -A 3 --no-group-separator > mapped_${line[0]}_r2.fastq
gzip mapped_${line[0]}_r1.fastq mapped_${line[0]}_r2.fastq





#Interleave mapped fastq paired-end reads
interleave-fastqgz-MITOBIM.py mapped_${line[0]}_r1.fastq.gz mapped_${line[0]}_r2.fastq.gz > LEPC_${line[0]}_interleaved.fastq



#Run mitobim with congener mt genome with rock Ptarmigan reads that ONLY mapped to it (mapped_mt.fastq)

MITObim.pl -start 1 -end 10 -sample ${line[0]} -ref Ptar_mt_genome -readpool ./LEPC_${line[0]}_interleaved.fastq --quick  /scratch/bell/amularo/LEPC/mtDNA_mitobim_Cminimus_reference/CM016737.1.fasta  &> log5" > ./jobs/${line[0]}_mt.sh


 done < /scratch/bell/amularo/LEPC/mtDNA_practice/samples.txt

# Submit jobs

while read -a sample
do
        cd /scratch/bell/amularo/LEPC/mtDNA_practice/errors-mitobim/
        sbatch /scratch/bell/amularo/LEPC/mtDNA_practice/jobs/${sample}_mt.sh
done < /scratch/bell/amularo/LEPC/mtDNA_practice/samples.txt




&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Create a BED file of intergenic regions                                                            
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#First step is to enter reference genome fasta and annotation GTF file

#Insert reference genome below. 
REF=GCF_016077235.1_ASM1607723v1_genomic.fna 

#Insert GTF file below
GTF=GCF_016077235.1.gtf 

#Load modules and ent
ml biocontainers
ml bedtools
ml samtools

#Index reference fail
samtools faidx $REF

#Extract sequence names and length
cut -f 1-2 $REF.fai > chrom

#Use bedtools to create coordinates of genes
awk 'BEGIN{OFS="\t";} $3=="gene" {print $1,$4-1,$5}' $GTF |
 bedtools sort -g chrom| bedtools merge -i - > genes.bed

#Get coordinates of intergenic regions
cat $GTF | awk 'BEGIN{OFS="\t";} $3=="gene" {print $1,$4-1,$5}' |   bedtools sort -g chrom |   bedtools complement -i stdin -g chrom > inter.bed

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Use BED file of intergenic regions to extract regions from filtered bam files                                                          
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --error=inter_regions.err
#SBATCH --output=inter_regions.out
#SBATCH --job-name=produce_align_SLURMM_jobs
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=

#Move to fastq containing directory
cd /scratch/bell/blackan/LEPC/shotgun/final_bams
mkdir jobs2

while read -a line
do 
        echo "#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -t 05-00:00:00
#SBATCH --job-name=${line[0]}_aln
#SBATCH --error=${line[0]}_aln.e
#SBATCH --output=${line[0]}_aln.o
#SBATCH --mem=30G
module --force purge
module load bioinfo
module load samtools
module load picard-tools
#Move to the bam containing folder
cd /scratch/bell/blackan/LEPC/shotgun/final_bams


samtools view -L inter.bed -hb ${line[0]} | samtools sort - > ${line[0]}_inter.bam 
samtools index ${line[0]}_inter.bam
echo done" > ./jobs2/${line[0]}_aln.sh
done < ./files #This contains the names of the filtered bam files

#for i in `ls -1 north*sh`; do  echo "sbatch $i" ; done > jobs ; source ./jobs

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Create filtered beagle file for Northern population                                                         
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --error=beagle.err
#SBATCH --output=beagle.out
#SBATCH --job-name=produce_regions_SLURMM_jobs


mkdir jobs_beagle
while read -a line
do
  	echo "#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 10
#SBATCH -t 10-00:00:00
#SBATCH --job-name=Beagle_N_${line[0]}
#SBATCH --error=Beagle_N_${line[0]}.e
#SBATCH --output=Beagle_N_${line[0]}.o
#SBATCH --mem=20G
module load biocontainers
module load angsd

#Move to bam folder
cd /scratch/bell/blackan/LEPC/shotgun/angsd_out
angsd -GL 1 -out BEAGLE_NORTH/${line[0]} -r ${line[0]} -minQ 30 -P 10 -doDepth 1 -doCounts 1 -setMinDepthInd 3 \
-minInd 209 -doGlf 2 -doMajorMinor 1 -doMaf 1 -minMaf 0.05 -skipTriallelic 1 -SNP_pval 1e-6 -bam northern_inter.txt \
-minHWEpval 0.05 -doHWE 1  \
-ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa "  > ./jobs_beagle/north_${line[0]}.sh
done < ./regions.txt

#for i in `ls -1 north*sh`; do  echo "sbatch $i" ; done > jobs ; source ./jobs

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Format output files for Northern population                                                         
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#Concatenate split scaffolds:
#cd /scratch/bell/blackan/LEPC/shotgun/angsd_out/BEAGLE_NORTH
#for f in *.beagle.gz; do zcat ${f} | sed 1d   > tmpfile; mv tmpfile ${f}_trim; done
#zcat NW_026294820.1.beagle.gz | head -n 1 > beagle.header
#cat beagle.header  *_trim > north.beagle ; gzip north.beagle 

#Create a list of sites, with header
zcat north.beagle.gz | cut -f 1 | sed 's/NW_/NW./g' | tr "_" "\t" | sed 's/NW./NW_/g' > North_sites.txt 
sed 1d  North_sites.txt | wc -l
#423107 North_sites.txt

#Format beagle file, by removing the first three columns
zcat north.beagle.gz | cut -f 4- | gzip  > north_format.beagle.gz

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Generate LD estimates and filter edges                                                        
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#Generate LD for Northern DPS

#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 128
#SBATCH -t 14-00:00:00
#SBATCH --job-name=LD_pruneN
#SBATCH --error=LD_prune.e
#SBATCH --output=LD_prune.o
#SBATCH --mem=249G

source  /etc/bashrc 
module reset
module --force purge
module load anaconda/2020.11-py38
conda activate ld
ml gcc
ml zlib
ml gsl


~/ngsLD/ngsLD --geno north_format.beagle.gz --probs --n_ind 261 --n_sites 423107 --outH north.ld --posH North_sites.txt --n_threads 128 --min_maf 0.05 

#Remove physically linked sites, after removing header in north.ld file
 ~/prune_graph/target/release/prune_graph --in north.ld --weight-field column_7 --weight-filter "column_3 <= 50000 && column_7 >= 0.5" --out northLD_unlinked.pos
 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Create beagle file of filtered sites for Southern population                                                       
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#!/bin/bash
#SBATCH -A fnrchook
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH --error=beagle.err
#SBATCH --output=beagle.out
#SBATCH --job-name=produce_regions_SLURMM_jobs


mkdir jobs_beagle
while read -a line
do
  	echo "#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 10
#SBATCH -t 10-00:00:00
#SBATCH --job-name=Beagle_N_${line[0]}
#SBATCH --error=Beagle_S_${line[0]}.e
#SBATCH --output=Beagle_S_${line[0]}.o
#SBATCH --mem=20G
module load biocontainers 
module load angsd

#Move to bam folder
cd /scratch/bell/blackan/LEPC/shotgun/angsd_out
angsd -GL 1 -out BEAGLE_SOUTH/${line[0]} -r ${line[0]} -minQ 30 -P 10 -doDepth 1 -doCounts 1 -setMinDepthInd 3 \
-minInd 120 -doGlf 2 -doMajorMinor 1 -doMaf 1 -minMaf 0.05 -skipTriallelic 1 -SNP_pval 1e-6 -bam southern_inter.txt  \
-minHWEpval 0.05 -doHWE 1  \
-ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa "  > ./jobs_beagle/south_${line[0]}.sh
done < ./regions.txt

#for i in `ls -1 south*sh`; do  echo "sbatch $i" ; done > Jobs ; source ./Jobs

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Format output files for Southern population                                                       
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#Concatenate split scaffolds:
#cd /scratch/bell/blackan/LEPC/shotgun/angsd_out/BEAGLE_SOUTH
#for f in *.beagle.gz; do zcat ${f} | sed 1d   > tmpfile; mv tmpfile ${f}_trim; done
#zcat NW_026294820.1.beagle.gz | head -n 1 > beagle.header
#cat beagle.header  *_trim > south.beagle ; gzip south.beagle 

#Get file of sites, with header
zcat south.beagle.gz | cut -f 1 | sed 's/NW_/NW./g' | tr "_" "\t" | sed 's/NW./NW_/g'  > South_sites.txt
sed 1d wc -l South_sites.txt
#4601119 South_sites.txt
#Format beagle file, by removing the first three columns
zcat south.beagle.gz | cut -f 4- | gzip  > south_format.beagle.gz

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Generate LD estimates and filter edges for Southern population                                                       
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 128
#SBATCH -t 14-00:00:00
#SBATCH --job-name=LD_prune
#SBATCH --error=LD_prune.e
#SBATCH --output=LD_prune.o
#SBATCH --mem=249G

source  /etc/bashrc 
module reset
module --force purge
module load anaconda/2020.11-py38
conda activate ld
ml gcc
ml zlib
ml gsl

~/ngsLD/ngsLD --geno south_format.beagle.gz --probs --n_ind 150 --n_sites 4601119 --outH south.ld --posH South_sites.txt --n_threads 128 --call_geno --min_maf 0.05 

#Remove physically linked sites, after removing header in south.ld file
 ~/prune_graph/target/release/prune_graph --header --in south.ld --weight-field column_7 --weight-filter "column_3 <= 50000 && column_7 >= 0.5" --out southLD_unlinked.pos

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Create shared unlinked sites among populations and index                                                       
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 
 # Identify unlinked sites that are shared between both populations
 wc -l *pos
  #341560 northLD_unlinked.pos
 #101861 southLD_unlinked.pos
  
 awk 'NR==FNR {a[$1]; next} $1 in a' southLD_unlinked.pos northLD_unlinked.pos > sites.match

#Shared sites
 wc -l sites.match 
#35753 sites.matc

#Change delim and copy for new beagle file generation
 sed 's|:|\t|g' sites.match > ../LD.sites 

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Create beagle file for final LD estimate for Southern population                                                      
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 10
#SBATCH -t 10-00:00:00
#SBATCH --job-name=Beagle_S
#SBATCH --error=Beagle_S.e
#SBATCH --output=Beagle_S.o
#SBATCH --mem=50G
module load biocontainers 
module load angsd

#Move to bam folder
cd /scratch/bell/blackan/LEPC/shotgun/angsd_out
mkdir LD_SOUTH
angsd -GL 1 -out LD_SOUTH/ -sites LD.sites -P 10 -bam southern_inter.txt \
doGlf 2 -doMajorMinor 1 -doMaf 1   \
-ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa 

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Format output for Southern population and calculate R2 for southern population                                                 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
#Get file of sites, with header
zcat LD_SOUTH.beagle.gz | cut -f 1 | sed 's/NW_/NW./g' | tr "_" "\t" | sed 's/NW./NW_/g'  > South_sites.txt
sed 1d South_sites.txt | wc -l 
#35753
#Format beagle file, by removing the first three columns
zcat LD_SOUTH.beagle.gz | cut -f 4- | gzip  > south_format.beagle.gz

~/ngsLD/ngsLD --geno south_format.beagle.gz --probs --n_ind 150 --n_sites 35753 --outH filtered_south.LD --posH South_sites.txt --n_threads 20 --min_maf 0.05 

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Create beagle file for final LD estimate for Northern population                                                      
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#!/bin/sh -l
#SBATCH -A fnrchook
#SBATCH -n 10
#SBATCH -t 10-00:00:00
#SBATCH --job-name=Beagle_N
#SBATCH --error=Beagle_N.e
#SBATCH --output=Beagle_N.o
#SBATCH --mem=50G
module load biocontainers 
module load angsd

#Move to bam folder
cd /scratch/bell/blackan/LEPC/shotgun/angsd_out
mkdir LD_NORTH
angsd -GL 1 -out LD_NORTH -sites LD.sites -P 10 -bam northern_inter.txt \
-doGlf 2 -doMajorMinor 1 -doMaf 1   \
-ref /scratch/bell/blackan/LEPC/shotgun/ncbi/ref_100kb.fa 

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Format output for Southern population and calculate R2 for Northern population                                                 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#Get file of sites, with header
zcat LD_NORTH.beagle.gz | cut -f 1 | sed 's/NW_/NW./g' | tr "_" "\t" | sed 's/NW./NW_/g'  > North_sites.txt
 sed 1d North_sites.txt | wc -l
 #35753

#Format beagle file, by removing the first three columns
zcat LD_NORTH.beagle.gz | cut -f 4- | gzip  > north_format.beagle.gz

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                   Format output for Southern population and calculate R2 for southern population                                                 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#Calculate LD for unlinked sites
~/ngsLD/ngsLD --geno north_format.beagle.gz --probs --n_ind 261 --n_sites 35753 --outH filtered_north.LD --posH North_sites.txt --n_threads 20 --min_maf 0.05 



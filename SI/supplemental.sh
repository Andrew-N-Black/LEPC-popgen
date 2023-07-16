#Figure S1

samtools index GCF_026119805.1_pur_lepc_1.0_genomic.fna
cat GCF_026119805.1_pur_lepc_1.0_genomic.fna.fai | cut -d " " -f 1,2 > seqs
#modify seqs with excel for plotting





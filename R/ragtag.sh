conda install --name rag -c bioconda ragtag
source activate rag
ragtag.py correct ../ncbi_chicken/Gallus_gallus_gca016700215v2.bGalGal1.pat.whiteleghornlayer.GRCg7w.dna_rm.toplevel.fa GCF_026119805.1_pur_lepc_1.0_genomic.fna 

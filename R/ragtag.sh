conda install --name rag -c bioconda ragtag
source activate rag
ragtag.py correct ../ncbi_chicken/Gallus_gallus_gca016700215v2.bGalGal1.pat.whiteleghornlayer.GRCg7w.dna_rm.toplevel.fa GCF_026119805.1_pur_lepc_1.0_genomic.fna 



" did, but not using RagTag. at this point in the RagTag assembly you should have a .agp file. I used the .agp file with agptools (https://github.com/WarrenLab/agptools) to finish the assembly step that kept failing in this step in RagTag. This is what that looks like:

agptools assemble combined.fasta ragtag.scaffold.agp > corrected_scaffolds.fasta

combined.fasta = the original contig assembly fasta file that you put into RagTag
ragtag.scaffold.agp = the new file that ragtag assembled (this file has all the data on how the contigs fit together)
corrected_scaffolds = the name that you want to name your scaffold assembly.

this worked decently quickly for me and seemed to have given me a food final scaffold assembly!"

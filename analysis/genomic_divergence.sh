module load biocontainers
module load minimap2/2.26

#genomes to align
GEN1="/path/to/genome1"
GEN2="/path/to/genome2"

#align with minimap
minimap2 -cx asm5 -t8 --cs "$GEN1" "$GEN2" > aligned.paf
sort -k6,6 -k8,8n aligned.paf > aligned.srt.paf
paftools.js call aligned.srt.paf > aligned.var.txt

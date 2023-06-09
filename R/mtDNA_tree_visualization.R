
## Set working directory 
wd<- "C://Users/andre/OneDrive/Documents/DeWoody Lab/LEPC/mtDNA/Redo_April2023"
setwd(wd)

## Load packages

library("ggplot2")
library("ggtree")
library("treeio")
library("ggplot2")
library("reshape2")
library("ggstance")
library("tidyverse")

LEPC_tree<- read.tree("muscle_alignment.fasta.treefile")
labels<- read.csv("Tip_labels2.csv",stringsAsFactors = FALSE)

tree1<- full_join(as_tibble(LEPC_tree), labels, by = c('label' = 'ID'))
tree2<- as.treedata(tree1)

labels$DPS<- na.omit(labels$DPS)

p1<- ggtree(tree2, layout = "circular", branch.length = "none")+ 
  geom_treescale(x=0, y=60,offset.label = 50)+
  geom_tippoint(aes(color = Species, shape = DPS), size = 17, alpha = 1, position = "identity")+
  scale_color_manual(values = c("goldenrod", "brown"))+
  scale_shape_manual(values = c(15,20,0))+
  theme(legend.text = element_text(face = "italic", size = 80), 
        legend.title = element_text(face = "bold", size = 100))
  
p1 

ggsave(plot = p1, "LEPC_GPC_mtDNA.png", height = 85, width = 85, dpi=300, limitsize = FALSE)
  



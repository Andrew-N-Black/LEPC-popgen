library(ggplot2)
library(readxl)
library(ggpubr)
library(dplyr)

HET_FILT <- read_xlsx("~/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")


ggplot(HET_FILT,aes(x=DPS,y=HET,fill=SPECIES))+geom_boxplot()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+xlab("")+ylab("Individual Heterozygosity")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ylim(0.0018,0.0058)+theme(legend.position="top")

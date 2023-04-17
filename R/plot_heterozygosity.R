library(ggplot2)
library(readxl)
library(ggpubr)
library(dplyr)

HET_FILT <- read_xlsx("~/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")

#By DPS and Species
HET_FILT$DPS <- ordered(HET_FILT$DPS,levels = c("Outside","Northern","Southern"))
ggplot(HET_FILT,aes(x=DPS,y=HET,fill=SPECIES))+geom_boxplot()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+xlab("")+ylab("Individual Heterozygosity")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ylim(0.0018,0.0058)+theme(legend.position="top")

#By DPS and Species and Year
HET_FILT$DPS <- ordered(HET_FILT$DPS,levels = c("Outside","Northern","Southern"))
HET_FILT$YEAR <- ordered(HET_FILT$YEAR,levels = c("2008","2009","2010","2013","2014","2019","2020","2021","2022","2023"))
ggplot(HET_FILT,aes(x=YEAR,y=HET,fill=SPECIES))+geom_boxplot()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+xlab("")+ylab("Individual Heterozygosity")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ylim(0.0018,0.0058)+theme(legend.position="top")+facet_wrap(~DPS,ncol=1)


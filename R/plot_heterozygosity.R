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

#Test for normality
shapiro.test(HET_FILT$HET)

data:  HET_FILT$HET
W = 0.79502, p-value < 2.2e-16

HET_FILT$DPS<-factor(HET_FILT$DPS,levels = c("Outside","Northern","Southern"))

group_by(HET_FILT, DPS) %>%
    summarise(
        count = n(),
        mean = mean(HET, na.rm = TRUE),
        sd = sd(HET, na.rm = TRUE),
        median = median(HET, na.rm = TRUE),
        IQR = IQR(HET, na.rm = TRUE)
    )

 DPS     count    mean      sd  median     IQR
  <ord>   <int>   <dbl>   <dbl>   <dbl>   <dbl>
1 Outside     6 0.00329 1.25e-4 0.00329 1.39e-4
2 Northe…   277 0.00341 5.17e-4 0.00326 4.00e-4
3 Southe…   150 0.00295 3.27e-4 0.00289 1.87e-4

kruskal.test(HET ~ DPS, data = HET_FILT)

Kruskal-Wallis chi-squared = 195.31, df =
2, p-value < 2.2e-16

pairwise.wilcox.test(HET_FILT$HET, HET_FILT$DPS, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$HET and HET_FILT$DPS 

         Outside Northern
Northern 0.8146  -       
Southern 0.0002  <2e-16  

P value adjustment method: BH 


#BY SPECIES
HET_FILT$SPECIES<-factor(HET_FILT$SPECIES,levels = c("Tympanuchus pallidicinctus","Tympanuchus cupido"))

group_by(HET_FILT, SPECIES) %>%
    summarise(
        count = n(),
        mean = mean(HET, na.rm = TRUE),
        sd = sd(HET, na.rm = TRUE),
        median = median(HET, na.rm = TRUE),
        IQR = IQR(HET, na.rm = TRUE)
    )

 SPECIES count    mean      sd
  <fct>   <int>   <dbl>   <dbl>
1 Tympan…   411 0.00324 5.16e-4
2 Tympan…    22 0.00339 1.84e-4

pairwise.wilcox.test(HET_FILT$HET, HET_FILT$SPECIES, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$HET and HET_FILT$SPECIES 

                   Tympanuchus pallidicinctus
Tympanuchus cupido 7.4e-05                   

P value adjustment method: BH 



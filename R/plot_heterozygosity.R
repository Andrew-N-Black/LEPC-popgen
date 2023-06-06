library(ggplot2)
library(readxl)
library(ggpubr)
library(dplyr)

HET_FILT <- read_xlsx("~/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")

#By DPS and Species
HET_FILT$DPS <- ordered(HET_FILT$DPS,levels = c("Outside","Northern","Southern"))
ggplot(HET_FILT,aes(x=DPS,y=HET,fill=SPECIES))+geom_boxplot()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("")+ylab("Individual Heterozygosity")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ylim(0.0018,0.0058)+theme(legend.position="top")

#By DPS and Species and Year
HET_FILT$DPS <- ordered(HET_FILT$DPS,levels = c("Outside","Northern","Southern"))
HET_FILT$YEAR <- ordered(HET_FILT$YEAR,levels = c("2008","2009","2010","2013","2014","2019","2020","2021","2022","2023"))
ggplot(HET_FILT,aes(x=YEAR,y=HET,fill=SPECIES,color=SPECIES))+geom_boxplot()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("")+ylab("Individual Heterozygosity")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ylim(0.0018,0.0058)+theme(legend.position="top")+facet_wrap(~DPS,ncol=1)+scale_color_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))

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

  DPS     count    mean      sd
  <ord>   <int>   <dbl>   <dbl>
1 Outside     9 0.00330 1.07e-4
2 Northe…   274 0.00341 5.19e-4
3 Southe…   150 0.00295 3.27e-4
# ℹ 2 more variables:
#   median <dbl>, IQR <dbl>


kruskal.test(HET ~ DPS, data = HET_FILT)

Kruskal-Wallis chi-squared
= 195.44, df = 2, p-value
< 2.2e-16

pairwise.wilcox.test(HET_FILT$HET, HET_FILT$DPS, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$HET and HET_FILT$DPS 

         Outside Northern
Northern 0.68    -       
Southern 5e-06   <2e-16  

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

# A tibble: 2 × 6
  SPECIES count    mean      sd
  <fct>   <int>   <dbl>   <dbl>
1 Tympan…   411 0.00324 5.16e-4
2 Tympan…    22 0.00339 1.84e-4
# ℹ 2 more variables:
#   median <dbl>, IQR <dbl>

pairwise.wilcox.test(HET_FILT$HET, HET_FILT$SPECIES, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$HET and HET_FILT$SPECIES 

                   Tympanuchus pallidicinctus
Tympanuchus cupido 7.4e-05                   

P value adjustment method: BH 



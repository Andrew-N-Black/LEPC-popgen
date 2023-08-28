#Load libraries
library(ggplot2)
library(readxl)
library(ggpubr)
library(dplyr)

#By DPS and Species
#load metadata
HET_FILT <- read_xlsx("metadata_filt.xlsx")
HET_FILT$DPS <- ordered(HET_FILT$DPS,levels = c("Allopatric","Sympatric","Northern","Southern"))
#Plot
ggplot(HET_FILT,aes(y=HET,fill=SPECIES))+geom_boxplot()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("")+ylab("H")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ theme(axis.text.y = element_text(size=12))+ylim(0.0018,0.0058)+theme(legend.position="none")+theme(axis.text=element_text(size=14),axis.title=element_text(size=22,face="italic"))+theme(strip.text = element_text(size = 18))+facet_wrap(~DPS,ncol=4)+theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())

#By DPS and Species and Year
#load metadata
HET_FILT <- read_xlsx("metadata_filt.xlsx")
HET_FILT$DPS <- ordered(HET_FILT$DPS,levels = c("Allopatric","Sympatric","Northern","Southern"))
HET_FILT$YEAR <- ordered(HET_FILT$YEAR,levels = c("2008","2009","2010","2013","2014","2019","2020","2021","2022","2023"))
#Plot
ggplot(HET_FILT,aes(x=YEAR,y=HET,fill=SPECIES,color=SPECIES))+geom_boxplot(color="black",size=0.2)+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("")+ylab("H")+theme_classic()+ theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=12))+ylim(0.0018,0.0058)+theme(legend.position="none")+facet_wrap(~DPS,ncol=4)+scale_color_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+ theme(axis.text.y = element_text(size=12))+theme(legend.position="none")+theme(axis.text=element_text(size=14),axis.title=element_text(size=22,face="italic"))+theme(strip.text = element_text(size = 18))

#Test for normality
shapiro.test(HET_FILT$HET)

data:  HET_FILT$HET
W = 0.79502, p-value < 2.2e-16

#Pairwise test of heterozygosity by ecoregion
pairwise.wilcox.test(HET_FILT$HET, HET_FILT$HABITAT, p.adjust.method = "BH")

#Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

#data:  HET_FILT$HET and HET_FILT$HABITAT
      EOR     MGPR    SHGPR   SSBPR
MGPR  0.664   -       -       -    
SHGPR 0.862   0.664   -       -    
SSBPR 0.111   0.147   0.111   -    
SSOPR 1.1e-05 < 2e-16 < 2e-16 0.039

#Load df containing only lesser prairie chicken and N/S DPS
HET_FILT <- read_xlsx("metadata_filt_LEPC.xlsx")
HET_FILT$DPS<-factor(HET_FILT$DPS,levels = c("Northern","Southern"))

#Summary stats for heterozygosity
group_by(HET_FILT, DPS) %>%
    summarise(
        count = n(),
        mean = mean(HET, na.rm = TRUE),
        sd = sd(HET, na.rm = TRUE),
        median = median(HET, na.rm = TRUE),
        IQR = IQR(HET, na.rm = TRUE)
    )

  DPS      count    mean       sd  median      IQR
  <fct>    <int>   <dbl>    <dbl>   <dbl>    <dbl>
1 Northern   261 0.00340 0.000530 0.00325 0.000401
2 Southern   150 0.00295 0.000327 0.00289 0.000187

#Pairwise test by DPS
pairwise.wilcox.test(HET_FILT$HET, HET_FILT$DPS, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$HET and HET_FILT$DPS 

         Northern
Southern <2e-16  

P value adjustment method: BH  

#BY SPECIES
HET_FILT$SPECIES<-factor(HET_FILT$SPECIES,levels = c("Tympanuchus pallidicinctus","Tympanuchus cupido"))

#summary stats by species
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

#Pairwise test for species.
pairwise.wilcox.test(HET_FILT$HET, HET_FILT$SPECIES, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$HET and HET_FILT$SPECIES 

                   Tympanuchus pallidicinctus
Tympanuchus cupido 7.4e-05                   

P value adjustment method: BH 



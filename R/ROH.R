#Load library
library(reshape2)
library(ggplot2)

#read in metadata
metadata <- read_xlsx("metadata_filt.xlsx")

#Extract relevant information
sub<-metadata[,c("ID","DPS","SPECIES","fROH_100kb-1Mb","fROH_1Mb","fROH_total")]

#Convert to long format
melt_data<-melt(sub,id.vars = c("ID","DPS","SPECIES"))
melt_data$DPS <- factor(melt_data$DPS, levels = c("Allopatric","Sympatric","Northern", "Southern"))

#Plot ROH by groups
ggplot(melt_data, aes(fill=SPECIES, y=value, x=reorder(ID,value))) +geom_bar(stat="identity",position="dodge")+facet_grid(variable~DPS,scales = "free")+theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+theme_classic()+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+ylab("fROH")+xlab("Sample (N=433)")+theme(legend.position="none")+theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())+theme(axis.text.y = element_text(size=12))+theme(legend.position="none")+theme(axis.text=element_text(size=14),axis.title=element_text(size=22,face="italic"))+theme(strip.text = element_text(size = 18))

#Test for normality
shapiro.test(HET_FILT$`fROH_100kb-1Mb`)
shapiro.test(HET_FILT$`fROH_1Mb`)
shapiro.test(HET_FILT$`fROH_total`)

data:  HET_FILT$HET
W = 0.79502, p-value < 2.2e-16

#Load df containing only lesser prairie chicken and N/S DPS
HET_FILT <- read_xlsx("metadata_filt_LEPC.xlsx")
HET_FILT$DPS<-factor(HET_FILT$DPS,levels = c("Northern","Southern"))

#Summary statistics for fROH total
group_by(HET_FILT, DPS) %>%
    summarise(
        count = n(),
        mean = mean(fROH_total, na.rm = TRUE),
        sd = sd(fROH_total, na.rm = TRUE),
        median = median(fROH_total, na.rm = TRUE),
        IQR = IQR(fROH_total, na.rm = TRUE)
    )

  DPS      count   mean     sd median    IQR
  <chr>    <int>  <dbl>  <dbl>  <dbl>  <dbl>
1 Northern   261 0.0494 0.0626 0.0264 0.0797
2 Southern   150 0.0991 0.0457 0.0862 0.0438

#Pairwise test
pairwise.wilcox.test(HET_FILT$`fROH_total`, HET_FILT$DPS, p.adjust.method = "BH")

	Pairwise comparisons using Wilcoxon rank sum test with continuity correction 

data:  HET_FILT$fROH_total and HET_FILT$DPS 

         Northern
Southern <2e-16  
#Summary statistics for fROH >1Mb

	group_by(HET_FILT, DPS) %>%
    summarise(
        count = n(),
        mean = mean(fROH_1Mb, na.rm = TRUE),
        sd = sd(fROH_1Mb, na.rm = TRUE),
        median = median(fROH_1Mb, na.rm = TRUE),
        IQR = IQR(fROH_1Mb, na.rm = TRUE)
    )
 DPS      count   mean     sd  median    IQR
  <chr>    <int>  <dbl>  <dbl>   <dbl>  <dbl>
1 Northern   261 0.0112 0.0206 0.00155 0.0142
2 Southern   150 0.0203 0.0165 0.0165  0.0172


#Pairwise for fROH total
pairwise.wilcox.test(HET_FILT$`fROH_1Mb`, HET_FILT$DPS, p.adjust.method = "BH")
data:  HET_FILT$fROH_1Mb and HET_FILT$DPS 

         Northern
Southern <2e-16  

#Summary statistics for fROH 100kb
group_by(HET_FILT, DPS) %>%
    summarise(
        count = n(),
        mean = mean(fROH_100kb-1Mb, na.rm = TRUE),
        sd = sd(fROH_100kb-1Mb, na.rm = TRUE),
        median = median(fROH_100kb-1Mb, na.rm = TRUE),
        IQR = IQR(fROH_100kb-1Mb, na.rm = TRUE)
    )

group_by(HET_FILT, DPS) %>%
+     summarise(count = n(), mean = mean(`fROH_100kb-1Mb`, na.rm = TRUE), sd = sd(`fROH_100kb-1Mb`, na.rm = TRUE),median = median(`fROH_100kb-1Mb`, na.rm = TRUE),IQR = IQR(`fROH_100kb-1Mb`, na.rm = TRUE))
# A tibble: 2 × 6
  DPS      count   mean     sd median    IQR
  <chr>    <int>  <dbl>  <dbl>  <dbl>  <dbl>
1 Northern   261 0.0382 0.0432 0.0251 0.0634
2 Southern   150 0.0788 0.0301 0.0710 0.0269


#Summary statistics for fROH 100kb
pairwise.wilcox.test(HET_FILT$`fROH_100kb-1Mb`, HET_FILT$DPS, p.adjust.method = "BH")
         Northern
Southern <2e-16  

#BY SPECIES
HET_FILT$SPECIES<-factor(HET_FILT$`fROH_100kb-1Mb`,levels = c("Tympanuchus pallidicinctus","Tympanuchus cupido"))

#Summary statistics for fROH 100kb for each species
group_by(HET_FILT, SPECIES) %>%
    summarise(
        count = n(),
        mean = mean(`fROH_100kb-1Mb`, na.rm = TRUE),
        sd = sd(`fROH_100kb-1Mb`, na.rm = TRUE),
        median = median(`fROH_100kb-1Mb`, na.rm = TRUE),
        IQR = IQR(`fROH_100kb-1Mb`, na.rm = TRUE)
    )

 SPECIES                    count   mean     sd median    IQR
  <fct>                      <int>  <dbl>  <dbl>  <dbl>  <dbl>
1 Tympanuchus pallidicinctus   411 0.0530 0.0435 0.0545 0.0626
2 Tympanuchus cupido            22 0.0442 0.0339 0.0292 0.0620

#Pairwise comparison for fROH 100kb for each species

pairwise.wilcox.test(HET_FILT$`fROH_100kb-1Mb`, HET_FILT$SPECIES, p.adjust.method = "BH")
data:  HET_FILT$`fROH_100kb-1Mb` and HET_FILT$SPECIES 

                   Tympanuchus pallidicinctus
Tympanuchus cupido 0.56 

#Summary statistics for fROH 1Mb for each species
group_by(HET_FILT, SPECIES) %>%
    summarise(
        count = n(),
        mean = mean(`fROH_1Mb`, na.rm = TRUE),
        sd = sd(`fROH_1Mb`, na.rm = TRUE),
        median = median(`fROH_1Mb`, na.rm = TRUE),
        IQR = IQR(`fROH_1Mb`, na.rm = TRUE)
    )
                 
 SPECIES                    count   mean     sd  median    IQR
  <fct>                      <int>  <dbl>  <dbl>   <dbl>  <dbl>
1 Tympanuchus pallidicinctus   411 0.0145 0.0197 0.00696 0.0222
2 Tympanuchus cupido            22 0.0162 0.0191 0.00313 0.0369

#Pairwise for fROH 1Mb for each species
pairwise.wilcox.test(HET_FILT$`fROH_1Mb`, HET_FILT$SPECIES, p.adjust.method = "BH")
data:  HET_FILT$fROH_1Mb and HET_FILT$SPECIES 

                   Tympanuchus pallidicinctus
Tympanuchus cupido 0.62 

#Summary statistics for fROH total for each species
group_by(HET_FILT, SPECIES) %>%
    summarise(
        count = n(),
        mean = mean(`fROH_total`, na.rm = TRUE),
        sd = sd(`fROH_total`, na.rm = TRUE),
        median = median(`fROH_total`, na.rm = TRUE),
        IQR = IQR(`fROH_total`, na.rm = TRUE)
    )

  SPECIES                    count   mean     sd median    IQR
  <fct>                      <int>  <dbl>  <dbl>  <dbl>  <dbl>
1 Tympanuchus pallidicinctus   411 0.0675 0.0618 0.0602 0.0848
2 Tympanuchus cupido            22 0.0605 0.0526 0.0321 0.0998

#Pairwise for fROH total for each species
pairwise.wilcox.test(HET_FILT$`fROH_total`, HET_FILT$SPECIES, p.adjust.method = "BH")
data:  HET_FILT$fROH_total and HET_FILT$SPECIES 

                   Tympanuchus pallidicinctus
Tympanuchus cupido 0.83 



x<-read.csv(("~/South_out_plot.csv"))
x$pop <- factor(x$pop, levels = c("Outside","Southern","Southern_Outside"))
x$Chr <- factor(x$Chr, levels = c("NW_026294618.1","NW_026294619.1","NW_026294620.1","NW_026294627.1","NW_026294636.1","NW_026294637.1","NW_026294648.1","NW_026294659.1","NW_026294660.1","NW_026294669.1","NW_026294679.1","NW_026294686.1","NW_026294690.1","NW_026294699.1","NW_026294710.1","NW_026294721.1","NW_026294722.1","NW_026294733.1","NW_026294739.1","NW_026294740.1","NW_026294741.1","NW_026294742.1","NW_026294743.1","NW_026294744.1","NW_026294745.1","NW_026294746.1","NW_026294747.1","NW_026294748.1","NW_026294749.1","NW_026294750.1","NW_026294751.1","NW_026294752.1","NW_026294753.1","NW_026294754.1","NW_026294755.1","NW_026294756.1","NW_026294757.1","NW_026294759.1","NW_026294760.1","NW_026294761.1","NW_026294762.1","NW_026294763.1","NW_026294764.1","NW_026294765.1","NW_026294766.1","NW_026294767.1","NW_026294768.1","NW_026294769.1","NW_026294770.1","NW_026294771.1","NW_026294772.1","NW_026294773.1","NW_026294774.1","NW_026294775.1","NW_026294776.1","NW_026294777.1","NW_026294778.1","NW_026294779.1","NW_026294780.1","NW_026294781.1","NW_026294782.1","NW_026294783.1","NW_026294784.1","NW_026294785.1","NW_026294786.1","NW_026294787.1","NW_026294788.1","NW_026294789.1","NW_026294790.1","NW_026294791.1","NW_026294792.1","NW_026294793.1","NW_026294794.1","NW_026294795.1","NW_026294796.1","NW_026294797.1","NW_026294798.1","NW_026294800.1","NW_026294801.1","NW_026294802.1","NW_026294803.1","NW_026294804.1","NW_026294805.1","NW_026294806.1","NW_026294807.1","NW_026294808.1","NW_026294809.1","NW_026294810.1","NW_026294811.1","NW_026294812.1","NW_026294816.1","NW_026294818.1","NW_026294820.1","NW_026294821.1","NW_026294822.1","NW_026294823.1","NW_026294813.1","NW_026294758.1"))
ggplot(x,aes(x=chr_mid, y=value,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1,scales = "free_y")+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")






#All groups
library(readxl)
allo <- read_excel("ALLO.thetasWindow.t2.xlsx")
sym <- read_excel("SYM.thetasWindow.t2.xlsx")      
south<- read_excel("south.thetasWindow.t2.xlsx")  
north <- read_excel("north.thetasWindow.t2.xlsx")
allo_sym<-merge(allo,sym,by=("chr_mid"))
write.csv(allo_sym,"~/allo_sym.csv")
allo_sym <- read_excel("allo_sym.xlsx")
allo_sym_north<-merge(allo_sym,north,by=("chr_mid"))
write.csv(allo_sym_north,"~/allo_sym_north.csv")
allo_sym_north <- read_excel("allo_sym_north.xlsx")
allo_sym_north_south<-merge(allo_sym_north,south,by=("chr_mid"))
write.csv(allo_sym_north_south,"~/allo_sym_north_south.csv")
melt_theta <- read_excel("melt_theta.xlsx")

#factor
melt_theta$pop <- factor(melt_theta$pop, levels = c("Allopatric","Sympatric","Northern","Southern"))
melt_theta$Chr <- factor(melt_theta$Chr, levels = c("NW_026294618.1","NW_026294619.1","NW_026294620.1","NW_026294627.1","NW_026294636.1","NW_026294637.1","NW_026294648.1","NW_026294659.1","NW_026294660.1","NW_026294669.1","NW_026294679.1","NW_026294686.1","NW_026294690.1","NW_026294699.1","NW_026294710.1","NW_026294721.1","NW_026294722.1","NW_026294733.1","NW_026294739.1","NW_026294740.1","NW_026294741.1","NW_026294742.1","NW_026294743.1","NW_026294744.1","NW_026294745.1","NW_026294746.1","NW_026294747.1","NW_026294748.1","NW_026294749.1","NW_026294750.1","NW_026294751.1","NW_026294752.1","NW_026294753.1","NW_026294754.1","NW_026294755.1","NW_026294756.1","NW_026294757.1","NW_026294759.1","NW_026294760.1","NW_026294761.1","NW_026294762.1","NW_026294763.1","NW_026294764.1","NW_026294765.1","NW_026294766.1","NW_026294767.1","NW_026294768.1","NW_026294769.1","NW_026294770.1","NW_026294771.1","NW_026294772.1","NW_026294773.1","NW_026294774.1","NW_026294775.1","NW_026294776.1","NW_026294777.1","NW_026294778.1","NW_026294779.1","NW_026294780.1","NW_026294781.1","NW_026294782.1","NW_026294783.1","NW_026294784.1","NW_026294785.1","NW_026294786.1","NW_026294787.1","NW_026294788.1","NW_026294789.1","NW_026294790.1","NW_026294791.1","NW_026294792.1","NW_026294793.1","NW_026294794.1","NW_026294795.1","NW_026294796.1","NW_026294797.1","NW_026294798.1","NW_026294800.1","NW_026294801.1","NW_026294802.1","NW_026294803.1","NW_026294804.1","NW_026294805.1","NW_026294806.1","NW_026294807.1","NW_026294808.1","NW_026294809.1","NW_026294810.1","NW_026294811.1","NW_026294812.1","NW_026294816.1","NW_026294818.1","NW_026294820.1","NW_026294821.1","NW_026294822.1","NW_026294823.1","NW_026294813.1","NW_026294758.1"))

#Plot full genome
ggplot(melt_theta,aes(x=chr_mid, y=pi/50000,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")

#Subset and plot by Z-linked scaffolds
ggplot(subset(melt_theta, Chr %in% c("NW_026294813.1","NW_026294758.1")),aes(x=chr_mid, y=pi/50000,color=Chr)) + geom_line(linewidth=0.35,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")

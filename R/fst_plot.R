Outside_South <- read_excel("Outside-South_both.xlsx")
#Full genome, pi and fst
ggplot(Outside_South,aes(x=chr_mid, y=value,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1,scales="free_y")+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")

#Z-chrom, pi and fst
ggplot(subset(Outside_South, Chr %in% c("NW_026294813.1","NW_026294758.1")),aes(x=WinCenter, y=value,color=Chr)) + geom_line(linewidth=0.2)+facet_wrap(~pop~Chr,ncol = 2,scales="free_y")+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=c("black","grey"))+theme(legend.position = "none")







#fsts, south DPS and Allopatric GRPCs
sout_out_fsts <- read.csv("~/sout_out_fsts.csv")
#Full genome fsts
ggplot(sout_out_fsts,aes(x=chr_mid, y=fst,color=Chr)) + geom_point(size=0.1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("Fst")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+geom_hline(yintercept=0.176, linetype="dashed",color = "blue", size=0.5)+ylim(c(0,1))+ggtitle("Allopatric GRPC vs Southern DPS")
#Z-chrome only, fsts
ggplot(subset(sout_out_fsts, Chr %in% c("NW_026294813.1","NW_026294758.1")),aes(x=WinCenter, y=fst,color=Chr)) + geom_point(size=0.3)+facet_wrap(~Chr,ncol = 2)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+ylab("π") +theme(legend.position = "none")+scale_color_manual(values=c("black","grey"))+theme(legend.position = "none")+geom_hline(yintercept=0.176, linetype="dashed",color = "blue", size=0.5)+ylim(c(0,1))+ggtitle("Allopatric GRPC vs Southern DPS")



library(readxl)
Outside_South_pi <- read_excel("Outside-South_pi.xlsx")
#Full genome, pi
ggplot(Outside_South_pi,aes(x=chr_mid, y=pi,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+ylim(0,0.02)
#Z-chrome only, pi
ggplot(subset(Outside_South_pi, Chr %in% c("NW_026294813.1","NW_026294758.1")),aes(x=WinCenter, y=pi,color=pop)) + geom_line(linewidth=0.2)+facet_wrap(~Chr,ncol = 2)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=c("black","grey"))+theme(legend.position = "none")+ylim(0,0.0075)











all.sym<-read.table("~/slidingwindow_ALLO_SYM.t2",header = T)
all.north<-read.table("~/slidingwindow_ALLO_north.t2",header = T)


allo.sym_allo.north<-merge(all.sym,all.north,by=("chr_mid"))
write.csv(allo.sym_allo.north,"~/allo.sym_allo.north.csv")
allo.sym_allo.north<-read.table("~/allo.sym_allo.north.csv",header=T)

allo.sym_allo.north_south.gpc<-merge(allo_sym_north_south,south.gpc,by=("chr_mid"))


ggplot(allo.sym_allo.north_south.gpc,aes(x=chr_mid, y=pi/50000,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")



#Outside vs southern DPS:
south_outside<-read.table("~/slidingwindow_south_outside_t2",header = T)
ggplot(south_outside,aes(x=chr_mid, y=fst,color=chr)) + geom_line(linewidth=0.09,group=1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("Fst")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+geom_hline(yintercept=0.14, linetype="dashed",color = "blue", size=0.5)+ylim(c(0,1))

#Species level comparison
species<-read.table("~/slidingwindow_species_T2",header = T)
ggplot(south_outside,aes(x=chr_mid, y=fst,color=chr)) + geom_point(size=0.1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("Fst")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+geom_hline(yintercept=0.10, linetype="dashed",color = "blue", size=0.5)+ylim(c(0,1))+ggtitle("GRPC vs LEPC")

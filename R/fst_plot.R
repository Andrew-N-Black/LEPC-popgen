
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

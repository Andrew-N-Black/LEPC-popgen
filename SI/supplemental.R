

#Figure S7

library(ggplot2)
allo <- read_xlsx("~/ALLO.thetasWindow.t2.xlsx")
south <- read_xlsx("south.thetasWindow.t2.xlsx")
allo_south<-merge(x=allo,y=south,by=("chr_mid"))
ggplot(allo_south,aes(x=chr_mid, y=Pi,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+ylim(0,0.03)


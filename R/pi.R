gp.n<-merge(grpc,north,by=("chr_mid"))
three.pop<-merge(gp.n,south,by=("chr_mid"))
melt_data<-melt(x,id.vars = c("chr_mid","chr","mid"))
ggplot(melt_data, aes(x=chr_mid, y=value, colour=variable)) + geom_line(group=1,linewidth=0.5)+facet_wrap(~variable,ncol = 1)+scale_color_manual("Species", values=c("brown","goldenrod","goldenrod")) +theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")



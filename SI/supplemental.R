#Figure S1

library(ggplot2)
length_scaff <- read_excel("length_scaff.xlsx")
ggplot(data=length_scaff, aes(y=lepc_kb_length,x=reorder(lepc_kb_length,lepc_seq)))+geom_bar(stat="identity")+theme_classic()+ylab("Length (kb)")+xlab("Scaffold")+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())+ geom_hline(yintercept=100, linetype="dashed", color = "red")
new<-subset(length_scaff,LengthKB < 100,select=c(Contig,LengthKB))
ggplot(data=new, aes(y=lepc_kb_length,x=reorder(lepc_kb_length,lepc_seq)))+geom_bar(stat="identity")+theme_classic()+ylab("Length (kb)")+xlab("Scaffold")+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())+ geom_hline(yintercept=100, linetype="dashed", color = "red")
new<-subset(length_scaff,lepc_kb_length < 100,select=c(lepc_seq,lepc_kb_length))
ggplot(data=new, aes(y=lepc_kb_length,x=reorder(lepc_kb_length,lepc_seq)))+geom_bar(stat="identity")+theme_classic()+ylab("Length (kb)")+xlab("Scaffold")+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())+ geom_hline(yintercept=100, linetype="dashed", color = "red")

#Figure S2

depth_breadth <- read_excel("metadata.xlsx")
#breadth
ggplot(data=depth_breadth, aes(y=BREADTH_POST, x=reorder(ID,BREADTH_POST),fill=SPECIES))+geom_bar(stat="identity")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("Sample (N=481)")+ylab("Genome Breadth")+theme( axis.ticks.x=element_blank(),axis.text.x = element_blank())+ geom_hline(yintercept=80, linetype="dashed", color = "white", linewidth=1)+ylim(0,100)+theme(legend.position="none")
#mapping
ggplot(data=depth_breadth, aes(y=MAPPING_TOTAL, x=reorder(ID,MAPPING_TOTAL),fill=SPECIES))+geom_bar(stat="identity")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("Sample (N=481)")+ylab("Reads Aligned (%)")+theme( axis.ticks.x=element_blank(),axis.text.x = element_blank())+ylim(c(0,100))+ geom_hline(yintercept=80, linetype="dashed", color = "white", linewidth=1)+theme(legend.position="top")
#depth
ggplot(data=depth_breadth, aes(y=DEPTH_POST, x=reorder(ID,DEPTH_POST),fill=SPECIES))+geom_bar(stat="identity")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown","Tympanuchus cupido"="goldenrod"))+xlab("Sample (N=481)")+ylab("Depth Of Coverage")+theme( axis.ticks.x=element_blank(),axis.text.x = element_blank())+ geom_hline(yintercept=3, linetype="dashed", color = "white", linewidth=1)+theme(legend.position="top")


#Figure S7

library(ggplot2)
allo <- read_xlsx("~/ALLO.thetasWindow.t2.xlsx")
south <- read_xlsx("south.thetasWindow.t2.xlsx")
allo_south<-merge(x=allo,y=south,by=("chr_mid"))
ggplot(allo_south,aes(x=chr_mid, y=Pi,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+ylim(0,0.03)


#Load R packages
library(ggplot2)
library(readxl)

#Subet length of scaffolds and plot
length_scaff <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/length_scaff.xlsx")

new<-subset(length_scaff,lepc_kb_length < 100,select=c(lepc_seq,lepc_kb_length))
ggplot(data=length_scaff, aes(y=lepc_kb_length,x=reorder(lepc_kb_length,lepc_seq)))+geom_bar(stat="identity")+theme_classic()+ylab("Length (kb)")+xlab("Scaffold")+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())+ geom_hline(yintercept=100, linetype="dashed", color = "red")


ggsave("S1.svg")
ggsave("S1.pdf")

ggplot(data=new, aes(y=LengthKB,x=reorder(LengthKB,Contig)))+geom_bar(stat="identity")+theme_classic()+ylab("Length (kb)")+xlab("Contig")+theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())+ geom_hline(yintercept=100, linetype="dashed", color = "red")
ggsave("S1a.svg")
ggsave("S1a.pdf")

#Mapping rate
depth_breadth <- read_excel("~/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata.xlsx")

ggplot(data=depth_breadth, aes(y=MAPPING_TOTAL, x=reorder(ID,MAPPING_TOTAL),fill=SPECIES))+geom_bar(stat="identity")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+xlab("Sample (N=481)")+ylab("Reads Aligned (%)")+theme( axis.ticks.x=element_blank(),axis.text.x = element_blank())+ylim(c(0,100))+ geom_hline(yintercept=80, linetype="dashed", color = "white", linewidth=1)+theme(legend.position="top")
ggsave("S2a.svg")



#Plotting Depth:

depth_breadth <- read_excel("~/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata.xlsx")
ggplot(data=depth_breadth, aes(y=DEPTH_POST, x=reorder(ID,DEPTH_POST),fill=SPECIES))+geom_bar(stat="identity")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+xlab("Sample (N=481)")+ylab("Depth Of Coverage")+theme( axis.ticks.x=element_blank(),axis.text.x = element_blank())+ geom_hline(yintercept=3, linetype="dashed", color = "white", linewidth=1)+theme(legend.position="top")

ggsave("S2b.svg")

#Plotting Breadth
ggplot(data=depth_breadth, aes(y=BREADTH_POST, x=reorder(ID,BREADTH_POST),fill=SPECIES))+geom_bar(stat="identity")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+xlab("Sample (N=481)")+ylab("Genome Breadth")+theme( axis.ticks.x=element_blank(),axis.text.x = element_blank())+ geom_hline(yintercept=80, linetype="dashed", color = "white", linewidth=1)+ylim(0,100)+theme(legend.position="top")
ggsave("S2c.svg")

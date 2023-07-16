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

#Figure S3
library(readxl)
metadata <- read_xlsx("metadata.xlsx")
View(metadata)                              
library(ggplot2)
cov<-as.matrix(read.table("unfiltered2.cov"))
axes<-eigen(cov)
head(axes$values/sum(axes$values)*100)
#[1] 3.6195732 2.7374010
#[3] 0.9086318 0.8477194
#[5] 0.7041967 0.6940067

PC1_3<-as.data.frame(axes$vectors[,1:3])
x<-cbind(PC1_3,metadata)
 #By species and DPS
ggplot(data=x, aes(y=V1, x=V2))+geom_point(size=7,color="black",aes(shape=metadata$DPS,fill=metadata$SPECIES))+ theme_classic() + xlab("PC2 (2.77%)") +ylab("PC1 (3.60%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("Species", values=c("goldenrod","brown"))+scale_shape_manual("DPS", values=c(25,21,21,21))+ theme(legend.position = "top")

#Figure S4
library(readxl)
metadata <- read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")
View(metadata)                              
library(ggplot2)
cov<-as.matrix(read.table("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/final.cov"))
axes<-eigen(cov)
head(axes$values/sum(axes$values)*100)
#[1] 3.6010985 2.7703365 0.9533315
#[4] 0.8708315 0.7294636 0.4497553

PC1_3<-as.data.frame(axes$vectors[,1:3])
x<-cbind(PC1_3,metadata)
 #By species and DPS
ggplot(data=x, aes(y=V1, x=V2))+geom_point(size=7,color="black",aes(shape=metadata$DPS,fill=metadata$SPECIES))+ theme_classic() + xlab("PC2 (2.77%)") +ylab("PC1 (3.60%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("Species", values=c("goldenrod","brown"))+scale_shape_manual("DPS", values=c(25,21,21,21))+ theme(legend.position = "top")

#By EcoRegion
ggplot(data=x, aes(y=V2, x=V1))+geom_point(size=5,pch=21,aes(fill=metadata$HABITAT))+ theme_classic() + xlab("PC2 (3.60%)") +ylab("PC1 (2.77%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+coord_flip()+scale_fill_manual("Ecoregion", values =c("EOR"="red","SSOPR"="bisque","MGPR"="blue","SSBPR"="darkorchid1","SHGPR"="darkolivegreen3"))


#Figure S7

library(ggplot2)
allo <- read_xlsx("~/ALLO.thetasWindow.t2.xlsx")
south <- read_xlsx("south.thetasWindow.t2.xlsx")
allo_south<-merge(x=allo,y=south,by=("chr_mid"))
ggplot(allo_south,aes(x=chr_mid, y=Pi,color=Chr)) + geom_line(linewidth=0.09,group=1)+facet_wrap(~pop,ncol = 1)+theme(axis.text.x=element_text(size=.01, angle=90))+theme_classic()+theme(axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())+ylab("π")+scale_color_manual(values=rep(c("black","grey"),98)) +theme(legend.position = "none")+ylim(0,0.03)


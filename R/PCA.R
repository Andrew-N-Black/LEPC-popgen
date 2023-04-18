library(readxl)
metadata <-read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata.xlsx")
metadata <- read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")
View(metadata)                              
library(ggplot2)
#cov<-as.matrix(read.table("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/filtered.pca.cov"))
cov<-as.matrix(read.table("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/final.cov"))
axes<-eigen(cov)
head(axes$values)
[1] 16.204134 12.465892  4.289778  3.918546
[5]  3.282422  2.023798



PC1_3<-as.data.frame(axes$vectors[,1:3])
x<-cbind(PC1_3,metadata)
 #By species
ggplot(data=x, aes(y=V1, x=V2,fill=SPECIES))+geom_point(size=6,pch=21)+ theme_classic() + xlab("PC2 (12.46%)") +ylab("PC1 (16.20%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+theme(legend.position="top")

#New DPS
 ggplot(data=x, aes(y=V1, x=V2,fill=DPS))+geom_point(size=7,pch=21)+ theme_classic() + xlab("PC1 (18.13%)") +ylab("PC2 (13.71%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("DPS", values=c("white","red","grey22"))
 
 
 
 
 
 
#By EcoRegion
#ggplot(data=PC1_3, aes(y=V2, x=V1))+geom_point(size=5,pch=21,aes(fill=metadata$HABITAT))+ theme_classic() + xlab("PC1 (3.50%)") +ylab("PC2 (1.03%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+coord_flip()+scale_fill_manual("Ecoregion", values =c("Shinnery-Oak"="bisque","Mixed-Grass"="blue","Sand-Sagebrush"="darkorchid1","Shortgrass-CRP-Mosaic"="darkolivegreen3"))
 
#By DPS only
#ggplot(data=PC1_3, aes(y=V2, x=V1,color=as.factor(metadata$DPS)))+geom_point(size=5,colour="black",pch=21,aes(fill=metadata$DPS))+ theme_classic() + xlab("PC1 (3.72%)") +ylab("PC2 (1.06%)")+scale_fill_manual("DPS", values =c("Southern"="yellow","Northern"="brown"))+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+coord_flip()

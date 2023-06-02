library(readxl)
metadata <- read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")
View(metadata)                              
library(ggplot2)
#cov<-as.matrix(read.table("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/filtered.pca.cov"))
cov<-as.matrix(read.table("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/final.cov"))
axes<-eigen(cov)
head(axes$values/sum(axes$values)*100)
#[1] 3.6010985 2.7703365 0.9533315
#[4] 0.8708315 0.7294636 0.4497553



PC1_3<-as.data.frame(axes$vectors[,1:3])
x<-cbind(PC1_3,metadata)
 #By species
ggplot(data=x, aes(y=V1, x=V2,fill=SPECIES))+geom_point(size=6,pch=21)+ theme_classic() + xlab("PC2 (2.77%)") +ylab("PC1 (3.60%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("", values =c("Tympanuchus pallidicinctus"="brown3","Tympanuchus cupido"="darkgoldenrod2"))+theme(legend.position="top")+ annotate(geom="text", x=-0.1, y=-0.01, label="Southern DPS",color="black")

#New DPS
 ggplot(data=x, aes(y=V1, x=V2,fill=DPS))+geom_point(size=7,pch=21)+ theme_classic() + xlab("PC1 (2.77%)") +ylab("PC2 (3.60%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("DPS", values=c("white","red","grey22"))
 
 
 
 
 
 
#By EcoRegion
#ggplot(data=PC1_3, aes(y=V2, x=V1))+geom_point(size=5,pch=21,aes(fill=metadata$HABITAT))+ theme_classic() + xlab("PC1 (3.50%)") +ylab("PC2 (1.03%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+coord_flip()+scale_fill_manual("Ecoregion", values =c("Shinnery-Oak"="bisque","Mixed-Grass"="blue","Sand-Sagebrush"="darkorchid1","Shortgrass-CRP-Mosaic"="darkolivegreen3"))
 
#By DPS only
#ggplot(data=PC1_3, aes(y=V2, x=V1,color=as.factor(metadata$DPS)))+geom_point(size=5,colour="black",pch=21,aes(fill=metadata$DPS))+ theme_classic() + xlab("PC1 (3.72%)") +ylab("PC2 (1.06%)")+scale_fill_manual("DPS", values =c("Southern"="yellow","Northern"="brown"))+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+coord_flip()

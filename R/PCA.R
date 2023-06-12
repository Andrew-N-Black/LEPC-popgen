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
 #By species and DPS
ggplot(data=x, aes(y=V1, x=V2))+geom_point(size=7,color="black",aes(shape=metadata$DPS,fill=metadata$SPECIES))+ theme_classic() + xlab("PC1 (9.4%)") +ylab("PC2 (3.6%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("Species", values=c("goldenrod","brown"))+scale_shape_manual("DPS", values=c(21,24,23))

#By EcoRegion
ggplot(data=x, aes(y=V2, x=V1))+geom_point(size=5,pch=21,aes(fill=metadata$HABITAT))+ theme_classic() + xlab("PC1 (3.60%)") +ylab("PC2 (2.77%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+coord_flip()+scale_fill_manual("Ecoregion", values =c("EOR"="red","SSOPR"="bisque","MGPR"="blue","SSBPR"="darkorchid1","SHGPR"="darkolivegreen3"))



#Load libraries
library(readxl)
library(ggplot2)

#Read in metadata
metadata <- read_xlsx("metadata_filt.xlsx")                             

#Read in covariation matrix
cov<-as.matrix(read.table("final.cov"))

#Extract and calculate eplained variation
axes<-eigen(cov)
head(axes$values/sum(axes$values)*100)
#[1] 3.6010985 2.7703365 0.9533315
#[4] 0.8708315 0.7294636 0.4497553


#Bind vectors with metadata and plot
PC1_3<-as.data.frame(axes$vectors[,1:3])
x<-cbind(PC1_3,metadata)
 #By species and DPS
ggplot(data=x, aes(y=V1, x=V2))+geom_point(size=7,color="black",aes(shape=metadata$DPS,fill=metadata$SPECIES))+ theme_classic() + xlab("PC2 (2.77%)") +ylab("PC1 (3.60%)")+geom_hline(yintercept=0,linetype="dashed")+geom_vline(xintercept =0,linetype="dashed")+scale_fill_manual("Species", values=c("goldenrod","brown"))+scale_shape_manual("DPS", values=c(25,21,21,21))+ theme(legend.position = "top")



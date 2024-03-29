#Full dataset, all 18M sites, K=2 identified
#Load libraries
library(readxl)
library(pophelper)

#load attribute data
#metadata_filt <- read_excel("metadata_filt.xlsx")

#Extract relevant info
both <- as.data.frame(metadata_filt[,c(1,3,5)])
both$LAT<-as.character(both$LAT)


#K2
list<-readQ(files ="pop_K2-combined-merged.txt")

plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","brown"),grplab=both,ordergrp=T,showlegend=F,height=6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.10,grplabsize=1.0,barbordersize=0.1,linesize=0.6,showsp = F,splabsize = 0,outputfilename="grouse_merged_K2",imgtype="pdf",exportpath=getwd(),divtype=1,divcol = "white",splabcol="black",grplabheight=1)

#K3

list<-readQ(files ="pop_K3-combined-merged.txt")
plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","grey32","brown"),grplab=both,ordergrp=T,showlegend=F,height=6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.1,grplabsize=1.0,barbordersize=0.1,linesize=0.6,divtype=1,showsp = F,splabsize = 0,outputfilename="merged_grouseK3",imgtype="pdf",exportpath=getwd(),divcol = "white",splabcol="black",grplabheight=1)

#Subset:

list<-readQ(files ="K2_R2.qopt")
both <- as.data.frame(labels[,c(3,12)])
plotQ(list,returnplot=T,exportplot=T,clustercol=c("brown","goldenrod"),grplab=both,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.10,grplabsize=1.0,barbordersize=0.1,linesize=0.6,showsp = F,splabsize = 0,outputfilename="subset_k2",imgtype="png",exportpath=getwd(),divtype=1,divcol = "white",splabcol="black",grplabheight=1)

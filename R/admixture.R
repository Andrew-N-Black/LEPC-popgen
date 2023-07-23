#Full dataset, all 18M sites, K=2 identified

library(readxl)
library(pophelper)
metadata_filt <- read_excel("Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")
both <- as.data.frame(metadata_filt[,c(3,12)])

#K2
list<-readQ(files ="Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/pop_K2-combined-merged.txt")

plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","brown"),grplab=both,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.10,grplabsize=1.0,barbordersize=0.1,linesize=0.6,showsp = F,splabsize = 0,outputfilename="grouse_merged_K2",imgtype="pdf",exportpath=getwd(),divtype=1,divcol = "white",splabcol="black",grplabheight=1)

#K3

list<-readQ(files ="Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/pop_K3-combined-merged.txt")
plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","black","brown"),grplab=both,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.1,grplabsize=1.0,barbordersize=0.1,linesize=0.6,divtype=1,showsp = F,splabsize = 0,outputfilename="merged_grouseK3",imgtype="pdf",exportpath=getwd(),divcol = "white",splabcol="black",grplabheight=1)

#Subset:

list<-readQ(files ="~/K2_R2.qopt")
both <- as.data.frame(labels[,c(3,12)])
plotQ(list,returnplot=T,exportplot=T,clustercol=c("brown","goldenrod"),grplab=both,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.10,grplabsize=1.0,barbordersize=0.1,linesize=0.6,showsp = F,splabsize = 0,outputfilename="subset_k2",imgtype="png",exportpath=getwd(),divtype=1,divcol = "white",splabcol="black",grplabheight=1)

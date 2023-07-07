#Full dataset, all 18M sites, K=2 identified

library(readxl)
library(pophelper)
labels <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/labels.xlsx")

#K2
list<-readQ(files ="~/pop_K2-combined-merged.Q")
#list<-readQ(files ="~/pop_K2-combined-merged_z_lepc.txt")

plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","brown"),grplab=labels,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.10,grplabsize=1.0,barbordersize=0.1,linesize=0.6,showsp = F,splabsize = 0,outputfilename="grouse_merged_Z",imgtype="png",exportpath=getwd(),divtype=1,divcol = "white",splabcol="black",grplabheight=1)

#K3

list<-readQ(files ="~/pop_K3-combined-merged.Q") #All genome
#list<-readQ(files ="~/pop_K3-combined-merged_lepc_Z.txt") #Z chrom only
plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","darkorchid4","brown"),grplab=labels,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.05,grplabsize=1.0,barbordersize=0.1,linesize=0.4,showsp = F,splabsize = 0,outputfilename="merged_grouseK3",imgtype="pdf",exportpath=getwd(),divcol = "white",splabcol="black",grplabheight=1)


#Sort by Ecoregion
labels <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/labels2.xlsx")
plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","brown"),grplab=labels,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.25,grplabsize=1.0,barbordersize=0.1,linesize=0.4,showsp = F,splabsize = 0,outputfilename="full_grouse",imgtype="pdf",exportpath=getwd(),divcol = "black",splabcol="black",grplabheight=1)

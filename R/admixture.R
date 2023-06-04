#Full dataset, all 18M sites, K=2 identified

library(readxl)
library(pophelper)
labels <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/labels.xlsx")

list<-readQ(files ="~/LEPC_K2_merged.qopt",filetype="clumpp")
plotQ(list,returnplot=T,exportplot=T,clustercol=c("goldenrod","brown"),grplab=labels,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.25,grplabsize=1.0,barbordersize=0.1,linesize=0.4,showsp = F,splabsize = 0,outputfilename="full_grouse",imgtype="pdf",exportpath=getwd(),divcol = "black",splabcol="black",grplabheight=1)

#Fixed sites
library(pophelper)
slist<-readQ(files =c("K2_R1.qopt","K3_R1.qopt","K4_R1.qopt"))
labels <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/labels.xlsx")
plotQ(slist[1:3],returnplot=T,exportplot=T,imgoutput = "join",clustercol=c("darkgoldenrod","darkmagenta","brown","blue"),grplab=labels,ordergrp=T,showlegend=F,height=1.6,indlabsize=1.2,indlabheight=0.08,indlabspacer=1,barbordercolour="black",divsize = 0.3,grplabsize=1.0,barbordersize=0.1,linesize=0.4,showsp = F,splabsize = 0,outputfilename="plotq",imgtype="png",exportpath=getwd(),splab = c("K=2","K=3","K=4"),divcol = "black",splabcol="black",grplabheight=1)


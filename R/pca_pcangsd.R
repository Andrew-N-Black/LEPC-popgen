library(pophelper)

labels <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/labels.xlsx")

list<-readQ(files ="/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/final.admix.6.Q")

plotQ(list,returnplot=T,exportplot=T,clustercol=c("blue","green","cadetblue","orange","yellow","red"),grplab=labels,ordergrp=T,showlegend=F,height=9,indlabsize=1,indlabheight=0,indlabspacer=0,barbordercolour="black",divsize = 0.1,grplabsize=1.3,barbordersize=0,linesize=0.4,showsp = F,splabsize = .1,outputfilename="plotq",imgtype="png",exportpath=getwd(),splab = "K=6",divcol = "black",splabcol="black",grplabheight=0.4,grplabjust = 0.4, grplabangle = -45)

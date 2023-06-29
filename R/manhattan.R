library(qqman)
S_GRPC<-read.table("~/slidingwindow_S_GPC.T2",header = T)
manhattan(subset(N_GRPC, CHR == c(026294758.1,026294813.1)),ylim=c(0,1))

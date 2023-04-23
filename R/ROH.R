library(reshape2)
metadata <- read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")
sub<-metadata[,c("ID","DPS","SPECIES","fROH_100kb-1Mb","fROH_1Mb","fROH_total")]
melt_data<-melt(sub,id.vars = c("ID","DPS","SPECIES"))
melt_data$DPS <- factor(melt_data$DPS, levels = c("Outside","Northern", "Southern"))

ggplot(melt_data, aes(fill=SPECIES, y=value, x=reorder(ID,value))) +geom_bar(stat="identity",position="dodge")+facet_grid(variable~DPS,scales = "free_x")+theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+theme_classic()+
    scale_fill_manual(values=c("darkorchid","tan2"))+ylab("fROH")+xlab("Sample (N=433)")+
    theme(legend.position="none")+theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())

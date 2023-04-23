library(reshape2)
metadata <- read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/metadata_filt.xlsx")
sub<-metadata[,c("ID","DPS","SPECIES","fROH_100kb-1Mb","fROH_1Mb","fROH_total")]
melt_data<-melt(sub,id.vars = c("ID","DPS","SPECIES"))
ggplot(melt_data, aes(fill=variable, y=value, x=reorder(ID,value))) +geom_bar(stat="identity",color="black",size=0.35)+theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+theme_classic()+facet_wrap(~DPS,scales = "free_x",ncol = 1)+
scale_fill_manual(values=c("yellow","brown"))+xlab("Samples")+ylab("fROH")+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

library(reshape2)
library(ggplot2)
thetas <- read_xlsx("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/thetas.xlsx")

#All thetas
melt_data<-melt(thetas,id.vars ="pop"))
ggplot(melt_data,aes(x=pop,y=value))  + geom_bar(stat="identity",size=.5,fill="grey",color="black",)+ labs(x='')+theme_classic()+theme(axis.text = element_text(size = 10))+ theme(axis.title = element_text(size = 10)) +theme(axis.title.x=element_text(face="italic"))+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+facet_wrap(~variable,ncol =1 ,scales = "free_x")+coord_flip()

#Just pi
ggplot(thetas,aes(x=pop,y=Nucleotide_Diversity))  + geom_bar(stat="identity",size=.5,fill="grey",color="black",)+ labs(x='')+theme_classic()+theme(axis.text = element_text(size = 10))+ theme(axis.title = element_text(size = 10)) +theme(axis.title.x=element_text(face="italic"))+ theme(axis.text.x = element_text(angle = 45, hjust = 1))

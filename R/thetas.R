#Load libraries
library(reshape2)
library(ggplot2)

#read in thetas nu div and metadata
thetas <- read_xlsx("thetas.xlsx")
thetas$pop <- factor(thetas$pop, levels = c("Allopatric","Sympatric", "Northern-DPS","Southern-DPS")
                     
#Just pi
ggplot(thetas,aes(x=pop,y=Nucleotide_Diversity))  + geom_bar(stat="identity",size=.5,fill="grey",color="black",)+ labs(x='')+theme_classic()+theme(axis.text = element_text(size = 10))+ theme(axis.title = element_text(size = 10)) +theme(axis.title.x=element_text(face="italic"))+ theme(axis.text.x = element_text(angle = 45, hjust = 1))

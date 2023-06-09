library(ggplot2)
library(readxl)
delta <- read_excel("/Users/andrew/Library/CloudStorage/Box-Box/Personal/Postdoc_Purdue/LEPC/analysis/delta.xlsx")
ggplot(delta,aes(x=K,y=delta))+geom_line(color="black",linetype="solid",linewidth=0.8) + geom_point(color="black",size=4)+theme_classic()+ylab("∆K")
ggsave("~/delta.svg")

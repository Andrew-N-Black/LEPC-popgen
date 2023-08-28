#Load libraries
library(ggplot2)
library(readxl)

#Input deltaK file
delta <- read_excel("delta.xlsx")

#Plot
ggplot(delta,aes(x=K,y=delta))+geom_line(color="black",linetype="solid",linewidth=0.8) + geom_point(color="black",size=4)+theme_classic()+ylab("∆K")


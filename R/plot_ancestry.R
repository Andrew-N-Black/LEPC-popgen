### Map of ancestry coefficients 

## libraries 
#library(devtools)
#devtools::install_github("bcm-uga/TESS3_encho_sen")


library(tess3r)
library(maps)
library(tidyverse)
library(fields)
library(rworldmap)
library(sp)

wd <- "C://Users/andre/OneDrive/Documents/DeWoody Lab/LEPC/Ancestry_Coefficient_Map"
setwd(wd)


coords<- read_csv("coords_lat_long.csv", col_names = NULL)
coords<- as.matrix(coords)

#### K2 Matrix 
k2qmatrix<- as.matrix(read_csv("pop_K2-combined-merged.csv", col_names = F))

dim(k2qmatrix)
dim(coords)

k2qmatrix<- as.qmatrix(k2qmatrix)
class(k2qmatrix)
dim(k2qmatrix)

plot(coords, pch=19, cex=0.4,xlab="Longitude", ylab="Latitude", xlim = c(-110, -90), ylim=c(25,50))

m<- maps::map("state", c("Texas","Oklahoma", "Kansas", "New Mexico", "Colorado", "Nebraska", "South Dakota", "North Daokta", "Minnesota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)

my.colors <- c("goldenrod", "brown")
my.palette <- CreatePalette(my.colors, 9)
p1<- barplot(k2qmatrix, border = NA, space = 0, 
        main = "Ancestry matrix", 
        xlab = "Individuals", ylab = "Ancestry proportions", 
        col.palette = my.palette) -> bp


plot(k2qmatrix, coords, method="map.max", interpol = FieldsKrigModel(10), 
     xlim = c(-104.5, -98.5), ylim=c(32.5,45),
     main="Ancestry Coefficients",
      xlab = "Longitude", ylab="Latitude", 
     resolution=c(300,300), cex=0.7,
     col.palette=my.palette)
maps::map("state", c("Texas"), exact=F,
              boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("New Mexico"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Kansas"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Colorado"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("North Dakota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("South Dakota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Minnesota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Arizona"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Oklahoma"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Nebraska"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Wyoming"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Montana"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)



### K3 Ancestry 

k3qmatrix<- as.matrix(read_csv("pop_K3-combined-merged.csv", col_names = F))

dim(k3qmatrix)

k3qmatrix<- as.qmatrix(k3qmatrix)
class(k3qmatrix)
dim(k3qmatrix)

plot(coords, pch=19, cex=0.4,xlab="Longitude", ylab="Latitude", xlim = c(-110, -90), ylim=c(25,50))

m<- maps::map("state", c("Texas","Oklahoma", "Kansas", "New Mexico", "Colorado", "Nebraska", "South Dakota", "North Daokta", "Minnesota"), exact=F,
              boundary=T, plot=T, col=1, add = T, interior=F)

my.colors <- c("goldenrod", "grey32", "brown")
my.palette <- CreatePalette(my.colors, 9)
barplot(k3qmatrix, border = NA, space = 0, 
        main = "Ancestry matrix", 
        xlab = "Individuals", ylab = "Ancestry proportions", 
        col.palette = my.palette) -> bp


plot(k3qmatrix, coords, method="map.max", interpol = FieldsKrigModel(10), 
     xlim = c(-104.5, -98.5), ylim=c(32.5,45),
     main="Ancestry Coefficients",
     xlab = "Longitude", ylab="Latitude", 
     resolution=c(300,300), cex=0.4,
     col.palette=my.palette)
maps::map("state", c("Texas"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("New Mexico"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Kansas"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Colorado"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("North Dakota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("South Dakota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Minnesota"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Arizona"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Oklahoma"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Nebraska"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Wyoming"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)
maps::map("state", c("Montana"), exact=F,
          boundary=T, plot=T, col=1, add = T, interior=F)








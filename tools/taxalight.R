library(taxalight)

sp <- read.csv("datasets.csv")
tl(sp[1, 1], "gbif") #this first download and import the database

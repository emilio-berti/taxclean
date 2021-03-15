library(fishtree)

sp <- read.csv("datasets.csv")[4, ]
d <- fishtree_taxonomy()
families <- d[d$rank == "family", "name"]
d <- fishtree_taxonomy(rank = families[1:10])


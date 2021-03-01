library(rgnparser)

sp <- read.csv("datasets.csv")
d <- gn_parse_tidy(sp$Dataset1)
d[, c("canonicalfull", "authorship", "year")]

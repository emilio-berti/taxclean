library(taxize)

sp <- read.csv("datasets.csv")[, 1]
gbif <- get_gbifid_(sp) #fuzzy matching ON by default - similar for the other DBs.
d <- classification(sp, db = "gbif")
d <- do.call("rbind", lapply(names(d), function(x) d[[x]][nrow(d[[x]]), ]))
# let's try with the vernacular names
sp2 <- read.csv("datasets.csv")[, 1]
d2 <- classification(sp2, db = "gbif")
d2 <- do.call("rbind", lapply(names(d2), function(x) d2[[x]][nrow(d2[[x]]), ]))
# vernacular names give same reults
cbind(d[, 1], d2[, 1])

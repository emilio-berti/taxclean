library(ritis)

d <- search_scientific("Alyssum")
d[, c("author", "combinedName")]
# get only valid usage tsn
us <- lapply(d$tsn, "usage")
us <- do.call("rbind", us)
# filter with only valid tsn
d <- d[d$tsn %in% us$tsn[us$taxonUsageRating %in% c("valid", "accepted")],
       c("author", "combinedName", "tsn")]
accepted <- sapply(d$tsn, "accepted_names")
accepted <- sapply(accepted, function(x) ifelse(nrow(x) == 0, TRUE, FALSE))
# retain only accepted names
d <- d[d$tsn %in% names(which(accepted)), ]
# get rank of taxa
d$rank <- sapply(d$tsn, function(x) {rank_name(x)$rankname})
# retain only species level names
d <- d[d$rank == "Species", ]
head(d)

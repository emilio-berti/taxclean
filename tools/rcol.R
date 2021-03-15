library(rcol)

data.frame(
	database = cp_datasets()$result$title,
	key = cp_datasets()$result$key,
	name = cp_datasets()$result$alias
)

sp <- read.csv("datasets.csv")[2, 1]
# cp_nu_suggest(sp, 3) #quick but minimial
res <- cp_nu_search(sp) #slower but more comprehensive

ans <- data.frame(
  searched = sp,
  scientific = res$result$usage$name$scientificName,
  authorship = res$result$usage$name$authorship,
  status = res$result$usage$status
)
ans <- unique(ans)
ans$search_name <- ans$searched
ans$scientific_name <- ans$scientific
ans$rank <- NA
ans <- ans[, c("search_name", "scientific_name", "rank", "status")]
write.csv(ans, "searches/rcol.csv")

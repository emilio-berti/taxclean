library(taxa)

sources <- data.frame(
	name = names(database_list),
	description = as.vector(sapply(names(database_list), function(x) {
	database_list[[x]]$description
	}))
)

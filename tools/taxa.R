library(taxa)

sources <- data.frame(
	name = names(database_list),
	description = as.vector(sapply(names(database_list), function(x) {
	database_list[[x]]$description
	}))
)

a = taxon_name("Panthera", "ncbi")
a
taxon_id(124, "ncbi")

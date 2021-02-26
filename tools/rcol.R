library(rcol)

data.frame(
	database = cp_datasets()$result$title,
	key = cp_datasets()$result$key,
	name = cp_datasets()$result$alias
)

cp_nu_suggest("Alyssum bertolonii", 3) #quick but minimial
cp_nu_search() #slower but more comprehensive
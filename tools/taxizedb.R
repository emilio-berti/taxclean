library(dplyr)
library("taxizedb")

sp <- read.csv("datasets.csv")
# download wikidata (GBIF was too big)
db_download_wikidata(overwrite = FALSE)
src <- src_wikidata()

library(tidyverse)
library(taxizedb)
db_dow

databases <- c("col", "gbif", "ncbi", "itis", "tpl", "wfo", "wikidata")

# col --------
db_download_col(overwrite = FALSE)
conn <- DBI::dbConnect(RSQLite::SQLite(), path = src_col()$con@dbname)
col <- sql_collect(src_col(), "SELECT DISTINCT * FROM taxa")$`dwc:scientificName`

# gbif ------
db_download_gbif(overwrite = FALSE)
conn <- DBI::dbConnect(RSQLite::SQLite(), path = src_gbif()$con@dbname)
gbif <- sql_collect(src_gbif(), "SELECT DISTINCT * FROM gbif")$scientificName

# itis ---------
db_download_itis(overwrite = FALSE)
conn <- DBI::dbConnect(RSQLite::SQLite(), path = src_itis()$con@dbname)
itis <- sql_collect(src_itis(), "SELECT DISTINCT * FROM longnames")$completename

# wfo -------
db_download_wfo(overwrite = FALSE)
conn <- DBI::dbConnect(RSQLite::SQLite(), path = src_wfo()$con@dbname)
wfo <- sql_collect(src_wfo(), "SELECT DISTINCT scientificName FROM wfo")$scientificName

# compute overlaps ------
overlaps <- t(combn(databases, 2)) %>%
  as_tibble() %>%
  filter(V1 %in% c("itis", "wfo", "gbif", "col"),
         V2 %in% c("itis", "wfo", "gbif", "col")) %>%
  mutate(common_species_n = modify2(V1, V2, function(x, y) {
    length(intersect(get(x), get(y)))
  }))

write_csv(overlaps, "overlaps.csv")

library(tidyverse)
library(taxizedb)

databases <- c("col", "gbif", "ncbi", "itis", "tpl", "wfo", "wikidata")

# col --------
db_download_col(overwrite = FALSE)
col <- sql_collect(src_col(), "SELECT DISTINCT * FROM taxa")$`dwc:scientificName`

# gbif ------
db_download_gbif(overwrite = FALSE)
gbif <- sql_collect(src_gbif(), "SELECT DISTINCT scientificName FROM gbif")$scientificName

# ncbi -----------
db_download_ncbi(overwrite = FALSE)
ncbi <- sql_collect(src_ncbi(), "SELECT DISTINCT unique_name FROM names
                                  WHERE name_class = 'scientific name'")$unique_name
# itis ---------
db_download_itis(overwrite = FALSE)
itis <- sql_collect(src_itis(), "SELECT DISTINCT completename FROM longnames")$completename

#tpl ---------
db_download_tpl(overwrite = FALSE)
tpl <- sql_collect(src_tpl(), "SELECT DISTINCT scientificname FROM tpl")$scientificname

# wfo -------
db_download_wfo(overwrite = FALSE)
wfo <- sql_collect(src_wfo(), "SELECT DISTINCT scientificName FROM wfo")$scientificName

# wikidata ------
db_download_wikidata(overwrite = FALSE)
wikidata <- sql_collect(src_wikidata(), "SELECT DISTINCT scientific_name FROM wikidata")$scientific_name

# compute overlaps ------
overlaps <- t(combn(databases, 2)) %>%
  as_tibble() %>%
  bind_rows(tibble(V1 = databases, V2 = databases)) %>% #also number of species in each database
  mutate(common_species_n = modify2(V1, V2, function(x, y) {
    if (x == y) {
      length(get(x)) #just number of species in the database
    } else {
      length(intersect(get(x), get(y))) #number of species common to body databases
    }
  }))

write_csv(overlaps, "overlaps.csv")
# write also species list for Venn diagram
species <- list(col = col,
                gbif = gbif,
                ncib = ncbi,
                itis = itis,
                tpl = tpl,
                wfo = wfo,
                wikidata = wikidata)
write_rds(species, "species_list.rds")

library(tidyverse)

biotime <- read_csv("biotime.csv") %>%
  pull(x)
kingdom <- parallel::parSapply(
  cl = parallel::makeCluster(getOption("cl.cores", 6)),
  X = biotime,
  FUN = function(x) rgbif::name_backbone(x)$kingdom
) %>%
  unlist()

names(kingdom == "Animalia") %>%
  as_tibble() %>%
  write_csv("data/biotime_animals.csv", col_names = FALSE)
names(kingdom == "Plantae") %>%
  as_tibble() %>%
  write_csv("data/biotime_plants.csv", col_names = FALSE)
names(kingdom == "Fungi") %>%
  as_tibble() %>%
  write_csv("data/biotime_fungi.csv", col_names = FALSE)
names(kingdom == "Chromista") %>% #are these algae? any expert?
  as_tibble() %>%
  write_csv("data/biotime_algae.csv", col_names = FALSE)
names(kingdom == "Bacteria") %>%
  as_tibble() %>%
  write_csv("data/biotime_bacteria.csv", col_names = FALSE)

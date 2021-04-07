library(tidyverse)

d <- read_csv("datasets.csv")[, 1]
gn <- read_csv("results/rgnparser.csv") %>%
  mutate(step = "rgnparser")
gbif <- read_csv("results/rgbif.csv") %>%
  mutate(step = "rgbif")
tnrs <- read_csv("results/RTNRS.csv") %>%
  mutate(step = "RTNRS")

bind_cols(original = d$Dataset1,
          gn = gn$canonicalfull,
          gbif = gbif$scientific_name,
          tnrs = tnrs$scientific_name)

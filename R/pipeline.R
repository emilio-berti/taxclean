source("tools/algaeClassify.R")
source("tools/rotl.R")
source("tools/rgnparser.R")

library(magrittr)
library(dplyr)

d <- read.csv("datasets.csv")[, 1]
d %>%
  tc_rgnparser() %>%
  pull(canonicalfull) %>%
  tc_rotl()

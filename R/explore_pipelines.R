library(tidyverse)
source("R/pipeline.R")
source("R/utilities.R")

available <- list.files("R")
available <- gsub("[.]R", "", available)

# plants ------------
write_pipeline(pkgs = c("RTNRS", "rgbif", "rentrez", "rcol",
                        "lcvplants", "algaeClassify",
                        "rtaxref", "FinBIF"),
               pipeline_script = "pipelines/pipeline_plants.R",
               write_intermediate_steps = TRUE)
# results
searches <- load_intermediate_results(c("RTNRS", "rgbif", "rentrez", "rcol",
                                        "lcvplants", "algaeClassify",
                                        "rtaxref", "FinBIF"))
summary <- summarize_steps(searches)

summary %>%
  ggplot() +
  aes(step, cumulative) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = summary$step, labels = summary$package) +
  xlab("Package used at each sequential step") +
  ylab("Cumulative number of taxonomies found") +
  theme_classic() +
  theme(panel.grid.major.y = element_line(color = adjustcolor("grey20", alpha.f = 0.2)))


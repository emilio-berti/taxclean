library(tidyverse)
source("R/pipeline.R")

# automatic script generator ---------
# available package functions
available <- list.files("R")
available <- gsub("[.]R", "", available)
# package list to use
pkg_list <- c("rgnparser", "rgbif", "rcol", "rtaxref", "RTNRS")
# check all packages are available
pkg_list %in% available
# pipeline plants --------
write_pipeline(pkgs = pkg_list,
               pipeline_script = "pipelines/pipeline_plants.R",
               write_intermediate_steps = TRUE)
# check results
res <- list.files("results", pattern = "csv", full.names = TRUE)
pkg_used <- paste0("results/", pkg_list, ".csv") #this is previous results are stored already
res <- res[which(res %in% pkg_used)]
res <- res[which(!grepl("gnparser", res))]
# concatenate all results, adding package name and step
searches <- map(res, function(x) {
  pkg <- gsub("results/", "", x) %>%
    gsub(".csv", "", .)
  step <- which(pkg_list[!grepl("gnparser", pkg_list)] == pkg)
  read_csv(x, col_type = cols()) %>%
    mutate(package = pkg, step = step)
}) %>%
  bind_rows()
# how many species found at each step ?
step_summary <- searches %>%
  group_by(step, package) %>%
  filter(!is.na(scientific_name)) %>%
  tally(name = "frac") %>%
  mutate(frac = frac / length(d))
if (!all(searches$package %in% step_summary$package)) {
  missing <- setdiff(searches$package, step_summary$package)
  step_summary <- bind_rows(
    step_summary,
    searches %>%
      filter(package %in% missing) %>%
      transmute(step, package, frac = 0) %>%
      distinct_all() %>%
      arrange(desc(step))
  )
}
step_summary
# make wide table
# if some packages disappear from the table, it means they return all NAs
searches <- searches %>%
  arrange(step, search_name) %>% #final wide table will be already sorted by step
  select(search_name, scientific_name, package) %>%
  # filter(!is.na(scientific_name)) %>%
  pivot_wider(names_from = package, values_from = scientific_name) %>%
  unnest()

searches %>%
  filter(is.na(rgbif))

# or simply read final query
# usually this is not recommended, as NAs can be added at each step
read_csv("pipelines/pipeline_result.csv")

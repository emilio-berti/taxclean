library(tidyverse)

load_intermediate_results <- function(pkg_list) {
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
  return(searches)
}

summarize_steps <- function(searches) {
  # how many species found at each step ?
  step_summary <- searches %>%
    group_by(step, package) %>%
    filter(!is.na(scientific_name)) %>%
    tally(name = "frac") %>%
    mutate(frac = round(frac / length(d), 3))
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
  step_summary$cumulative <- cumsum(step_summary$frac)
  return(step_summary)
}

#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_algaeClassify <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d) | length(d) == 0) {
    stop("No input species")
  }
  # compare with algaebase online database
  # algae_search(d$Dataset1[4], long = TRUE) #preferred for one species
  ans <- lapply(d, function(x) {
    if (is.na(x)) {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      ans <- algaeClassify::algae_search(x, long = TRUE)
      ans$search_name <- ans$orig.name
      ans$scientific_name <- ans$match.name
      ans[, c("search_name", "scientific_name")]
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/algaeClassify.csv")
  }
  return(ans)
  # fuzzy ------
  # Fuzzy matching here requires possible name alternatives.
  # bestmatch(d$phyto_name, d$phyto_name)
}

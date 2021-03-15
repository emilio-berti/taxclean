#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_algaeClassify <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
  if (all(is.null(d), is.null(path))) {
    stop("At least one of 'd' or 'path' must be specified")
  }
  # compare with algaebase online database
  # algae_search(d$Dataset1[4], long = TRUE) #preferred for one species
  d$phyto_name <- d$Dataset1 #rename for database search
  ans <- algaeClassify::spp_list_algaebase(d, long = TRUE) #preferred for multiple species data.frame
  ans$search_name <- ans$orig.name
  ans$scientific_name <- ans$match.name
  ans <- ans[, c("search_name", "scientific_name")]
  if (write) {
    write.csv(ans, "results/algaeClassify.csv")
  }
  return(ans)
  # fuzzy ------
  # Fuzzy matching here requires possible name alternatives.
  # bestmatch(d$phyto_name, d$phyto_name)
}

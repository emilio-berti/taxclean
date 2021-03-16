#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_algaeClassify <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  # compare with algaebase online database
  # algae_search(d$Dataset1[4], long = TRUE) #preferred for one species
  d <- data.frame(phyto_name = d) #rename for database search
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

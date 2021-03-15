#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_rotl <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
  if (all(is.null(d), is.null(path))) {
    stop("At least one of 'd' or 'path' must be specified")
  }
  matched <- rotl::tnrs_match_names(d, do_approximate_matching = FALSE) #no fuzzy
  ans <- matched
  ans$search_name <-  ans$search_string
  ans$scientific_name <- ans$unique_name
  ans <- ans[, c("search_name", "scientific_name")]
  if (write) {
    write.csv(ans, "results/rotl.csv")
  }
  return(ans)
}

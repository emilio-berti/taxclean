#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rotl <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
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

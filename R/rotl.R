#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rotl <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  ans <- lapply(d, function(x) {
    if (is.na(x)) {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      ans <- rotl::tnrs_match_names(x, do_approximate_matching = FALSE) #no fuzzy
      data.frame(search_name = x, scientific_name = ans$unique_name)
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rotl.csv")
  }
  return(ans)
}

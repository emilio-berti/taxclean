#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rgnparser <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  ans <- rgnparser::gn_parse_tidy(d)
  ans <- ans[, c("canonicalfull", "authorship", "year")]
  if (write) {
    write.csv(ans, "results/rgnparser.csv")
  }
  return(ans)
}

#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_rgnparser <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
  if (all(is.null(d), is.null(path))) {
    stop("At least one of 'd' or 'path' must be specified")
  }
  ans <- rgnparser::gn_parse_tidy(d)
  ans <- ans[, c("canonicalfull", "authorship", "year")]
  if (write) {
    write.csv(ans, "results/rgnparser.csv")
  }
  return(ans)
}

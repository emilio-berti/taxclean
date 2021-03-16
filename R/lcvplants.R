#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_lcvplants <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  # the default parallel version works very slow
  ans <- suppressMessages(lapply(d, lcvplants::LCVP))
  ans <- do.call("rbind", ans)
  ans$search_name <- d
  ans$scientific_name <- paste(ans$Genus, ans$Species)
  ans <- ans[, c("search_name", "scientific_name")]
  if (write) {
    write.csv(ans, "results/lcvplants.csv")
  }
  return(ans)
}

#' @param x package name for the taxClean function (tc_...).
#' @param first if first package to be called.
#' @param after_gnr if called after rgnparser.
#' @param write if to write intermediate results to csv files.
pipe_function <- function(
  x,
  first = FALSE,
  after_gnr = FALSE,
  write
) {
  if (first) {
    if (write) {
      pipe <- paste0("tc_", x, "(d, write = TRUE)")
    } else {
      pipe <- paste0("tc_", x, "(d)")
    }
  } else if (after_gnr) {
    if (write) {
      pipe <- paste0("tc_", x, "(ans$canonicalfull, write = TRUE)")
    } else {
      pipe <- paste0("tc_", x, "(ans$canonicalfull)")
    }
  } else {
    if (write) {
      pipe <- paste0("tc_", x, "(ans$scientific_name, write = TRUE)")
    } else {
      pipe <- paste0("tc_", x, "(ans$scientific_name)")
    }
  }
  return(pipe)
}

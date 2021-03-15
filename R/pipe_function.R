#' @param x package name for the taxClean function (tc_...)
pipe_function <- function(
  x,
  first = FALSE,
  after_gnr = FALSE
) {
  if (first) {
    pipe <- paste0("tc_", x, "(d)")
  } else if (after_gnr) {
    pipe <- paste0("tc_", x, "(ans$canonicalfull)")
  } else {
    pipe <- paste0("tc_", x, "(ans$scientific_name)")
  }
  return(pipe)
}

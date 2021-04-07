#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rgbif <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  ans <- lapply(d, function(x){
    if (is.na(x)) {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      ans <- rgbif::name_backbone(x)
      if (ans$matchType == "NONE") {
        data.frame(search_name = x, scientific_name = NA)
      } else {
        data.frame(search_name = x, scientific_name = ans$canonicalName)
      }
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rgbif.csv")
  }
  return(ans)
}

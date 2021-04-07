#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_RTNRS <- function(
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
      ans <- TNRS::TNRS(x)
      if (is.na(ans$ID)) {
        data.frame(search_name = x, scientific_name = NA)
      } else if (ans$Name_matched == "") {
        data.frame(search_name = x, scientific_name = NA)
      } else {
        data.frame(search_name = x, scientific_name = ans$Name_matched)
      }
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/RTNRS.csv")
  }
  return(ans)
}

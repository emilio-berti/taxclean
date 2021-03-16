#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_FinBIF <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  #FinBIF need token
  token <- read.csv("~/Documents/finbif.txt", header = FALSE)
  Sys.setenv(FINBIF_ACCESS_TOKEN = token$V1)
  ans <- lapply(d, function(x) {
    ans <- finbif::finbif_taxa(x, type = "exact")
    if (length(ans$content) > 0) {
      data.frame(search_name = x,
                 scientific_name = ans$content[[1]]$scientificName)
    } else {
      data.frame(search_name = x,
                 scientific_name = NA)
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv("results/FinBIF.csv")
  }
  return(ans)
}

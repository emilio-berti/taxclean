#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rtaxref <- function(
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
      ans <- rtaxref::rt_taxa_search(x)
      if ("scientificName" %in% colnames(ans)) {
        data.frame(search_name = x, scientific_name = ans$scientificName)
      } else {
        ## you can also perform fuzzy matching:
        # fuzzy <- rtaxref::rt_taxa_fuzzymatch(x)
        # if ("scientificName" %in% colnames(fuzzy)) {
        #   data.frame(search_name = x, scientific_name = fuzzy$scientificName)
        # } else {
        #   data.frame(search_name = x, scientific_name = NA)
        # }
        ## but here we limit to strict searches:
        data.frame(search_name = x, scientific_name = NA)
      }
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rtaxref.csv")
  }
  return(ans)
}

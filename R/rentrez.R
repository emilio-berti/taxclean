#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rentrez <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  rentrez::entrez_db_searchable("taxonomy")
  ans <- lapply(d, function(x) {
    if (is.na(x)) {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      ans <- rentrez::entrez_search("taxonomy", paste0(x, "[SCIN] OR ", x, "[ALLN]"))
      if (length(ans$ids) == 0) {
        data.frame(search_name = x, scientific_name = NA)
      } else {
        ans <- rentrez::entrez_summary("taxonomy", id = ans$ids)
        data.frame(search_name = x, scientific_name = ans$scientificname)
      }
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rentrez.csv")
  }
  return(ans)
}

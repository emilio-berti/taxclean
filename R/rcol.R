#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rcol <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  # check available databases and keys
  # data.frame(
  # 	database = cp_datasets()$result$title,
  # 	key = cp_datasets()$result$key,
  # 	name = cp_datasets()$result$alias
  # )
  ans <- lapply(d, function(x) {
    res <- rcol::cp_nu_search(x, 3)$result[1, ] #Col working draft
    if (length(res) == 0) {
      data.frame(
        search_name = x,
        scientific_name = NA
      )
    } else {
      data.frame(
        search_name = x,
        scientific_name = res$usage$name$scientificName
      )
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rcol.csv")
  }
  return(ans)
}

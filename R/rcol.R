#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_rcol <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
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
  return(ans)
}

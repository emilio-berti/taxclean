#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rredlist <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d) | length(d) == 0) {
    stop("No input species")
  }
  if (!"IUCN_REDLIST_KEY" %in% names(Sys.getenv())) {
    stop("You need an API key to use rrdelist; see rredlist::rl_use_iucn() for more")
  }
  ans <- lapply(d, function(x){
    if (is.na(x)) {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      ans <- rredlist::rl_search(x)$result
      if (length(ans) == 0) {
        data.frame(search_name = x, scientific_name = NA)
      } else {
        data.frame(search_name = x, scientific_name = ans$scientific_name)
      }
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rredlist.csv")
  }
  return(ans)
}

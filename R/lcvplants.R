#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_lcvplants <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d) | length(d) == 0) {
    stop("No input species")
  }
  # the default parallel version works very slow
  ans <- lapply(d, function(x) {
    if (is.na(x)) {
      data.frame(Genus = "", Species = "")
    } else {
      ans <- suppressMessages(lcvplants::LCVP(x))
      ans[1, c("Genus", "Species")]
    }
  })
  ans <- do.call("rbind", ans)
  ans$search_name <- d
  ans$scientific_name <- paste(ans$Genus, ans$Species)
  ans$scientific_name[which(ans$Genus == "" & ans$Species == "")] <- NA
  ans <- ans[, c("search_name", "scientific_name")]
  if (write) {
    write.csv(ans, "results/lcvplants.csv")
  }
  return(ans)
}

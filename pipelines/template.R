##### Code generated automatically #####
#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rgnparser <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  ans <- rgnparser::gn_parse_tidy(d)
  ans <- ans[, c("canonicalfull", "authorship", "year")]
  if (write) {
    write.csv(ans, "results/rgnparser.csv")
  }
  return(ans)
}
#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_rotl <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  matched <- rotl::tnrs_match_names(d, do_approximate_matching = FALSE) #no fuzzy
  ans <- matched
  ans$search_name <-  ans$search_string
  ans$scientific_name <- ans$unique_name
  ans <- ans[, c("search_name", "scientific_name")]
  if (write) {
    write.csv(ans, "results/rotl.csv")
  }
  return(ans)
}
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
# load here you dataset
d <- read.csv("datasets.csv")[, 1] #rename this
message("RGNparser")
ans <- tc_rgnparser(d)
message("rotl")
ans <- tc_rotl(ans$canonicalfull)
message("FinBIF")
ans <- tc_FinBIF(ans$scientific_name)
write.csv(ans, "pipelines/pipeline_result.csv")

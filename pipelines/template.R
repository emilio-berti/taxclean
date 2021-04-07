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
tc_rgbif <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d)) {
    stop("No input species")
  }
  ans <- lapply(d, function(x){
    ans <- rgbif::name_backbone(x)
    if (ans$matchType == "NONE") {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      data.frame(search_name = x, scientific_name = ans$canonicalName)
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/rgbif.csv")
  }
  return(ans)
}
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
    ans <- TNRS::TNRS(x)
    if (ans$Name_matched == "") {
      data.frame(search_name = x, scientific_name = NA)
    } else {
      data.frame(search_name = x, scientific_name = ans$Name_matched)
    }
  })
  ans <- do.call("rbind", ans)
  if (write) {
    write.csv(ans, "results/RTNRS.csv")
  }
  return(ans)
}
# load your dataset
d <- read.csv("datasets.csv")[, 1] #d must be a vector of species names
# pipeline
message("RGNparser")
ans <- tc_rgnparser(d, write = FALSE)
message("rgbif")
ans <- tc_rgbif(ans$canonicalfull)
message("RTNRS")
ans <- tc_RTNRS(ans$scientific_name)
# write to csv
write.csv(ans, "pipelines/pipeline_result.csv") #you may want to change the output

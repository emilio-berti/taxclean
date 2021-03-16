##### Code generated automatically #####
#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_rgnparser <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
  if (all(is.null(d), is.null(path))) {
    stop("At least one of 'd' or 'path' must be specified")
  }
  ans <- rgnparser::gn_parse_tidy(d)
  ans <- ans[, c("canonicalfull", "authorship", "year")]
  if (write) {
    write.csv(ans, "results/rgnparser.csv")
  }
  return(ans)
}
#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_rotl <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
  if (all(is.null(d), is.null(path))) {
    stop("At least one of 'd' or 'path' must be specified")
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
#' @param d data.frame with species names
#' @param path location of the data.frame with species names
tc_algaeClassify <- function(
  d = NULL,
  path = NULL,
  write = FALSE
) {
  if (all(is.null(d), is.null(path))) {
    stop("At least one of 'd' or 'path' must be specified")
  }
  # compare with algaebase online database
  # algae_search(d$Dataset1[4], long = TRUE) #preferred for one species
  d <- data.frame(phyto_name = d) #rename for database search
  ans <- algaeClassify::spp_list_algaebase(d, long = TRUE) #preferred for multiple species data.frame
  ans$search_name <- ans$orig.name
  ans$scientific_name <- ans$match.name
  ans <- ans[, c("search_name", "scientific_name")]
  if (write) {
    write.csv(ans, "results/algaeClassify.csv")
  }
  return(ans)
  # fuzzy ------
  # Fuzzy matching here requires possible name alternatives.
  # bestmatch(d$phyto_name, d$phyto_name)
}
# load here you dataset
d <- read.csv("datasets.csv")[, 1] #rename this
message("RGNparser")
ans <- tc_rgnparser(d)
message("rotl")
ans <- tc_rotl(ans$canonicalfull)
message("algaeClassify")
ans <- tc_algaeClassify(ans$scientific_name)
write.csv(ans, "pipelines/pipeline_result.csv")

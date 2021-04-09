#' @param d string vector of species names
#' @param write TRUE/FALSE if to write the function output
tc_zbank <- function(
  d = NULL,
  write = FALSE
) {
  if (is.null(d) | length(d) == 0) {
    stop("No input species")
  }
  source("R/orthographic_distance.R")
  ans <- sapply(d, function(x){
    ans <- tryCatch(zbank::zb_name_usages(name = x),
                    error = function(e) {NULL})
    if (is.null(ans)) {
      return(NA)
    }
    mult <- sapply(ans$tnuuuid, function(y) {
      zbank::zb_matching(y)$fullnamestring
    })
    ans <- sapply(unlist(mult), function(x) {
      rgnparser::gn_parse(x)[[1]]$canonical$full
    })
    ans <- unique(as.vector(unlist(ans)))
    # retain only the name with smaller orthographic distance
    leven <- orthographic_dist(rep(x, length(ans)), ans)
    return(ans[which.min(leven$rel.distance)])
  })
  ans <- data.frame(search_name = d, scientific_name = ans)
  rownames(ans) <- NULL
  if (write) {
    write.csv(ans, "results/zbank.csv")
  }
  return(ans)
}

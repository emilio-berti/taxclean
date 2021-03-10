#'   itle Compute Absolute and Relative Orthographic Distance
#'
#'   This function computes the absolute and relative orthographic distance as
#'   discussed in Meyer et al. (2016). Absolute orthographic distance is also
#'   known as Levenshtein distance, informally defined as the number of
#'   corrections necessary to reach a string from another. Relative orthographic
#'   distance is the absolute distance divided by the length of the string.
#'   Here, the relative distance is obtained as the Levenshtein distance divided
#'   by the average length of the strings.

orthographic_dist <- function(x, y, parallel = FALSE, n_cores = 4) {
  if (length(x) != length(y)) {
    stop("Different number of strings in x and y")
  }
  if (length(x) > 1) {
    if (parallel) {
      ans <- parallel::mcmapply(orthographic_dist, x, y, mc.cores = n_cores)
      ans <- t(ans)
      ans <- as.data.frame(ans)
      rownames(ans) <- NULL
      ans[, 1] <- unlist(ans[, 1])
      ans[, 2] <- unlist(ans[, 2])
      return(ans)
    } else {
      ans <- c()
      for (i in seq_len(length(x))) {
        ans <- rbind(ans, orthographic_dist(x[i], y[i]))
      }
      return(ans)
    }
  } else {
    avg_length <- mean(stringr::str_count(x), stringr::str_count(y))
    levenshtein <- RecordLinkage::levenshteinDist(x, y)
    ans <- data.frame(abs.distance = levenshtein,
                      rel.distance = levenshtein / avg_length)
    return(ans)
  }
}

#' @title Compute Absolute and Relative Orthographic Distance
#' @description This function computes the absolute and relative orthographic
#' distance as discussed in Meyer et al. (2016). Absolute orthographic distance
#' is also known as Levenshtein distance, informally defined as the number of
#' corrections necessary to reach a string from another. Relative orthographic
#' distance is the absolute distance divided by the length of the string. Here,
#' the relative distance is obtained as the Levenshtein distance divided by the
#' average length of the strings.
#'
#' @param x first string or vector of strings.
#' @param y second string or vector of strings.
#' @param parallel TRUE/FALSE if to run in parallel.
#' @param n_cores number of cores for parallel computation.
#' @return a data.frame with absolute and relative orthographic distances.
orthographic_dist <- function(
  x,
  y,
  parallel = FALSE,
  n_cores = 4
) {
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
#' @title Check if Epithets match.
#' @description Check if the epithets can considered to be matching each others
#' according to Meyers et al. (2016). See also Jin & Yang (2020).
#' @param dist data.frame with orthographic distances as returned from
#' @param epithets (optional) data.frame with epithets. Is NULL, row numbers of
#'   matching epithets are returned. \code{orthographic_distance()}.
#' @return a data.frame with epithets, distance, and if can be considered
#'   matching. If epithets = NULL, this returns only a vector with the row
#'   numbers of matchin epithets.
#' @examples
#' x <- sapply(1:5000, function(x) paste(sample(letters[1:10], 5), collapse = ""))
#' y <- sapply(1:5000, function(x) paste(sample(letters[1:10], 5), collapse = ""))
#' dist <- orthographic_dist(x, y, parallel = TRUE)
#' matches <- check_epithets_match(dist, data.frame(x, y))
#' matches[matches$matching, ]
check_epithets_match <- function(
  dist,
  epithets = NULL
) {
  ids <- which(dist$abs.distance < 4 & dist$rel.distance < 0.3)
  if (is.null(epithets)) {
    return(ids)
  } else {
    ans <- cbind(epithets, dist)
    ans$matching <- sapply(seq_len(nrow(ans)), function(i) {
      ifelse(i %in% ids, TRUE, FALSE)
    })
    return(ans)
  }
}

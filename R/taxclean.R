#' @title Remove whitespaces
#' Remove unnecessary whitespaces (e.g. two subsequent whitespaces)
#' from the species name.
#' @param sp species name.
#' @return a string with the species name without unnecessary whitespaces.
rm_whitespace <- function(sp) {
  ans <- gsub("( +)", " ", sp)
  ans <- gsub("( $)", "", ans)
  return(ans)
}
#' @title Remove punctuation
#' Remove punctuation from the species name.
#' @param sp species name.
#' @return a string with the species name without punctuation.
# remove punctuation
rm_punct <- function(sp) {
  ans <- gsub("[[:punct:]]", "", sp)
  return(ans)
}
#' @title Remove abbreviations
#' Remove abbreviation 'sp' from the species name.
#' @param sp species name.
#' @return a string with the species name without 'sp'.
rm_abbr <- function(sp) {
  ans <- gsub(" sp ", " ", sp)
  ans <- gsub(" sp. ", " ", ans)
  ans <- gsub(" sp$", " ", ans)
  ans <- gsub(" sp.$", " ", ans)
  return(ans)
}
#' @title Remove additional information
#' Remove extra information not needed for taxonomic purposes (e.g. sex).
#' @param sp species name.
#' @return a string with the species name without extra information.
rm_extra <- function(sp) {
  ans <- gsub("\\([A-Z]+\\)", "", sp)
  ans <- gsub("\\([a-z]+\\)", "", ans)
  ans <- gsub("\\{[A-Z]+\\}", "", ans)
  ans <- gsub("\\{[a-z]+\\}", "", ans)
  return(ans)
}
#' @title Remove 'cf'
#' Remove 'cf' from the species name.
#' @param sp species name.
#' @return a string with the species name without 'cf'.
rm_cf <- function(sp) {
  ans <- gsub(" cf [A-Z][a-z]*( *)", "", sp)
  return(ans)
}
#' @title remove subspecies
#' Remove subspecies and varieties
#' @param sp species name.
#' @return a string with the species name without subspecies and varieties
rm_var <- function(sp) {
  ans <- paste(strsplit(sp, " ")[[1]][1:2], collapse = " ")
  return(ans)
}
#' @title Remove typos
#' Remove all unnecessary characters and punctuation from the species name.
#' @details Calls sequentially \code{rm_whitespace()}, \code{rm_extra()},
#' \code{rm_abbr()}, \code{rm_punct()}, \code{rm_whitespace()},
#' \code{rm_cf()}, and \code{rm_var()}.
#' @param sp species name.
#' @param parallel logical, weather to parallelize or not.
#' @param n_cores number of cores to use in parallilization.
#' @return a string with the species name without typos.
rm_typos <- function(sp, parallel = FALSE, n_cores = 6) {
  if (length(sp) > 1) {
    if (parallel) {
      ans <- parallel::mclapply(sp, rm_typos, mc.cores = n_cores)
      return(unlist(ans))
    } else {
      ans <- c()
      for (i in seq_len(length(sp))) {
        ans <- append(ans, rm_typos(sp[i]))
      }
      return(ans)
    }
  } else {
    ans <- rm_whitespace(sp)
    ans <- rm_extra(ans)
    ans <- rm_abbr(ans)
    ans <- rm_punct(ans)
    ans <- rm_whitespace(ans)
    ans <- rm_cf(ans)
    ans <- rm_var(ans)
    return(ans)
  }
}
#' @title Fix typos
#' programmatically fix typos using \code{taxize} R package. First, remove typos
#' using \code{rm_typos()}, then check the Catalogue Of Life (COL) using taxize
#' to find possible matches of erroneous species names.
#' @inherit rm_typos
#' @details Species not matched are returned as 'NA'; species without
#' species-level taxonomy are returned as 'Species NA'
#' @return a string with the species name taxonomy suggested by COL.
fix_typos <- function(sp, parallel = FALSE, n_cores = 6) {
  sp <- rm_typos(sp)
  if (length(sp) > 1) {
    if (parallel) {
      ans <- parallel::mclapply(sp, fix_typos, mc.cores = n_cores)
      return(unlist(ans))
    } else {
      ans <- c()
      for (i in seq_len(length(sp))) {
        ans <- append(ans, fix_typos(sp[i]))
      }
      return(ans)
    }
  } else {
    matched <- taxize::gnr_resolve(sp, data_source_ids = 1)
    if (nrow(matched) == 0) {
      message(sp, " not found in COL")
      ans <- NA
      return(ans)
    } else if (nrow(matched > 1)) {
      matched <- matched[1, ]
    }
    ans <- paste(strsplit(matched$matched_name, " ")[[1]][1:2], collapse = " ")
    return(ans)
  }
}
#' @title make table from GBIF data
#' @param df GBIF data.frame
#' @return a data.frame table with taxonomic information
gbif_table <- function(df) {
  ans <- data.frame(
    key = ifelse("usageKey" %in% names(df), df$usageKey, NA),
    name = ifelse("canonicalName" %in% names(df), df$canonicalName, NA),
    rank = ifelse("rank" %in% names(df), tolower(df$rank), NA),
    status = ifelse("status" %in% names(df), tolower(df$status), NA),
    kingdom = ifelse("kingdom" %in% names(df), df$kingdom, NA),
    phylum = ifelse("phylum" %in% names(df), df$phylum, NA),
    order = ifelse("order" %in% names(df), df$order, NA),
    family = ifelse("family" %in% names(df), df$family, NA),
    genus = ifelse("genus" %in% names(df), df$genus, NA),
    species = ifelse("species" %in% names(df), df$species, NA)
  )
  return(ans)
}
#' @title Get GBIF taxonomy
#' Retrieve GBIF taxonomy using the rgbif package.
#' @inherit rm_typos
#' @param alternative logical; TRUE return alternative instead of main result.
#' @return a string with the species name taxonomy suggested by GBIF.
find_gbif <- function(sp, parallel = FALSE, n_cores = 6, alternative = FALSE) {
  if (length(sp) > 1) {
    if (parallel) {
      ans <- parallel::mclapply(sp, find_gbif, mc.cores = n_cores)
      ans <- do.call("rbind", ans)
      return(ans)
    } else {
      ans <- c()
      for (i in seq_len(length(sp))) {
        ans <- rbind(ans, find_gbif(sp[i]))
      }
      return(ans)
    }
  } else {
    ans <- rgbif::name_backbone_verbose(sp)
    if (ans$data$matchType == "NONE") {
      if (nrow(ans$alternatives) == 0) {
        warning("No alternative found in GBIF")
        return(NA)
      } else {
        return(gbif_table(ans$data[1, ]))
      }
    }
    if (ans$data$matchType != "NONE") {
      if (nrow(ans$alternatives) == 0 | !alternative) {
        return(gbif_table(ans$data[1, ]))
      } else {
        return(gbif_table(ans$alternatives[1, ]))
      }
    }
  }
}
#' @title Get GBIF taxonomy resolution
#' Retrieve the taxonomy resolution according to GBIF.
#' @inherit rm_typos
#' @return a string with the taxonomic level of the organism.
gbif_tax_res <- function(sp, parallel = FALSE, n_cores = 6) {
  if (length(sp) > 1) {
    if (parallel) {
      ans <- parallel::mclapply(sp, gbif_tax_res, mc.cores = n_cores)
      return(unlist(ans))
    } else {
      ans <- c()
      for (i in seq_len(length(sp))) {
        ans <- append(ans, gbif_tax_res(sp[i]))
      }
      return(ans)
    }
  } else {
    ans <- rgbif::name_backbone(sp)
    if (ans$matchType == "NONE") {
      return(NA)
    } else {
      return(ans$rank)
    }
  }
}

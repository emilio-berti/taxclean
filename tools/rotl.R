library(rotl)

# species to search
sp <- c("Alyssum bertolonii",
        "Caracal carcal",
        "Panthera leo",
        "Carcharodon carcharias")
# parse Taxonomic Name Resolution Service
d <- tnrs_match_names(sp, do_approximate_matching = FALSE) #no fuzzy
fuzzy <- tnrs_match_names(setdiff(tolower(sp), d$search_string[!is.na(d$ott_id)]))
d <- d[!is.na(d$ott_id), ]
# get synonyms
synonyms <- c(synonyms(d), synonyms(fuzzy))
# combine everything together
d <- rbind(
  cbind(d, rank = unlist(tax_rank(d)), fuzzy = FALSE),
  cbind(fuzzy, rank = unlist(tax_rank(fuzzy)), fuzzy = TRUE)
)
d$syns <- synonyms
rownames(d) <- NULL
# results
d[, -which(colnames(d) == "syns")]


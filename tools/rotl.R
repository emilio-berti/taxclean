library(rotl)

sp <- c("Alyssum bertolonii",
        "Caracal carcal",
        "Panthera leo",
        "Carcharodon carcharias")
d <- tnrs_match_names(sp, do_approximate_matching = FALSE) #no fuzzy
fuzzy <- tnrs_match_names(setdiff(tolower(sp), d$search_string[!is.na(d$ott_id)]))
d <- d[!is.na(d$ott_id), ]

synonyms <- c(synonyms(d), synonyms(fuzzy))

d <- rbind(
  cbind(d, rank = unlist(tax_rank(d)), fuzzy = FALSE),
  cbind(fuzzy, rank = unlist(tax_rank(fuzzy)), fuzzy = TRUE)
)
d$syns <- synonyms
rownames(d) <- NULL
d[, -which(colnames(d) == "syns")]

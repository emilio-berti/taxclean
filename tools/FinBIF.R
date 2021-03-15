library(finbif)

#finbif_request_token("my-email@here.com")
token <- read.csv("~/Documents/finbif.txt", header = FALSE) #don't store token in git repos
Sys.setenv(FINBIF_ACCESS_TOKEN = token$V1)

d <- read.csv("datasets.csv")[, 1]

# check taxonomy
# finbif_check_taxa(d)
FinBIF <- lapply(d, function(x) {
  ans <- finbif_taxa(x, type = "exact")
  if (length(ans$content) > 0) {
  data.frame(search.name = x,
             scientific.name = ans$content[[1]]$scientificName,
             authority = ans$content[[1]]$scientificNameAuthorship,
             rank = ans$content[[1]]$taxonRank,
             matched.name = ans$content[[1]]$matchingName)
  } else {
    data.frame(search.name = x,
               scientific.name = NA,
               authority = NA,
               rank = NA,
               matched.name = NA)

  }
})
FinBIF <- do.call("rbind", FinBIF)

write.csv("results/FinBIF.csv")

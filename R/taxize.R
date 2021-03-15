library(taxize)

sp <- read.csv("datasets.csv")[2, 1]
databases <- c("ncbi", "itis", "eol", "gbif", "nbn",
               "worms", "natserv", "bold", "wiki", "pow")
res <- list()
for (db in databases) { #particularly hard to loop it without exception handling
  NEXT <<- FALSE
  d <- tryCatch(classification(sp, db = db, rows = 1),
           error = function(e) {
             NEXT <<- TRUE
           })
  if (NEXT) {
    next
  }
  if (is.na(d[1])) {
    message("Not found in ", db)
  } else {
    d <- do.call("rbind", lapply(names(d), function(x) d[[x]][nrow(d[[x]]), ]))
    d <- cbind(d, db)
    d <- d[, c("name", "rank", "db")]
    res[[db]] <- d
  }
}

ans <- do.call("rbind", res)
ans$scientific_name = ans$name
ans$search_name = sp
ans$status = NA
ans <- ans[, c("search_name", "scientific_name", "rank", "status", "db")]
write.csv(ans, "searches/taxize.csv")

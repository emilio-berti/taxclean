files <- list.files("searches", full.names = TRUE)

res <- list()
for (f in files) {
  d <- read.csv(f)
  d <- d[, c("search_name", "scientific_name", "rank", "status")]
  tool <- gsub("[.]csv", "", strsplit(f, "/")[[1]][2])
  d$tool <- tool
  res[[tool]] <- d
}
res <- do.call("rbind", res)
rownames(res) <- NULL
res

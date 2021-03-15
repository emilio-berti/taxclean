pkgs <- c("rgnparser", "rotl", "algaeClassify")

file <- "pipelines/template.R"

writeLines(
  text = c(
    paste0('source("R/', pkgs, '.R")'),
    '# load here you dataset',
    'd <- read.csv("datasets.csv")[, 1] #rename this',
    'ans <- tc_rgnparser(d)',
    'ans <- tc_rotl(ans$canonicalfull)',
    'ans <- tc_algaeClassify(ans$scientific_name)',
    'write.csv(ans, "pipelines/pipeline_result.csv")'
  ),
  con = file
)

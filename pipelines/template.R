source("R/rgnparser.R")
source("R/rotl.R")
source("R/algaeClassify.R")
# load here you dataset
d <- read.csv("datasets.csv")[, 1] #rename this
ans <- tc_rgnparser(d)
ans <- tc_rotl(ans$canonicalfull)
ans <- tc_algaeClassify(ans$scientific_name)
write.csv(ans, "pipeline_result.csv")

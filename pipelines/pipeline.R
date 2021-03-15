source("tools/rgnparser.R")
source("tools/rotl.R")
source("tools/algaeClassifiy.R")
# load here you dataset
d <- read.csv("datasets.csv") #rename this
ans <- tc_rgnparser(d)
ans <- tc_rotl(ans$canonicalfull)
ans <- tc_algaeClassify(ans$scientific_name)
write.csv(ans, "pipeline_result.csv")

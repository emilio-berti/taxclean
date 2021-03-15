source("R/rgnparser.R")
source("R/rotl.R")
source("R/algaeClassify.R")
# load here you dataset
d <- read.csv("datasets.csv")[, 1] #rename this
message("RGNparser")
ans <- tc_rgnparser(d)
message("rotl")
ans <- tc_rotl(ans$canonicalfull)
message("algaeClassify")
ans <- tc_algaeClassify(ans$scientific_name)
write.csv(ans, "pipelines/pipeline_result.csv")

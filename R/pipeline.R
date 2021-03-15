# function to append the correct function to the R script
source("R/pipe_function.R")
# packages chosen
pkgs <- c("rotl", "rgnparser", "algaeClassify") #this would be the output of the choice made using the GUI.
# rgnparser always first
if ("rgnparser" %in% pkgs) {
  pkgs <- append("rgnparser", pkgs)
  pkgs <- pkgs[-which(pkgs == "rgnparser")[2]]
}
# file to write the R script
file <- "pipelines/template.R"
# writing the script -----------
write(paste0('source("R/', pkgs, '.R")'), file, append = FALSE)
write('# load here you dataset', file, append = TRUE)
write('d <- read.csv("datasets.csv")[, 1] #rename this', file, append = TRUE)
# output from rgnparser is not standard with other functions.
# this also writes the call of the first tc_function, which takes the dataset as input.
if (pkgs[1] == "rgnparser") {
  write('message("RGNparser")', file, append = TRUE)
  write('ans <- tc_rgnparser(d)', file, append = TRUE)
  write(paste0('message("', pkgs[2], '")'), file, append = TRUE)
  write(paste0('ans <- ', pipe_function(pkgs[2], after_gnr = TRUE)), file, append = TRUE)
  pkgs <- setdiff(pkgs, pkgs[1])
} else {
  write(paste0('message("', pkgs[1], '")'), file, append = TRUE)
  write(paste0('ans <- ', pipe_function(pkgs[1], first = TRUE)), file, append = TRUE)
}
# iterate over all pacakges, except first one (rgnparser is already removed, if
# present originally).
for (x in setdiff(pkgs, pkgs[1])) {
  write(paste0('message("', x, '")'), file, append = TRUE)
  write(paste0('ans <- ', pipe_function(x)), file, append = TRUE)
}
write('write.csv(ans, "pipelines/pipeline_result.csv")', file, append = TRUE)

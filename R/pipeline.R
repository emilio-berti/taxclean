#' @title Write R script Pipeline
#' @description Writes to a file the R code to reproduce a pipeline..
#' @param pkgs packages to call sequentially.
#' @param pipeline_script file where to write the R code.
write_pipeline <- function(
  pkgs = c("rotl", "rgnparser", "algaeClassify"), #NULL,
  pipeline_script = "pipelines/template.R" #NULL
) {
  if (is.null(pkgs)) {
    stop("Nothing to write")
  }
  if (is.null(pipeline_script)) {
    stop("No file specified where to write the pipeline")
  }
  # function to append the correct function to the R script
  source("R/pipe_function.R")
  # packages chosen
  # rgnparser always first
  if ("rgnparser" %in% pkgs) {
    pkgs <- append("rgnparser", pkgs)
    pkgs <- pkgs[-which(pkgs == "rgnparser")[2]]
  }
  # writing the script -----------
  write("##### Code generated automatically #####", pipeline_script, append = FALSE)
  # instead of writing 'source(...)' I changed to append all function code
  # in one script.
  #write(paste0('source("R/', pkgs, '.R")'), pipeline_script, append = FALSE)
  con <- file(pipeline_script, open = "a")
  for (x in pkgs) {
    txt <- readLines(paste0("R/", x, ".R"))
    writeLines(txt, con)
  }
  close(con)
  write('# load here you dataset', pipeline_script, append = TRUE)
  write('d <- read.csv("datasets.csv")[, 1] #rename this', pipeline_script, append = TRUE)
  # output from rgnparser is not standard with other functions.
  # this also writes the call of the first tc_function, which takes the dataset as input.
  if (pkgs[1] == "rgnparser") {
    write('message("RGNparser")', pipeline_script, append = TRUE)
    write('ans <- tc_rgnparser(d)', pipeline_script, append = TRUE)
    write(paste0('message("', pkgs[2], '")'), pipeline_script, append = TRUE)
    write(paste0('ans <- ', pipe_function(pkgs[2], after_gnr = TRUE)), pipeline_script, append = TRUE)
    pkgs <- setdiff(pkgs, pkgs[1])
  } else {
    write(paste0('message("', pkgs[1], '")'), pipeline_script, append = TRUE)
    write(paste0('ans <- ', pipe_function(pkgs[1], first = TRUE)), pipeline_script, append = TRUE)
  }
  # iterate over all pacakges, except first one (rgnparser is already removed, if
  # present originally).
  for (x in setdiff(pkgs, pkgs[1])) {
    write(paste0('message("', x, '")'), pipeline_script, append = TRUE)
    write(paste0('ans <- ', pipe_function(x)), pipeline_script, append = TRUE)
  }
  write('write.csv(ans, "pipelines/pipeline_result.csv")', pipeline_script, append = TRUE)
}

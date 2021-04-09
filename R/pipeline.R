#' @title Write R script Pipeline
#' @description Writes to a file the R code to reproduce a pipeline..
#' @param pkgs packages to call sequentially.
#' @param pipeline_script file where to write the R code.
#' @param write_intermediate_steps TRUE/FALSE, if to write intermediate queries.
write_pipeline <- function(
  pkgs = c("rgbif", "rgnparser", "RTNRS"), #NULL,
  pipeline_script = "pipelines/template.R", #NULL
  write_intermediate_steps = FALSE,
  data = NULL
) {
  if (is.null(pkgs)) {
    stop("No package specified: nothing to write")
  }
  if (is.null(pipeline_script)) {
    stop("File where to write the pipeline not specified")
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
  write('# load your dataset', pipeline_script, append = TRUE)
  write('d <- readRDS("data/biotime.rds") #d must be a vector of species names',
        pipeline_script,
        append = TRUE)
  write('# pipeline', pipeline_script, append = TRUE)
  # output from rgnparser is not standard with other functions.
  # this also writes the call of the first tc_function, which takes the dataset as input.
  if (pkgs[1] == "rgnparser") {
    write('message("RGNparser")', pipeline_script, append = TRUE)
    write(paste0(
      'd <- tc_rgnparser(d, write = ',
      ifelse(write_intermediate_steps, 'TRUE', 'FALSE'),
      ')$canonicalfull'
    ),
    pipeline_script,
    append = TRUE)
    write(paste0('message("', pkgs[2], '")'), pipeline_script, append = TRUE)
    write(paste0(
      'ans <- ',
      pipe_function(pkgs[2], after_gnr = TRUE, write = write_intermediate_steps)
    ),
    pipeline_script,
    append = TRUE)
    pkgs <- setdiff(pkgs, pkgs[1])
  } else {
    write(paste0('message("', pkgs[1], '")'), pipeline_script, append = TRUE)
    write(paste0(
      'ans <- ',
      pipe_function(pkgs[1], first = TRUE, write = write_intermediate_steps)
    ),
    pipeline_script,
    append = TRUE)
  }
  # iterate over all pacakges, except first one (rgnparser is already removed, if
  # present originally).
  for (x in setdiff(pkgs, pkgs[1])) {
    write(paste0('message("', x, '")'), pipeline_script, append = TRUE)
    write(paste0(
      'ans <- ', pipe_function(x, write = write_intermediate_steps)
    ),
    pipeline_script,
    append = TRUE)
  }
  write('# write to csv', pipeline_script, append = TRUE)
  write('write.csv(ans, "pipelines/pipeline_result.csv") #you may want to change the output', pipeline_script, append = TRUE)
}

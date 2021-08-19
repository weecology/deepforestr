#' Get example data
#'
#' @param path path to the example data file
#'
#' @examples
#' deepforest::get_data("OSBS_029.png")
#'
#' @importFrom reticulate import r_to_py
#' @export
get_data <- function(path) {
  deepforest$get_data(path)
}

#' Deepforest Model object
#' 
#' @examples
#' deepforest::df_model()
#'
#' @importFrom reticulate import r_to_py
#' @export
df_model <- function() {
  deepforest$main$deepforest()
}

# global reference to python modules (will be initialized in .onLoad)
deepforest <- NULL

.onLoad <- function(libname, pkgname) {
  ## assignment in parent environment!
  try({
    deepforest <<- reticulate::import("deepforest", delay_load = TRUE)
    # Disable due to failure to test on win cran dev platform
    # check_deepforest_availability()
  }, silent = TRUE)
}

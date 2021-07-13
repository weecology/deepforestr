#' Check for updates
#'
#' @param repo path to the repository
#'
#' @examples
#' \donttest{
#' deepforest::get_data()
#' }
#' @importFrom reticulate import r_to_py
#' @export
get_data <- function(repo = "") {
  writeLines(strwrap("Please wait while the retriever updates its scripts, ..."))
  deepforest$get_data(repo)
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

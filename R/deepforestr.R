
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

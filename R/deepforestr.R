#' Install the DeepForest Python package
#'
#' The package will be installed into it's own conda environment 'r-deepforest'
#' by default. If conda is already installed on the system the existing version
#' will be used. If it is not installed then it will be automatically installed.
#'
#' @param envname Name of conda environment for installing deepforest
#'
#' @param restart_session Restart R session after installing (note this will
#'   only occur within RStudio).
#'
#' @param new_env If `TRUE`, any existing conda environment specified by
#'   `envname` is deleted first.
#'
#' @param ... other arguments passed to [`reticulate::conda_install()`]
#'
#' @examples
#' \dontrun{
#' deepforestr::install_deepforest()}
#'
#'
#' @importFrom reticulate install_miniconda py_install conda_remove conda_binary
#' @export
install_deepforest <- function(envname = "r-deepforest",
                               restart_session = TRUE,
                               new_env = identical(envname, "r-deepforest"),
                               ...) {
  if (is.null(tryCatch(conda_binary(), error = function(e) NULL))) {
    install_miniconda()
  } else {
    print(sprintf("Using existing miniconda install at %s", conda_binary()))
  }
  deps <- c("gdal", "rasterio", "fiona")
  py_install(deps, envname = envname, method = "conda", ...)
  #if (py_module_available("mkl")) {
    # Remove package that has caused conflicts on Windows due to double install
    # The correct version of mkl will be installed with deepforest (below)
    # on systems where it is needed
  #  reticulate::conda_remove(envname, packages = c("mkl"))
  #}
  py_install("DeepForest", envname = envname, method = "conda", pip = TRUE)

  if (restart_session && rstudioapi::hasFun("restartSession")){
    rstudioapi::restartSession()
  }

  invisible(NULL)
}

#' Get example data
#'
#' @param path path to the example data file
#'
#' @examples
#' \dontrun{
#' deepforestr::get_data("OSBS_029.png")
#' }
#'
#' @importFrom reticulate import r_to_py
#' @export
get_data <- function(path) {
  deepforest$get_data(path)
}

#' Deepforest Model object
#'
#' @examples
#' \dontrun{
#' model = deepforestr::df_model()
#' }
#' @importFrom reticulate import r_to_py
#' @export
df_model <- function() {
  deepforest$main$deepforest()
}

# global reference to python modules (will be initialized in .onLoad)
deepforest <- NULL

.onLoad <- function(libname, pkgname) {
  reticulate::use_condaenv("r-deepforest", required = FALSE)
  deepforest <<- reticulate::import("deepforest", delay_load = TRUE)
}

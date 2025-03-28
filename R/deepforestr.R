#' Install the DeepForest Python package
#'
#' @examples
#' \dontrun{
#' deepforestr::install_deepforest()
#' }
#'
#' @importFrom reticulate install_miniconda py_install conda_remove
#' @export
install_deepforest <- function() {
  miniconda_path <- reticulate::miniconda_path()
  if (!dir.exists(miniconda_path)) {
    reticulate::install_miniconda()
  } else {
    print(sprintf("Using existing miniconda install at %s", miniconda_path))
  }
  reticulate::py_install(
    c("gdal", "rasterio", "fiona", "numpy==1.*"),
    envname = "deepforest-env",
    method = "conda",
    python_version = "3.12",
  )
  # if (reticulate::py_module_available("mkl")) {
  # Remove package that has caused conflicts on Windows due to double install
  # The correct version of mkl will be installed with deepforest (below)
  # on systems where it is needed
  #  reticulate::conda_remove("r-reticulate", packages = c("mkl"))
  # }
  reticulate::py_install(
    "DeepForest",
    envname = "deepforest-env",
    method = "conda",
    pip = TRUE
  )
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
#' model <- deepforestr::df_model()
#' }
#' @importFrom reticulate import r_to_py
#' @export
df_model <- function() {
  reticulate::py_require("deepforest")
  print(deepforest)
  print(reticulate::py_config())
  deepforest$main$deepforest()
}

# global reference to python modules (will be initialized in .onLoad)
deepforest <- NULL

.onLoad <- function(libname, pkgname) {
  # unset reticulate python environment see:
  # https://github.com/greta-dev/greta/issues/444
  ## assignment in parent environment!
  try(
    {
      Sys.unsetenv("RETICULATE_PYTHON")
      reticulate::use_condaenv("deepforest-env", required = TRUE)
      deepforest <<- reticulate::import("deepforest", delay_load = TRUE)
      # Disable due to failure to test on win cran dev platform
      # check_deepforest_availability()
    },
    silent = TRUE
  )
}

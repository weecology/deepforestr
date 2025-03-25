library(testthat)

context("integration tests for DeepForest in R")

skip_if_no_deepforest <- function() {
  deepforest_avail <- reticulate::py_module_available("deepforest")
  if (!deepforest_avail && Sys.getenv("GITHUB_ACTIONS") == "false") {
    skip("deepforest not available for testing")
  }
}

test_that("deepforest model is installed", {
  skip_if_no_deepforest()
  deepforest_available <- reticulate::py_module_available("deepforest")
  expect_identical(deepforest_available, TRUE)
})

test_that("deepforest model exists when loaded", {
  skip_if_no_deepforest()
  model <- df_model()
  expect_type(model, "closure")
})

test_that("use_release model exists when loaded", {
  skip_if_no_deepforest()
  model <- df_model()
  model$use_release()
  expect_type(model, "closure")
})

test_that("image prediction works", {
  skip_if_no_deepforest()
  model <- df_model()
  model$use_release()
  image_path <- get_data("OSBS_029.png")
  bounding_boxes <- model$predict_image(path = image_path, return_plot = FALSE)
  expect_equal(nrow(bounding_boxes), 56)
})

test_that("training works", {
  skip_if_no_deepforest()
  model <- df_model()
  model$use_release()
  annotations_file <- get_data("testfile_deepforest.csv")
  model$config$epochs <- 1
  model$config["save-snapshot"] <- FALSE
  model$config$train$csv_file <- annotations_file
  model$config$train$root_dir <- get_data(".")
  model$config$train$fast_dev_run <- TRUE
  model$create_trainer()
  model$trainer$fit(model)
  expect_type(model, "closure")
})

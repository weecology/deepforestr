library(testthat)

context("integration tests for DeepForest in R")

test_that("deepforest model is installed", {
    
    # Python package not installed on CRAN

    skip_on_cran() 

  deepforest_available = reticulate::py_module_available("deepforest")
  expect_identical(deepforest_available, TRUE)
})

test_that("deepforest model exists when loaded", {

  # Python package not installed on CRAN

    skip_on_cran() 
  
  model = df_model()
  expect_type(model, "closure")

})

test_that("use_release model exists when loaded", {

  # Python package not installed on CRAN

    skip_on_cran() 
  
  model = df_model()
  model$use_release()
  expect_type(model, "closure")

})

test_that("image prediction works", {

  # Python package not installed on CRAN

    skip_on_cran() 
  
  expect

  model = df_model()
  model$use_release()
  image_path = get_data("OSBS_029.png")
  bounding_boxes = model$predict_image(path=image_path, return_plot=FALSE)
  expect_identical(nrow(bounding_boxes), 56)
})

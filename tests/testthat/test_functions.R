test_that("Stats generating properties", {
  data <- chipPCR::C60.amp
  text_of_stats <- calculateDataStatistics(data)
  
  expect_match(text_of_stats,
               paste0(dim(data)[1], " x ", dim(data)[2]) # "45 x 33"
  )
  
  expect_match(text_of_stats,
               paste0("\nNumber of curves: ", dim(data)[2] - 1) # "\nNumber of curves: 32", becouse the first column in data should be index
  )
  
  
  expect_equal(stringr::str_count(text_of_stats, "\n"), 4) # This file generates 3 lines of stats and ends with "\n"; If data has curves with different lengths, there would be more lines
})

test_that("hash generating properly", {
  data <- chipPCR::C60.amp[,1:4]
  
  expect_true(dataset_hash_maker(data) != dataset_hash_maker(data[-1]))       # it is different dataset now
  expect_true(dataset_hash_maker(data) == dataset_hash_maker(data[,4:1]))     # it is still tha same dataset
  expect_true(dataset_hash_maker(data) == dataset_hash_maker(unname(data)))   # it is still tha same dataset
  expect_true(dataset_hash_maker(data) == dataset_hash_maker(round(data, 2))) # it is close enought to tha same dataset
})

test_that("can extract extention", {
  expect_equal(extract_extension("testfile.csv"), ".csv")
  expect_equal(extract_extension("testdir/testfile.txt"), ".txt")
  expect_equal(extract_extension("~/tests/textfile.csv.gz"), ".gz")
})

# test_that("Proper columns are selected", {
#   expect_equal(ncol_to_selectedColumns(4), 1:4)
#   expect_equal(ncol_to_selectedColumns(10), 1:10)
#   expect_equal(ncol_to_selectedColumns(11), c(1:5, 7:11))
#   expect_equal(ncol_to_selectedColumns(10), c(1:5, 96:100))
# })

test_that("plotly graph", {
  data <- chipPCR::C60.amp[,1:4]
  
  expect_equal(class(plotCurve(data, colnames(data)[1])),
               c("plotly", "htmlwidget"))
})


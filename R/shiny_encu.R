#' Calculates features on given data and updates a progress bar
#' 
#' @param data \code{data.frame} uploaded data frame for calculating features on
#' 
#' @return A data.frame with features
#' 
#' @note For updates of a progress bar to work properly, has to be placed
#' inside a withProgress() function.
#' 
shiny_encu <- function(data) {
  # Prepare the data for further processing
  cycles <- data.frame(cycles = data[, 1])
  data_RFU <- data.frame(data[, -1, drop = FALSE])
  
  # calculations of features
  run_res <- calcRunRes(data_RFU)
  
  res <- cbind(runs = colnames(data_RFU), run_res)
  rownames(res) <- NULL
  res
}
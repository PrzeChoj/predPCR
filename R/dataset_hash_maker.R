#' Calculates hash of a data set
#' Used to detect upload of a new datasets
#' 
#' @param dataset \code{data.frame} uploaded data frame for calculating hash on
#' 
#' @return Hash of a dataset
#' 
#' 
dataset_hash_maker <- function(dataset){
  sum(round(dataset, digits = 2), na.rm = TRUE)
}
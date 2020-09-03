#' Calculates statistics on given data and updates a progress bar
#' 
#' @param dataset \code{data.frame} uploaded data frame for calculating statistics on
#' 
#' @return A character vector of length 1 with text to be displayed
#' 
calculateDataStatistics <- function(dataset){
  cycles <-
    table(
      purrr::map_dbl(
        dataset[,-1],
        ~ (max(which(!is.na(.x)))) # number of cycles on a curve (drop NA from the end)
      )
    )
  
  
  out <- paste0("Dimension of data: ", paste(dim(dataset), collapse = " x "), "\n",
                "Number of curves: ", ncol(dataset) - 1, "\n",
                "Number of cycles:\n")
  for(i in 1:length(cycles)){
    out <- paste0(out, " ", cycles[i], " curves with ", names(cycles)[i], " cycles\n")
  }
  
  
  out
}
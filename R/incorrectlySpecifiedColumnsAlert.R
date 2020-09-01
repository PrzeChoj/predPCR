#' Makes a shinyalert after fail of selecting columns to be displayed
#' 
#' @param text \code{character} text to be displayed
#' @param pasted \code{character} text pasted
#' 
#' @return Nothing
#' 
incorrectlySpecifiedColumnsAlert <- function(text, pasted){
  shinyalert::shinyalert(text,
                         paste0("Keeping previous columns.\nPased text: ", pasted),
                         type = "error",
                         confirmButtonText = "OK",
                         confirmButtonCol = "#66cdaa")
}
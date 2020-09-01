#' Selects standard columns to display - first and last 5
#' 
#' @param numCol \code{numeric} Number of solumns to select from
#' 
#' @return Selected first and last 5 of columns
#' 
ncol_to_selectedColmns <- function(numCol){
  if(numCol < 5){
    1:numCol
  }else{
    union(1:5, (numCol - 4):numCol)
  }
}
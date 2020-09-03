#' Extracts last extension of a filename
#' 
#' @param filename \code{character} filename to extract extension from
#' 
#' @return A last dot(.) and text after it
#' 
extract_extension <- function(filename){
  stringr::str_extract(filename, "\\.([^\\.])+$")
}
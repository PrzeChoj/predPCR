#' Extracts last extension of a file
#' 
#' @param file \code{character} file to extract extension from
#' 
#' @return A last dot(.) and text after it
#' 
extract_extension <- function(file){
  stringr::str_extract(file, "\\.([^\\.])+$")
}
#' Attaches a helper to a UI object.
#' 
#' @param fun \code{function} UI object to have helper attached
#' @param content \code{character} A title of a helper.
#' 
#' @return An UI object with helper attached
#' 
helper_maker <- function(fun, content){
  shinyhelper::helper(fun,
                      icon = "question",
                      colour = "#ffffff",
                      type = "markdown",
                      buttonLabel = "OK",
                      content = content)
}
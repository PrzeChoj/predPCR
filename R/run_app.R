#' @title Run the predPCR Application
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options

options(shiny.maxRequestSize = 10*1024^2) # Extend maximum upload size

run_app <- function() {
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server
    ), 
    golem_opts = list()
  )
}

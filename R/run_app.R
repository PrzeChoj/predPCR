options(shiny.maxRequestSize = 10*1024^2) # Extend maximum upload size


#' Run the predPCR Application
#' 
#' Use graphical interface for predPCR model to predict results of PCR curves
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @import mlr
run_app <- function() {
  with_golem_options(
    app = shinyApp(
      ui = app_ui, 
      server = app_server
    ), 
    golem_opts = list()
  )
}

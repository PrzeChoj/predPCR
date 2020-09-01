#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
library(shiny)
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    tagList(shinydashboard::dashboardPage(title = "predPCR",
                                          shinydashboard::dashboardHeader(title = tagList(tags[["a"]](div(id = "homeclick",
                                                                                                          onclick = "openTab('appdesc')"),
                                                                                                      href = NULL,
                                                                                                      "predPCR",
                                                                                                      title = "Homepage",
                                                                                                      class = "home"),
                                                                                          tags[["script"]](shiny::HTML( "var openTab = function(tabName){
                                                                                                                        $('a', $('.sidebar')).each(function() {
                                                                                                                        if(this.getAttribute('data-value') == tabName) {
                                                                                                                        this.click()
                                                                                                                        };
                                                                                                                        });
                                                                                                                        }"))),
                                                                          titleWidth = 300),
                                          shinydashboard::dashboardSidebar(
                                            width = 300,
                                            shinyjs::useShinyjs(),
                                            shinyalert::useShinyalert(),
                                            shinydashboard::sidebarMenu(
                                              id = "tabs",
                                              tags[["br"]](),
                                              shinydashboard::menuItem("App description", tabName = "appdesc", icon = icon("info-circle")),
                                              tags[["hr"]](),
                                              shinydashboard::menuItem("Load data", tabName = "data", icon = icon("file-upload")),
                                              shiny::conditionalPanel(
                                                "input.tabs == 'data'",
                                                helper_maker(selectInput("filetype", "Select type of file",
                                                                         choices = c("Example File", ".csv", ".rdml")), "filetype"),
                                                fileInput("file", "Choose file with PCR curves",
                                                          accept = c("text/csv",
                                                                     "text/comma-separated-values,text/plain",
                                                                     ".csv",
                                                                     "text/rdml",
                                                                     ".rdml"))),
                                              tags[["hr"]](),
                                              shinydashboard::menuItem("Look at the aplification curves", tabName = "plots", icon = icon("chart-line")),
                                              conditionalPanel(
                                                "input.tabs == 'plots'",
                                                uiOutput("names")),
                                              tags[["hr"]](),
                                              shinydashboard::menuItem("Predict", tabName = "ml", icon = icon("calculator")),
                                              conditionalPanel(
                                                "input.tabs == 'ml'",
                                                helper_maker(actionButton("ml_results", "Predict", class = "btn-predict"), "predict")),
                                              tags[["hr"]]()
                                            )),
                                          shinydashboard::dashboardBody(
                                            tags[["link"]](rel = "stylesheet", type = "text/css", href = "custom_shiny.css"),
                                            shinydashboard::tabItems(
                                              shinydashboard::tabItem(tabName = "appdesc", includeMarkdown(file.path("inst", "app", "app_description.md"))),
                                              shinydashboard::tabItem(tabName = "data",
                                                                      fluidRow(column(12,
                                                                                      shinydashboard::box(width = 8,
                                                                                                          title = div("Select which columns to show", class = "title-box-text"),
                                                                                                          solidHeader = TRUE,
                                                                                                          column(6,
                                                                                                                 helper_maker(textInput("displayedColumns",
                                                                                                                                        "Select which columns to display"),
                                                                                                                              "displayedColumns")),
                                                                                                          column(6, 
                                                                                                                 actionButton("updateDisplayedColumns",
                                                                                                                              "Display selected columns",
                                                                                                                              class = "updateDisplayedColumns"))),
                                                                                      shinydashboard::box(width = 4,
                                                                                                          title = div("Data summary", class = "title-box-text"),
                                                                                                          solidHeader = TRUE,
                                                                                                          verbatimTextOutput("dataSummary")
                                                                                      ))),
                                                                      fluidRow(
                                                                        column(12,
                                                                               shinydashboard::box(width = 12,
                                                                                                   title = div("Table with loaded amplification curves", class = "title-box-text"),
                                                                                                   solidHeader = TRUE,
                                                                                                   helper_maker(shinycssloaders::withSpinner(DT::dataTableOutput("contents"), color="#d1e0e0"), "contents"))))),
                                              shinydashboard::tabItem(tabName = "plots",
                                                                      fluidRow(
                                                                        column(12,
                                                                               shinydashboard::box(width = 12,
                                                                                                   title = div("Scatter chart selected curve", class = "title-box-text"),
                                                                                                   solidHeader = TRUE,
                                                                                                   shinycssloaders::withSpinner(plotly::plotlyOutput("curveplot", width = "auto", height = "500px"), color="#d1e0e0"))))),
                                              shinydashboard::tabItem(tabName = "ml",
                                                                      fluidRow(
                                                                        column(12,
                                                                               div(id = "predict-table-box", 
                                                                                   shinydashboard::box(width = NULL,
                                                                                                       solidHeader = TRUE,
                                                                                                       title = div("Table with predicted data", class = "title-box-text"),
                                                                                                       helper_maker(shinycssloaders::withSpinner(DT::dataTableOutput("predictions_table_print"), color="#d1e0e0"), "predictions_table_print")
                                                                                   )))))
                                            )
                                          )),
            tags[["footer"]]("Designed by Paulina Przybyłek & Przemysław Chojecki", class = "footer"))
  )
}

#' Access files in the current app
#' 
#' @param ... Character vector specifying directory and or file to
#'     point to inside the current package.
#' 
#' @noRd
app_sys <- function(...){
  system.file(..., package = "golemexample")
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'predPCR'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}


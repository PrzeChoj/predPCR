#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  set.seed(1234)
  
  shinyhelper::observe_helpers()
  
  # load and show data
  
  observeEvent(input[["file"]], {
    if(is.null(input[["file"]])) return() # as far as I have checked, it should not happen.
    
    uploadedFileExtension <- extract_extension(input[["file"]][["datapath"]])
    if(uploadedFileExtension == ".csv")  updateSelectInput(session, "filetype", selected = ".csv" )
    if(uploadedFileExtension == ".rdml") updateSelectInput(session, "filetype", selected = ".rdml")
  })
  
  dataset <- reactive({
    inFile <- input[["file"]]
    typeFile <- input[["filetype"]]
    
    if(typeFile == "Example File"){
      value <- ncol_to_selectedColmns(11) # Example File has 11 columns
      updateTextInput(session, "displayedColumns", value = value)
      selectedColumns(value)
      
      return(as.data.frame(read.csv("data/example_file.csv")))
    }
    
    validate(
      need(!is.null(inFile), "Please select a file.")
    )
    
    # an user can upload a file with no extension - name of a file with no "." character
    uploadedFileExtension <- extract_extension(inFile[["datapath"]])
    if(!is.na(uploadedFileExtension)){ # if an user uploads a file with an extension, app checks if it is the same as selected type
      validate(
        need(uploadedFileExtension == typeFile, "Please select a file type that suits selected file.")
      )
    }
    
    tryCatch(expr = {
      if(typeFile == ".csv") load_dataset <- read.csv(inFile[["datapath"]])
      else {
        dt <- RDML::RDML[["new"]](inFile[["datapath"]])
        load_dataset <- dt[["GetFData"]]()
      }},
      error = function(e) {}, # error is handled in finally
      finally = {
        validate(
          need(exists("load_dataset"),
               "That file cannot be leaded. Please select a proper file type or try with another file.")
        )
      }
    )
    
    if(any(diff(round(load_dataset[,1], digits = 4)) != 1)){ # load_dataset is supposed to have number of cycle as first column
      load_dataset <- cbind(data.frame("Cycle" = 1:nrow(load_dataset)), load_dataset)
    }
    
    load_dataset <- as.data.frame(load_dataset)
    
    # display a confirmation
    shinyalert::shinyalert("Data uploaded successfully",
                           paste0("Number of curves: ", ncol(load_dataset) - 1),
                           type = "success",
                           confirmButtonText = "OK",
                           confirmButtonCol = "#66cdaa")
    
    value <- ncol_to_selectedColmns(ncol(load_dataset))
    updateTextInput(session, "displayedColumns", value = value)
    selectedColumns(value)
    
    load_dataset
  })
  
  old_dataset_hash <- reactiveVal(0)
  
  observeEvent(input[["updateDisplayedColumns"]],
               {
                 columnText <- input[["displayedColumns"]]
                 numCol <- ncol(dataset())
                 
                 tryCatch(
                   out <- eval(parse(text = paste0("c(", columnText, ")"))),
                   error = function(e){
                     incorrectlySpecifiedColumnsAlert("Incorrectly specified columns", columnText)
                     
                     validate(
                       need(FALSE, "")
                     )
                   }
                 )
                 
                 if(is.null(out) || length(out) == 1){  # out is NULL when no numbers have been pasted
                   incorrectlySpecifiedColumnsAlert("Please select at least 2 columns", input[["displayedColumns"]])
                   validate(
                     need(FALSE, "")
                   )
                 }
                 
                 if(!all( match(out, 1:ncol(dataset()), nomatch = 0L) > 0L )){ # !all( out %in% 1:ncol(dataset()) )
                   incorrectlySpecifiedColumnsAlert(paste0("Selected numbers are not integers between 1 and ", numCol),
                                                    input[["displayedColumns"]])
                   
                   validate(
                     need(FALSE, "")
                   )
                 }
                 
                 selectedColumns(out)
               })
  
  selectedColumns <- reactiveVal()
  
  output[["dataSummary"]] <- renderText({
    calculateDataStatistics(dataset())
  })
  
  output[["contents"]] <- DT::renderDataTable({
    dataset() # it has to be here, therefore dataset's validates will be checked before selectedColumns'
    
    out <- NULL
    tryCatch(
      out <- round(dataset()[,selectedColumns()], digits = 4),
      error = function(e){
        validate(
          need(FALSE, "Please reclick 'Display selected columns'")   # This should never be displayed. Code generating selectedColumns() should not allow to make error handled here.
        )
      }
    )
    out
  },
  
  options = list(scrollX = TRUE,
                 deferRender = TRUE,
                 paging = TRUE,
                 searching = FALSE,
                 lengthMenu = list(c(10, 15, 20, 25, -1), c("10", "15", "20", "25", "All")),
                 pageLength = 10,
                 server = TRUE
  ), 
  rownames = FALSE
  )
  
  # plot curves
  
  output[["curveplot"]] <- plotly::renderPlotly({
    if(input[["filetype"]] != "Example File"){ # if an user loads Example File, we do not have to check corectness
      validate(
        need(input[["file"]], "No data for make plot. Load an amplification curves data.")
      )
      
      uploadedFileExtension <- extract_extension(input[["file"]][["datapath"]])
      if(!is.na(uploadedFileExtension)){
        validate(
          need(uploadedFileExtension == input[["filetype"]], "No data to make a plot. Please select a file type that suits selected file and load an amplification curves data.")
        )
      }
      validate(
        need(!is.na(match(input[["curvename"]], colnames(dataset()))), "Wait for a data to update.") # this is shown if a data is changed, 
      )
    }
    plotCurve(dataset(), input[["curvename"]]) # plotCurve function is defined in the R folder
  })
  
  observe({
    shinyjs::hide("names")
    
    if(!is.null(dataset()))
      shinyjs::show("names")
  })
  
  output[["names"]] <- renderUI({
    helper_maker(selectInput("curvename", "Select curve to show",
                             choices = colnames(dataset())[-1]), "curvename")
  })
  
  # predict data
  
  encu_table <- reactive({
    tagAppendAttributes(
      withProgress(shiny_encu(dataset()), # shiny_encu is defined in the R folder
                   message = "Preparing for analysis",
                   session = session),
      id = "my_progress")
  })
  
  model <- reactive({
    e <- new.env()
    name <- load(file.path("data", "model.rda"), envir = e) # load function loads a file into an `e` enviroment
    e[[name]]
  })
  
  model_predict <- function(tbl){
    data.frame(curve = tbl[["runs"]],
               prediction = predict(model(), newdata = tbl)[["data"]][["response"]])
  }
  
  observeEvent(input[["filetype"]],{ # reset hash on changing the data set
    old_dataset_hash(0)
  })
  
  predictions_table <- reactive({ # at first check, if proper data is loaded and user clicked a "Predict" button
    validate(
      need(!input[["ml_results"]][1] == 0, "Please click 'Predict' button for loaded data")
    )
    validate(
      need(!inherits( try(dataset(), silent=TRUE),  "try-error"), "No data for create table. Please load data.")
    )
    validate(
      need(old_dataset_hash() == dataset_hash_maker(dataset()), "Please reclick 'Predict' button for new data")
    )
    
    # we are here only, if a user just pressed a "Predict" button.
    shinyjs::addClass(selector = "body", class = "sidebar-collapse") # it hides sidebar
    shinyjs::hide("homeclick") # it prevent click title page and move to Homepage
    
    tmp <- model_predict(isolate({encu_table()}))
    
    shinyjs::removeClass(selector = "body", class = "sidebar-collapse") # it unhides sidebar
    shinyjs::show("homeclick") # it allow click title page and move to Homepage
    
    tmp
  })
  
  observeEvent(input[["ml_results"]], {
    if(inherits( try(dataset(), silent=TRUE),  "try-error"))
      shinyalert::shinyalert("",
                             "PCR data cannot be predicted if data is not loaded.",
                             type = "error",
                             confirmButtonText = "OK",
                             confirmButtonCol = "#66cdaa")
    old_dataset_hash(dataset_hash_maker(dataset()))
  })
  
  
  output[["predictions_table_print"]] <- DT::renderDataTable(
    DT::datatable(predictions_table(), escape = FALSE, extensions = 'Buttons',
                  callback = DT::JS('$("a.buttons-copy").css("background-color","red"); 
                                     $("a.buttons-print").css("background-color","green"); 
                                     return table;'),
                  filter = "top", rownames = FALSE,
                  options = list(scrollX = TRUE,
                                 deferRender = TRUE,
                                 paging = TRUE,
                                 searching = TRUE,
                                 dom = "Brtip",
                                 buttons = c("copy", "csv", "excel", "print"),
                                 pageLength = 10,
                                 digits = 4)),
    rownames = FALSE,
    server = FALSE
    )
}
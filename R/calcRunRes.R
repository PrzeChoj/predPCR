#' Overload of calcRunRes() function to use inside shiny_encu()
#' 
#' @param data_RFU \code{data.frame} uploaded data frame for calculating features on with no cycle column
#' 
#' @return A data.frame with statistics
#' 
#' 
calcRunRes <- function(data_RFU) {
  ncol_data_RFU <- ncol(data_RFU)
  full_time <- 0
  do.call(rbind, lapply(1L:ncol_data_RFU, function(ith_run) {
    tictoc::tic()
    out <- PCRedux::pcrfit_single(data_RFU[, ith_run])
    ddpcr::quiet(time <- tictoc::toc()) # quiet makes the outcome invisible
    full_time <<- full_time + (time[["toc"]] - time[["tic"]]) # with a single "<" it seem not to work properly
    
    seconds <- round((full_time / ith_run) * (ncol_data_RFU - ith_run)) # estimating remaining time
    if(seconds > 200){
      shiny::incProgress(1/ncol_data_RFU, message = "Processing data", detail = paste0("wait ", round(seconds/60), " more minutes"))
    }else{
      shiny::incProgress(1/ncol_data_RFU, message = "Processing data", detail = paste0("wait ", seconds, " more seconds"))
    }
    
    out
  }))
}
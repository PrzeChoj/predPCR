#' Generates a plot of a given column from a dataset
#' 
#' @param dataset \code{data.frame} uploaded data frame
#' @param curvename \code{character} name of one of columns of dataset; will be plotted
#' 
#' @return A plotly graph
#' 
plotCurve <- function(dataset, curvename) {
  p <- ggplot2::ggplot(dataset, ggplot2::aes(x = !!rlang::sym(colnames(dataset)[1]), y = !!rlang::sym(curvename))) + # !!sym("colname") lets reference "colname" column in aes() function
    ggplot2::geom_point(colour = "#00695c", size = 4) +
    ggplot2::theme_bw() +
    ggplot2::labs(title = paste0("Curve ", curvename),
                  x = "Cycle",
                  y = "Fluerescence") +
    ggplot2::scale_x_continuous(breaks = seq(0, length(dataset[[curvename]]), 5)) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  
  plotly::ggplotly(p, show.legend = FALSE, height = 500)
}
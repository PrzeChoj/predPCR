model_predict <- function(tbl, model){
  data.frame(curve = tbl[["runs"]],
             prediction = predict(model, newdata = tbl)[["data"]][["response"]])
}
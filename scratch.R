predict.fms_base <- function (object, x, link = function(x) x, quantiles = c(0.025, 0.5, 0.975), x_train = NULL, ...) {
  if(is.null(x_train))
    x <- impute_x(object, x)
  else
    x <- impute_x_pred(object, x, x_train)
  if (object$intercept) {
    x <- cbind(1, x)
  }
  transforms.bak <- set.transforms(object$transforms)
  
  models <- object$models
  features <- object$populations
  model.probs <- object$model.probs
  
  x.precalc <- precalc.features(list(x = x, fixed = object$fixed), features)$x
  yhat <- matrix(0, nrow = nrow(x), ncol = length(models))
  for (k in seq_along(models)) {
    if (models[[k]]$crit == -.Machine$double.xmax) next
    yhat[, k] <- link(x.precalc[, c(rep(TRUE, object$fixed), models[[k]]$model), drop=FALSE] %*% models[[k]]$coefs)
  }
  
  mean.pred <- rowSums(yhat %*% diag(as.numeric(model.probs)))
  pred.quant <- apply(yhat, 1, weighted.quantiles, weights=model.probs, prob=quantiles)
  
  aggr <- list(mean = mean.pred, quantiles = pred.quant)
  set.transforms(transforms.bak)
  
  result <- list(aggr = aggr)
  class(result) <- "ffms_predict"
  return(result)
}

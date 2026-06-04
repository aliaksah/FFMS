#' Residuals for FFMS Model
#'
#' Computes residuals as the difference between observed and predicted values.
#'
#' @param object Object of class "ffms_base".
#' @param y Respnse.
#' @param x Covariates.
#' @param ... Additional arguments (ignored).
#' @return Vector of residuals.
#' @method residuals ffms_base
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "ffms_base", transforms = c("sigmoid"))
#' hist(residuals(model, exoplanet[,1], exoplanet[,-1]))
residuals.ffms_base <- function(object, y, x, ...) {
  stopifnot(inherits(object, "ffms_base"))
  if (is.null(object$residuals)) {
    pred <- predict(object, x)$aggr$mean
    return(y - pred)
  } else {
    object$residuals
  }
}

#' Residuals for FMS Model
#'
#' Computes residuals as the difference between observed and predicted values.
#'
#' @param object Object of class "fms_base".
#' @param y Respnse.
#' @param x Covariates.
#' @param ... Additional arguments (ignored).
#' @return Vector of residuals.
#' @method residuals fms_base
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
#' hist(residuals(model, exoplanet[,1], exoplanet[,-1]))
residuals.fms_base <- function(object, y, x, ...) {
  stopifnot(inherits(object, "fms_base"))
  if (is.null(object$residuals)) {
    pred <- predict(object, x)$aggr$mean
    return(y - pred)
  } else {
    object$residuals
  }
}

#' Residuals for BGNLM Model
#'
#' Computes residuals as the difference between observed and predicted values.
#'
#' @param object Object of class "bgnlm_model".
#' @param y Respnse.
#' @param x Covariates.
#' @param ... Additional arguments (ignored).
#' @return Vector of residuals.
#' @method residuals bgnlm_model
#' @export
#' @examples
#' library(FFMS)
#' data(exoplanet)
#' model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, family = "gaussian"))
#' hist(residuals(model, exoplanet[,1], exoplanet[,-1]))
residuals.bgnlm_model <- function(object,y, x, ...) {
  stopifnot(inherits(object, "bgnlm_model"))
  if (is.null(object$residuals)) {
    pred <- predict(object, x)
    return(y - pred)
  } else {
    object$residuals
  }
}

#' Residuals for FMS Parallel Model
#'
#' Computes residuals as the difference between observed and predicted values.
#'
#' @param object Object of class "fms_parallel".
#' @param y Respnse.
#' @param x Covariates.
#' @param ... Additional arguments (ignored).
#' @return Vector of residuals.
#' @method residuals fms_parallel
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms.parallel",runs = 2, cores = 1)
#' hist(residuals(model, exoplanet[,1], exoplanet[,-1]))
residuals.fms_parallel <- function(object, y, x, ...) {
  stopifnot(inherits(object, "fms_parallel"))
  if (is.null(object$residuals)) {
    pred <- predict(object, x)$aggr$mean
    return(y - pred)
  } else {
    object$residuals
  }
}


#' Residuals for FFMS Merged Model
#'
#' Computes residuals as the difference between observed and predicted values.
#'
#' @param object Object of class "ffms_merged".
#' @param y Respnse.
#' @param x Covariates.
#' @param ... Additional arguments (ignored).
#' @return Vector of residuals.
#' @method residuals ffms_merged
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, 
#' method = "ffms.parallel", transforms = c("sigmoid"), 
#' runs = 2, cores = 1)
#' hist(residuals(model, exoplanet[,1], exoplanet[,-1]))
residuals.ffms_merged <- function(object, y, x, ...) {
  stopifnot(inherits(object, "ffms_merged"))
  if (is.null(object$residuals)) {
    pred <- predict(object, x)$aggr$mean
    return(y - pred)
  } else {
    object$residuals
  }
}
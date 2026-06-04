#' Coefficients for FFMS Model
#'
#' Extracts coefficients from the best FFMS model found.
#'
#' @param object Object of class "ffms_base".
#' @param ... Additional arguments (ignored).
#' @return Vector of coefficients from the best model found.
#' @method coef ffms_base
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "ffms_base", transforms = c("sigmoid"))
#' coef(model)
coef.ffms_base <- function(object, ...) {
  stopifnot(inherits(object, "ffms_base"))
  cat("Posterior mode for the parameters of the best found single model:\n")
  best.mod <- get.best.model(object)
  best.mod$coefs
}

#' Coefficients for FMS Model
#'
#' Extracts coefficients from the best FMS model.
#'
#' @param object Object of class "fms_base".
#' @param ... Additional arguments (ignored).
#' @return Vector of coefficients from the best model found.
#' @method coef fms_base
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
#' coef(model)
coef.fms_base <- function(object, ...) {
  stopifnot(inherits(object, "fms_base"))
  cat("Posterior mode for the parameters of the best found single model:\n")
  best.mod <- get.best.model(object)
  best.mod$coefs
}

#' Coefficients for BGNLM Model
#'
#' Extracts coefficients from a BGNLM model.
#'
#' @param object Object of class "bgnlm_model".
#' @param ... Additional arguments (ignored).
#' @return Vector of coefficients.
#' @method coef bgnlm_model
#' @export
#' @examples
#' data(exoplanet)
#' model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, family = "gaussian"))
#' coef(model)
coef.bgnlm_model <- function(object, ...) {
  stopifnot(inherits(object, "bgnlm_model"))
  cat("Posterior mode for the parameters of the best found single model:\n")
  object$coefs
}

#' Coefficients for FMS Parallel Model
#'
#' Extracts coefficients from the best FMS parallel model.
#'
#' @param object Object of class "fms_parallel".
#' @param ... Additional arguments (ignored).
#' @return Vector of coefficients from the best model found.
#' @method coef fms_parallel
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms.parallel", cores = 1, runs = 2)
#' coef(model)
coef.fms_parallel <- function(object, ...) {
  stopifnot(inherits(object, "fms_parallel"))
  cat("Posterior mode for the parameters of the best found single model:\n")
  best.mod <- get.best.model(object)
  best.mod$coefs
}

#' Coefficients for FFMS Merged Model
#'
#' Extracts coefficients from the best FFMS merged model.
#'
#' @param object Object of class "ffms_merged".
#' @param ... Additional arguments (ignored).
#' @return Vector of coefficients from the best model found.
#' @method coef ffms_merged
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, 
#' method = "ffms.parallel", transforms = c("sigmoid"), 
#' runs = 2, cores = 1)
#' coef(model)
coef.ffms_merged <- function(object, ...) {
  stopifnot(inherits(object, "ffms_merged"))
  best.mod <- get.best.model(object)
  best.mod$coefs
}
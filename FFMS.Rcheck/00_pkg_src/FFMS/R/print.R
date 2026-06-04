
#' Print FFMS Model Object
#'
#' Displays a concise summary of a FFMS model object.
#'
#' @param x Object of class "ffms_base".
#' @param ... Additional arguments passed to summary method.
#' @return Prints a summary of the model and returns NULL
#' @method print ffms_base
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet,method = "ffms_base", transforms = c("sigmoid"))
#' print(model)
print.ffms_base <- function(x, ...) {
  stopifnot(inherits(x, "ffms_base")) 
  cat("FFMS Model Summary:\n")
  print(summary(x, ...))
}

#' Print FMS Model Object
#'
#' Displays a concise summary of an FMS model object.
#'
#' @param x Object of class "fms_base".
#' @param ... Additional arguments passed to summary method.
#' @return Prints a summary of the model and returns NULL
#' @method print fms_base
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
#' print(model)
print.fms_base <- function(x, ...) {
  stopifnot(inherits(x, "fms_base"))
  cat("FMS Model Summary:\n")
  print(summary(x, ...))
}

#' Print BGNLM Model Object
#'
#' Displays the coefficients of a BGNLM model object.
#'
#' @param x Object of class "bgnlm_model".
#' @param ... Additional arguments (ignored).
#' @return Prints a summary of the model and returns NULL
#' @method print bgnlm_model
#' @export
#' @examples
#' data(exoplanet)
#' model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, 
#' family = "gaussian"))
#' print(model)
#' model <- get.mpm.model(ffms(semimajoraxis ~ ., data = exoplanet, 
#' family = "gaussian"), y = exoplanet[,1],x = exoplanet[,-1])
#' print(model)
print.bgnlm_model <- function(x, ...) {
  stopifnot(inherits(x, "bgnlm_model"))
  cat("BGNLM Model Coefficients:\n")
  print(x$coefs)
}


#' Print FMS Parallel Model Object
#'
#' Displays a concise summary of an FMS parallel model object.
#'
#' @param x Object of class "fms_parallel".
#' @param ... Additional arguments passed to summary method.
#' @return Prints a summary of the model and returns NULL
#' @method print fms_parallel
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms.parallel", cores = 1, runs = 2)
#' print(model)
print.fms_parallel <- function(x, ...) {
  stopifnot(inherits(x, "fms_parallel"))
  cat("FMS Parallel Model Summary:\n")
  print(summary(x, ...))
}

#' Print FFMS Merged Model Object
#'
#' Displays a concise summary of a FFMS merged model object.
#'
#' @param x Object of class "ffms_merged".
#' @param ... Additional arguments passed to summary method.
#' @return Prints a summary of the model and returns NULL
#' @method print ffms_merged
#' @export
#' @examples
#' data(exoplanet)
#' model <- ffms(semimajoraxis ~ ., data = exoplanet, 
#' method = "ffms.parallel", cores = 1, runs = 2, 
#' transforms = c("sigmoid"))
#' 
#' print(model)
print.ffms_merged <- function(x, ...) {
  stopifnot(inherits(x, "ffms_merged"))
  cat("FFMS Merged Model Summary:\n")
  print(summary(x, ...))
}

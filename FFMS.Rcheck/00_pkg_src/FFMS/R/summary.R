#' Function to Print a Quick Summary of the Results
#'
#' @param object The results to use
#' @param top_N The number of top unique models to report. Defaults to 10.
#' @param labels Should the covariates be named, or just referred to as their place in the data.frame.
#' @param verbose If the summary should be printed to the console or just returned, defaults to TRUE
#' @param ... Not used.
#'
#' @return A data frame containing the top models and their features.
#'
#' @export
summary.ffms_base <- function (object, top_N = 10, labels = FALSE, verbose = TRUE, ...) {
  transforms.bak <- set.transforms(object$transforms)
  if (length(labels) == 1 && labels[1] == FALSE && length(object$labels) > 0) {
    labels = object$labels
  }
  
  all_models <- list()
  for (p in seq_along(object$populations)) {
      if (length(object$models[[p]]) > 0) {
          model_obj <- object$models[[p]][[1]]
          feat_strings <- sapply(object$populations[[p]][model_obj$model], FUN = function(x) print.feature(x = x, labels = labels, round = 2))
          if (length(feat_strings) == 0) feat_strings <- "Intercept Only"
          
          all_models[[p]] <- list(
              crit = model_obj$crit,
              feats = paste(feat_strings, collapse = ", "),
              coefs = paste(round(model_obj$coefs, 4), collapse = ", "),
              pop = p
          )
      }
  }
  
  df <- do.call(rbind, lapply(all_models, as.data.frame))
  if (nrow(df) == 0) return(NULL)
  
  df$SIC <- -2 * as.numeric(df$crit)
  df <- df[order(df$SIC), ]
  df <- df[!duplicated(df$feats), ]
  
  top_N <- min(top_N, nrow(df))
  df_top <- df[1:top_N, ]
  
  if (verbose) {
      cat(sprintf("\nTop %d Distinct Models by SIC:\n\n", top_N))
      for (i in 1:top_N) {
          cat(sprintf("Model #%d (Found in Pop %d) | SIC: %.3f\n", i, df_top$pop[i], df_top$SIC[i]))
          cat(sprintf("  Features: %s\n", df_top$feats[i]))
          cat(sprintf("  Coefficients: %s\n\n", df_top$coefs[i]))
      }
  }
  
  set.transforms(transforms.bak)
  return(invisible(df_top))
}

#' Function to Print a Quick Summary of the Results
#'
#' @param object The results to use
#' @param top_N The number of top unique models to report. Defaults to 10.
#' @param labels Should the covariates be named, or just referred to as their place in the data.frame.
#' @param verbose If the summary should be printed to the console or just returned, defaults to TRUE
#' @param ... Not used.
#'
#' @export
summary.ffms_merged <- function (object, top_N = 10, labels = FALSE, verbose = TRUE, ...) {
  if (length(labels) == 1 && labels[1] == FALSE && length(object$results.raw[[1]]$labels) > 0) {
    labels = object$results.raw[[1]]$labels
  }
  
  all_models <- list()
  idx <- 1
  for (chain in object$results.raw) {
      transforms.bak <- set.transforms(chain$transforms)
      for (p in seq_along(chain$populations)) {
          if (length(chain$models[[p]]) > 0) {
              model_obj <- chain$models[[p]][[1]]
              feat_strings <- sapply(chain$populations[[p]][model_obj$model], FUN = function(x) print.feature(x = x, labels = labels, round = 2))
              if (length(feat_strings) == 0) feat_strings <- "Intercept Only"
              
              all_models[[idx]] <- list(
                  crit = model_obj$crit,
                  feats = paste(feat_strings, collapse = ", "),
                  coefs = paste(round(model_obj$coefs, 4), collapse = ", "),
                  pop = p
              )
              idx <- idx + 1
          }
      }
      set.transforms(transforms.bak)
  }
  
  df <- do.call(rbind, lapply(all_models, as.data.frame))
  if (nrow(df) == 0) return(NULL)
  
  df$SIC <- -2 * as.numeric(df$crit)
  df <- df[order(df$SIC), ]
  df <- df[!duplicated(df$feats), ]
  
  top_N <- min(top_N, nrow(df))
  df_top <- df[1:top_N, ]
  
  if (verbose) {
      cat(sprintf("\nTop %d Distinct Models by SIC (Across All Threads):\n\n", top_N))
      for (i in 1:top_N) {
          cat(sprintf("Model #%d (Found in Pop %d) | SIC: %.3f\n", i, df_top$pop[i], df_top$SIC[i]))
          cat(sprintf("  Features: %s\n", df_top$feats[i]))
          cat(sprintf("  Coefficients: %s\n\n", df_top$coefs[i]))
      }
  }
  
  return(invisible(df_top))
}

#' Function to Print a Quick Summary of the Results
#'
#' @param object The results to use
#' @param top_N The number of top unique models to report. Defaults to 10.
#' @param labels Should the covariates be named, or just referred to as their place in the data.frame.
#' @param verbose If the summary should be printed to the console or just returned, defaults to TRUE
#' @param ... Not used.
#'
#' @export
summary.fms_base <- function (object, top_N = 10, labels = FALSE, verbose = TRUE, ...) {
  if (length(labels) == 1 && labels[1] == FALSE && length(object$labels) > 0) {
    labels = object$labels
  }
  
  if (length(object$models) == 0) return(NULL)
  model_obj <- object$models[[1]]
  feat_strings <- sapply(object$populations[model_obj$model], FUN = function(x) print.feature(x = x, labels = labels, round = 2))
  if (length(feat_strings) == 0) feat_strings <- "Intercept Only"
  
  df <- data.frame(
      crit = model_obj$crit,
      feats = paste(feat_strings, collapse = ", "),
      coefs = paste(round(model_obj$coefs, 4), collapse = ", ")
  )
  df$SIC <- -2 * as.numeric(df$crit)
  
  if (verbose) {
      cat(sprintf("\nBest Model by SIC:\n\n"))
      cat(sprintf("SIC: %.3f\n", df$SIC[1]))
      cat(sprintf("Features: %s\n", df$feats[1]))
      cat(sprintf("Coefficients: %s\n\n", df$coefs[1]))
  }
  
  return(invisible(df))
}

#' Function to Print a Quick Summary of the Results
#'
#' @param object The results to use
#' @param top_N The number of top unique models to report. Defaults to 10.
#' @param labels Should the covariates be named, or just referred to as their place in the data.frame.
#' @param verbose If the summary should be printed to the console or just returned, defaults to TRUE
#' @param ... Not used.
#'
#' @export
summary.fms_parallel <- function (object, top_N = 10, labels = FALSE, verbose = TRUE, ...) {
  if (length(labels) == 1 && labels[1] == FALSE && length(object$labels) > 0) {
    labels = object$labels
  }
  
  all_models <- list()
  for (i in seq_along(object$chains)) {
      chain <- object$chains[[i]]
      if (length(chain$models) > 0) {
          model_obj <- chain$models[[1]]
          feat_strings <- sapply(chain$populations[model_obj$model], FUN = function(x) print.feature(x = x, labels = labels, round = 2))
          if (length(feat_strings) == 0) feat_strings <- "Intercept Only"
          all_models[[i]] <- list(
              crit = model_obj$crit,
              feats = paste(feat_strings, collapse = ", "),
              coefs = paste(round(model_obj$coefs, 4), collapse = ", ")
          )
      }
  }
  
  df <- do.call(rbind, lapply(all_models, as.data.frame))
  if (nrow(df) == 0) return(NULL)
  
  df$SIC <- -2 * as.numeric(df$crit)
  df <- df[order(df$SIC), ]
  df <- df[!duplicated(df$feats), ]
  
  top_N <- min(top_N, nrow(df))
  df_top <- df[1:top_N, ]
  
  if (verbose) {
      cat(sprintf("\nTop %d Distinct Models by SIC (Across All Threads):\n\n", top_N))
      for (i in 1:top_N) {
          cat(sprintf("Model #%d | SIC: %.3f\n", i, df_top$SIC[i]))
          cat(sprintf("  Features: %s\n", df_top$feats[i]))
          cat(sprintf("  Coefficients: %s\n\n", df_top$coefs[i]))
      }
  }
  
  return(invisible(df_top))
}

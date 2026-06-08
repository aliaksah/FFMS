#' Gradient for GLM with SIC Penalty
#'
#' @param x A matrix containing the covariates (including an intercept if one wants to use one).
#' @param y The dependent variable.
#' @param theta The coefficient vector to use.
#' @param idx The observation indices to use.
#' @param family A glm family for the distribution to use, i.e. "binomial()".
#' @param lambda A vector of feature-specific SIC penalties.
#' @param epsilon The current epsilon for the epsilon-telescope.
#'
#' @export sic.grad
sic.grad <- function (x, y, theta, idx, family, lambda, epsilon) {
  stop("Deprecated. Use optim(BFGS) in sic_optimize.loop instead.")
}

#' (Batch) (Stochastic) Gradient Descent for SIC
#'
#' @noRd
sic.sgd <- function (x, y, family, lambda, epsilon, sgd.ctrl=NULL) {
  stop("Deprecated.")
}

#' (Batch) (Stochastic) Gradient Descent
#'
#' @noRd
sgd <- function (gradient, data=NULL, ctrl=list()) {
  stop("Deprecated.")
}

#' SIC optimize loop (replaces fms_base.loop)
#'
#' @noRd
sic_optimize.loop <- function(data.t, complex, loglik.pi, model.cur, N.this, probs, params, sub, verbose) {
  y <- data.t$y
  X <- data.t$x
  # Sanitize X to prevent NaN gradients for invalid features
  X[!is.finite(X)] <- 0
  nobs <- nrow(X)
  nvars <- ncol(X)
  
  # Standardize X (keep intercept as 1)
  # X_scaled = (X - mean) / sd
  fixed_cols <- data.t$fixed
  X_scaled <- X
  X_means <- rep(0, nvars)
  X_sds <- rep(1, nvars)
  if (nvars > fixed_cols) {
      for (j in (fixed_cols + 1):nvars) {
          if (sd(X[,j]) > 1e-8) {
              X_means[j] <- mean(X[,j])
              X_sds[j] <- sd(X[,j])
              X_scaled[,j] <- (X[,j] - X_means[j]) / X_sds[j]
          }
      }
  }

  family_str <- params$mlpost$family
  if (is.null(family_str)) family_str <- "gaussian"
  
  family_use <- switch(family_str,
                       binomial = stats::binomial(),
                       poisson = stats::poisson(),
                       Gamma = stats::Gamma(),
                       stats::gaussian())

  # Epsilon telescope parameters
  eps1 <- if(!is.null(params$sic$eps1)) params$sic$eps1 else 10.0
  epsT <- if(!is.null(params$sic$epsT)) params$sic$epsT else 1e-5
  stepsT <- if(!is.null(params$sic$stepsT)) params$sic$stepsT else 100
  
  n_features <- nvars - fixed_cols
  
  c_base <- log(nobs)
  lambda <- numeric(nvars)
  r <- params$mlpost$r
  if (is.null(r)) r <- 1 / nobs
  
  penalty_a <- if (!is.null(params$sic$penalty_a)) params$sic$penalty_a else 1.0
  
  for (j in 1:nvars) {
    if (j <= fixed_cols) {
      lambda[j] <- 0
    } else {
      oc_j <- complex$oc[j - fixed_cols]
      if (is.null(oc_j) || is.na(oc_j)) oc_j <- 1
      oc_j <- max(1, oc_j)
      # BIC-consistent penalty: each complexity unit costs log(n).
      # oc_j counts total operations/nodes in the feature tree.
      # Intercept costs 1*log(n) (handled via rank in glm), each nonlinear
      # feature costs oc_j * log(n) additional to match FBMS log posterior.
      lambda[j] <- penalty_a * oc_j * c_base
    }
  }
  
  # Objective function for optim
  sic_objective <- function(theta, eps) {
      eta <- family_use$linkinv(X_scaled %*% theta)
      if (family_str == "gaussian") {
          dev <- sum((y - eta)^2)
          # negative log-likelihood (proportional to)
          nll <- nobs / 2 * log(2 * pi * max(dev/nobs, 1e-10)) + dev / (2 * max(dev/nobs, 1e-10))
      } else {
          nll <- sum(family_use$dev.resids(y, eta, 1)) / 2
      }
      pen <- sum(lambda * (theta^2 / (theta^2 + eps^2)))
      return(2 * nll + pen)
  }
  
  # Gradient function for optim
  sic_gradient <- function(theta, eps) {
      eta <- family_use$linkinv(X_scaled %*% theta)
      
      if (family_str == "gaussian") {
          sigma2 <- max(sum((y - eta)^2) / nobs, 1e-10)
          grad_nll <- -t(X_scaled) %*% (y - eta) / sigma2
      } else if (family_str == "binomial" || family_str == "poisson") {
          grad_nll <- -t(X_scaled) %*% (y - eta)
      } else {
          grad_nll <- -t(X_scaled) %*% ((y - eta) * family_use$mu.eta(family_use$linkfun(eta)) / family_use$variance(eta))
      }
      grad_pen <- lambda * (2 * theta * eps^2) / ((theta^2 + eps^2)^2)
      return(2 * as.vector(grad_nll) + grad_pen)
  }

  if (!is.null(model.cur$coefs) && length(model.cur$coefs) == nvars) {
      # Adjust init coefs for scaling
      beta_init <- model.cur$coefs
      if (nvars > fixed_cols) {
          for (j in (fixed_cols + 1):nvars) {
             beta_init[j] <- beta_init[j] * X_sds[j]
          }
          if (fixed_cols > 0) {
              beta_init[1:fixed_cols] <- beta_init[1:fixed_cols] + sum(model.cur$coefs[(fixed_cols+1):nvars] * X_means[(fixed_cols+1):nvars])
          }
      }
  } else {
      beta_init <- rep(0, nvars)
      if (family_str == "gaussian" && fixed_cols > 0) beta_init[1] <- mean(y)
  }
  
  eps_seq <- exp(seq(log(eps1), log(epsT), length.out = stepsT))
  beta_cur <- beta_init
  
  for (step in 1:stepsT) {
      eps_cur <- eps_seq[step]
      # Run BFGS
      tryCatch({
          opt_res <- optim(
              par = beta_cur,
              fn = sic_objective,
              gr = sic_gradient,
              eps = eps_cur,
              method = "BFGS",
              control = list(maxit = 200, reltol = 1e-8)
          )
          beta_cur <- opt_res$par
      }, error = function(e) {
          # If BFGS fails (e.g. non-finite diff), fall back gracefully
          warning("BFGS step failed, falling back to current beta. error: ", e)
      })
  }

  # SIC polish: choose the active coefficient set after refitting candidate
  # supports. Features that leave the current model can still be sampled from
  # F.0 by the genetic generator in later populations.
  optimize_active <- function(active) {
      active[seq_len(fixed_cols)] <- TRUE
      theta <- numeric(nvars)
      if (family_str == "gaussian") {
          fit <- lm.fit(X_scaled[, active, drop = FALSE], y)
          theta[active] <- fit$coefficients
      } else {
          fit <- glm.fit(X_scaled[, active, drop = FALSE], y, family = family_use)
          theta[active] <- fit$coefficients
      }
      theta
  }

  exact_ic <- function(active) {
      active[seq_len(fixed_cols)] <- TRUE
      if (family_str == "gaussian") {
          fit <- lm.fit(X_scaled[, active, drop = FALSE], y)
          rss <- sum(fit$residuals^2)
          return(nobs * log(max(rss / nobs, 1e-10)) + sum(lambda[active]))
      }
      fit <- glm.fit(X_scaled[, active, drop = FALSE], y, family = family_use)
      fit$deviance + sum(lambda[active])
  }

  active <- rep(TRUE, nvars)
  current_ic <- exact_ic(active)
  improved <- TRUE
  while (improved) {
      improved <- FALSE
      candidates <- which(active)
      candidates <- candidates[candidates > fixed_cols]
      best_active <- active
      best_ic <- current_ic
      for (j in candidates) {
          proposal_active <- active
          proposal_active[j] <- FALSE
          proposal_ic <- tryCatch(exact_ic(proposal_active), error = function(e) Inf)
          if (proposal_ic < best_ic) {
              best_active <- proposal_active
              best_ic <- proposal_ic
          }
      }
      if (best_ic < current_ic) {
          active <- best_active
          current_ic <- best_ic
          improved <- TRUE
      }
  }
  beta_cur <- optimize_active(active)
  
  # Unscale betas
  beta_unscaled <- beta_cur
  if (nvars > fixed_cols) {
      for (j in (fixed_cols + 1):nvars) {
          beta_unscaled[j] <- beta_cur[j] / X_sds[j]
      }
      if (fixed_cols > 0) {
          beta_unscaled[1] <- beta_cur[1] - sum(beta_cur[(fixed_cols+1):nvars] * X_means[(fixed_cols+1):nvars] / X_sds[(fixed_cols+1):nvars])
      }
  }
  
  sic.probs.full <- beta_cur^2 / (beta_cur^2 + epsT^2)
  if (fixed_cols > 0) {
      sic.probs.full[1:fixed_cols] <- 1.0
  }
  
  marg.probs_vec <- if(n_features > 0) sic.probs.full[(fixed_cols + 1):nvars] else numeric(0)
  sic.probs <- matrix(marg.probs_vec, nrow = 1)
  
  # Keep the selected active set in the model object. The full original
  # covariate pool remains available to the genetic generator via F.0.
  best.crit <- -current_ic / 2
  coefs_active <- beta_unscaled[active]
  
  mock_model <- list(
      model = active[(fixed_cols + 1):nvars],
      coefs = coefs_active,
      crit = best.crit
  )
  
  return(list(
    models = list(mock_model), 
    mc.models = list(mock_model),
    sic.probs = sic.probs,
    model.probs = c(1.0),
    model.probs.idx = c(1),
    best.crit = best.crit,
    accept = 1.0,
    coefs = beta_unscaled
  ))
}

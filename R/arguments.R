# Title     : Arguments generator
# Objective : Functions intended to help the user generate proper arguments for the algorithm
# Created by: jonlachmann
# Created on: 2021-02-19

#' Generate a Probability List for FMS (Mode Jumping MCMC)
#'
#' @return A named list with five elements:
#' \describe{
#'   \item{\code{large}}{A numeric value representing the probability of making a large jump. If a large jump is not made, a local MH (Metropolis-Hastings) proposal is used instead.}
#'   \item{\code{large.kern}}{A numeric vector of length 4 specifying the probabilities for different types of large jump kernels. The four components correspond to:
#'     \enumerate{
#'       \item Random change with random neighborhood size
#'       \item Random change with fixed neighborhood size
#'       \item Swap with random neighborhood size
#'       \item Swap with fixed neighborhood size
#'     }
#'     These probabilities will be automatically normalized if they do not sum to 1.}
#'   \item{\code{localopt.kern}}{A numeric vector of length 2 specifying the probabilities for different local optimization methods during large jumps. The first value represents the probability of using simulated annealing, while the second corresponds to the greedy optimizer. These probabilities will be normalized if needed.}
#'   \item{\code{random.kern}}{A numeric vector of length 2 specifying the probabilities of different randomization kernels applied after local optimization of type one or two. These correspond to the first two kernel types as in \code{large.kern} but are used for local proposals with different neighborhood sizes.}
#'   \item{\code{mh}}{A numeric vector specifying the probabilities of different standard Metropolis-Hastings kernels, where the first four as the same as for other kernels, while fifths and sixes components are uniform addition/deletion of a covariate.}
#' }
#'
#' @examples
#' gen.probs.fms_base()
#' 
#' @export gen.probs.fms_base
#' 
gen.probs.fms_base <- function () {
  ## Mode jumping algorithm probabilities
  large <- 0.05                         # probability of a large jump
  large.kern <- c(0, 0, 0, 1)           # probability for type of large jump, only allow type 1-4
  localopt.kern <- c(0.5, 0.5)          # probability for each localopt algorithm
  random.kern <- c(0.5, 0.5)            # probability for random jump kernels
  mh <- c(0.2, 0.2, 0.2, 0.2, 0.1, 0.1) # probability for regular mh kernels

  # Compile the list
  probs <- list(large=large, large.kern=large.kern, localopt.kern=localopt.kern,
                random.kern=random.kern, mh=mh)

  return(probs)
}

#' Generate a Probability List for FFMS (Genetically Modified FMS)
#'
#' @param transforms A list of the transformations used (to get the count).
#'
#' @return A named list with eight elements:
#' \describe{
#'   \item{\code{large}}{The probability of a large jump kernel in the FMS algorithm. 
#'   With this probability, a large jump proposal will be made; otherwise, a local 
#'   Metropolis-Hastings proposal will be used. One needs to consider good mixing 
#'   around and between modes when specifying this parameter.}
#'   
#'   \item{\code{large.kern}}{A numeric vector of length 4 specifying the probabilities 
#'   for different types of large jump kernels. 
#'   The four components correspond to:
#'     \enumerate{
#'       \item Random change with random neighborhood size
#'       \item Random change with fixed neighborhood size
#'       \item Swap with random neighborhood size
#'       \item Swap with fixed neighborhood size
#'     }
#'   These probabilities will be automatically normalized if they do not sum to 1.}
#'   
#'   \item{\code{localopt.kern}}{A numeric vector of length 2 specifying the probabilities 
#'   for different local optimization methods during large jumps. The first value represents 
#'   the probability of using simulated annealing, while the second corresponds to the 
#'   greedy optimizer. These probabilities will be normalized if needed.}
#'   
#'   \item{\code{random.kern}}{A numeric vector of length 2 specifying the probabilities 
#'   of first two randomization kernels applied after local optimization. These correspond 
#'   to the same kernel types as in \code{large.kern} but are used for local proposals 
#'   where type and 2 only are allowed.}
#'   
#'   \item{\code{mh}}{A numeric vector specifying the probabilities of different standard Metropolis-Hastings kernels, where the first four as the same as for other kernels, while fifths and sixes components are uniform addition/deletion of a covariate.}
#'   
#'   \item{\code{filter}}{A numeric value controlling the filtering of features 
#'   with low posterior probabilities in the current population. Features with 
#'   posterior probabilities below this threshold will be removed with a probability 
#'   proportional to \eqn{1 - P(\text{feature} \mid \text{population})}.}
#'   
#'   \item{\code{gen}}{A numeric vector of length 4 specifying the probabilities of different 
#'   feature generation operators. These determine how new nonlinear features are introduced. 
#'   The first entry gives the probability for an interaction, followed by modification, 
#'   nonlinear projection, and a mutation operator, which reintroduces discarded features. 
#'   If these probabilities do not sum to 1, they are automatically normalized.}
#'   
#'   \item{\code{trans}}{A numeric vector of length equal to the number of elements in \code{transforms}, 
#'   specifying the probabilities of selecting each nonlinear transformation from \eqn{\mathcal{G}}. 
#'   By default, a uniform distribution is assigned, but this can be modified by providing a specific 
#'   \code{transforms} argument.}
#' }
#'
#' @examples
#' gen.probs.ffms_base(c("p0", "exp_dbl"))
#' 
#'
#' @export gen.probs.ffms_base
gen.probs.ffms_base <- function (transforms) {
  if (!is.character(transforms))
    stop("The argument transforms must be a character vector specifying the transformations.")

  # Get probs for fms_base
  probs <- gen.probs.fms_base()

  ## Feature generation probabilities
  transcount <- length(transforms)
  filter <- 0.6                             # filtration threshold
  gen <- c(0.40,0.40,0.10,0.10)             # probability for different feature generation methods
  trans <- rep(1 / transcount, transcount)  # probability for each different nonlinear transformation
  trans_priors <- rep(1, transcount)        # Default values assigned to each transformation to be used as "operation count".

  probs$filter <- filter
  probs$gen <- gen
  probs$trans <- trans
  probs$trans_priors <- trans_priors

  return(probs)
}

#' Generate a Parameter List for FMS (Mode Jumping MCMC)
#'
#' @param ncov The number of covariates in the dataset that will be used in the algorithm
#'
#' @return A list of parameters to use when running the fms_base function.
#' 
#' The list contains the following elements:
#' 
#' \describe{
#'   \item{\code{burn_in}}{The burn-in period for the FMS algorithm, which is set to 100 iterations by default.}
#'
#'   \item{\code{mh}}{A list containing parameters for the regular Metropolis-Hastings (MH) kernel:
#'     \describe{
#'       \item{\code{neigh.size}}{The size of the neighborhood for MH proposals with fixed proposal size, default set to 1.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size for random proposal size, default set to 1.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size for random proposal size, default set to 2.}
#'     }
#'   }
#'
#'   \item{\code{large}}{A list containing parameters for the large jump kernel:
#'     \describe{
#'       \item{\code{neigh.size}}{The size of the neighborhood for large jump proposals with fixed neighborhood size, default set to the smaller of 0.35 \eqn{\times p}  and 35, where \eqn{p} is the number of covariates.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size for large jumps with random size of the neighborhood, default set to the smaller of 0.25 \eqn{\times p}  and 25.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size for large jumps with random size of the neighborhood, default set to the smaller of 0.45 \eqn{\times p}  and 45.}
#'     }
#'   }
#'
#'   \item{\code{random}}{A list containing a parameter for the randomization kernel:
#'     \describe{
#'       \item{\code{prob}}{The small probability of changing the component around the mode, default set to 0.01.}
#'     }
#'   }
#'
#'   \item{\code{sa}}{A list containing parameters for the simulated annealing kernel:
#'     \describe{
#'       \item{\code{probs}}{A numeric vector of length 6 specifying the probabilities for different types of proposals in the simulated annealing algorithm.}
#'       \item{\code{neigh.size}}{The size of the neighborhood for the simulated annealing proposals, default set to 1.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size, default set to 1.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size, default set to 2.}
#'       \item{\code{t.init}}{The initial temperature for simulated annealing, default set to 10.}
#'       \item{\code{t.min}}{The minimum temperature for simulated annealing, default set to 0.0001.}
#'       \item{\code{dt}}{The temperature decrement factor, default set to 3.}
#'       \item{\code{M}}{The number of iterations in the simulated annealing process, default set to 12.}
#'     }
#'   }
#'
#'   \item{\code{greedy}}{A list containing parameters for the greedy algorithm:
#'     \describe{
#'       \item{\code{probs}}{A numeric vector of length 6 specifying the probabilities for different types of proposals in the greedy algorithm.}
#'       \item{\code{neigh.size}}{The size of the neighborhood for greedy algorithm proposals, set to 1.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size for greedy proposals, set to 1.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size for greedy proposals, set to 2.}
#'       \item{\code{steps}}{The number of steps for the greedy algorithm, set to 20.}
#'       \item{\code{tries}}{The number of tries for the greedy algorithm, set to 3.}
#'     }
#'   }
#'
#'   \item{\code{loglik}}{A list to store log-likelihood values, which is by default empty.}
#' }
#'
#' Note that the `$loglik` item is an empty list, which is passed to the log likelihood function of the model,
#' intended to store parameters that the estimator function should use.
#'
#' @examples
#' gen.params.fms_base(matrix(rnorm(600), 100))
#' 
#'
#' @export gen.params.fms_base
gen.params.fms_base <- function (ncov) {
  ### Create a list of parameters for the algorithm

  ## Local optimization parameters
  sa_kern <- list(probs=c(0.1, 0.05, 0.2, 0.3, 0.2, 0.15),
                  neigh.size=1, neigh.min=1, neigh.max=2)               # Simulated annealing proposal kernel parameters
  sa_params <- list(t.init=10, t.min=0.0001, dt=3, M=12, kern=sa_kern)  # Simulated annealing parameters
  greedy_kern <- list(probs=c(0.1, 0.05, 0.2, 0.3, 0.2, 0.15),
                      neigh.size=1, neigh.min=1, neigh.max=2)           # Greedy algorithm proposal kernel parameters
  greedy_params <- list(steps=20, tries=3, kern=greedy_kern)            # Greedy algorithm parameters (60 models default)

  ## FMS parameters
  burn_in <- 100                                                        # TODO

  # Large jump parameters
  large_params <- list(
    neigh.size = min(as.integer(ncov * 0.35),35),
    neigh.min = min(as.integer(ncov * 0.25),25),
    neigh.max = min(as.integer(ncov * 0.45),45)
  )
  random_params <- list(prob = 0.01)  # Small random jump parameters
  mh_params <- list(neigh.size = 1, neigh.min = 1, neigh.max = 2)      # Regular MH parameters
  ## Compile the list and return
  params <- list(burn_in=burn_in, mh=mh_params, large=large_params, random=random_params,
                 sa=sa_params, greedy=greedy_params)

  return(params)
}

#' Generate a Parameter List for FFMS (Genetically Modified FMS)
#'
#' This function generates the full list of parameters required for the Generalized Mode Jumping Markov Chain Monte Carlo (FFMS) algorithm, building upon the parameters from \code{gen.params.fms_base}. The generated parameter list includes feature generation settings, population control parameters, and optimization controls for the search process.
#'
#' @param ncov The number of covariates in the dataset that will be used in the algorithm
#' @return A list of parameters for controlling FFMS behavior:
#'
#' @section Feature Generation Parameters (\code{feat}):
#' \describe{
#'   \item{\code{feat$D}}{Maximum feature depth, default \code{5}. Limits the number of recursive feature transformations. For fractional polynomials, it is recommended to set \code{D = 1}.}
#'   \item{\code{feat$L}}{Maximum number of features per model, default \code{15}. Increase for complex models.}
#'   \item{\code{feat$alpha}}{Strategy for generating $alpha$ parameters in non-linear projections:
#'     \describe{
#'       \item{\code{"unit"}}{(Default) Sets all components to 1.}
#'       \item{\code{"deep"}}{Optimizes $alpha$ across all feature layers.}
#'       \item{\code{"random"}}{Samples $alpha$ from the prior for a fully Bayesian approach.}
#'     }}
#'   \item{\code{feat$pop.max}}{Maximum feature population size per iteration. Defaults to \code{min(100, as.integer(1.5 * p))}, where \code{p} is the number of covariates.}
#'   \item{\code{feat$keep.org}}{Logical flag; if \code{TRUE}, original covariates remain in every population (default \code{FALSE}).}
#'   \item{\code{feat$prel.filter}}{Threshold for pre-filtering covariates before the first population generation. Default \code{0} disables filtering.}
#'   \item{\code{feat$prel.select}}{Indices of covariates to include initially. Default \code{NULL} includes all.}
#'   \item{\code{feat$keep.min}}{Minimum proportion of features to retain during population updates. Default \code{0.8}.}
#'   \item{\code{feat$eps}}{Threshold for feature inclusion probability during generation. Default \code{0.05}.}
#'   \item{\code{feat$check.col}}{Logical; if \code{TRUE} (default), checks for collinearity during feature generation.}
#'   \item{\code{feat$max.proj.size}}{Maximum number of existing features used to construct a new one. Default \code{15}.}
#' }
#'
#' @section Scaling Option:
#' \describe{
#'   \item{\code{rescale.large}}{Logical flag for rescaling large data values for numerical stability. Default \code{FALSE}.}
#' }
#'
#' @section FMS Parameters:
#' \describe{
#'   \item{\code{burn_in}}{The burn-in period for the FMS algorithm, which is set to 100 iterations by default.}
#'
#'   \item{\code{mh}}{A list containing parameters for the regular Metropolis-Hastings (MH) kernel:
#'     \describe{
#'       \item{\code{neigh.size}}{The size of the neighborhood for MH proposals with fixed proposal size, default set to 1.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size for random proposal size, default set to 1.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size for random proposal size, default set to 2.}
#'     }
#'   }
#'
#'   \item{\code{large}}{A list containing parameters for the large jump kernel:
#'     \describe{
#'       \item{\code{neigh.size}}{The size of the neighborhood for large jump proposals with fixed neighborhood size, default set to the smaller of \code{0.35 * p} and \code{35}, where \eqn{p} is the number of covariates.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size for large jumps with random size of the neighborhood, default set to the smaller of \code{0.25 * p} and \code{25}.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size for large jumps with random size of the neighborhood, default set to the smaller of \code{0.45 * p} and \code{45}.}
#'     }
#'   }
#'
#'   \item{\code{random}}{A list containing a parameter for the randomization kernel:
#'     \describe{
#'       \item{\code{prob}}{The small probability of changing the component around the mode, default set to 0.01.}
#'     }
#'   }
#'
#'   \item{\code{sa}}{A list containing parameters for the simulated annealing kernel:
#'     \describe{
#'       \item{\code{probs}}{A numeric vector of length 6 specifying the probabilities for different types of proposals in the simulated annealing algorithm.}
#'       \item{\code{neigh.size}}{The size of the neighborhood for the simulated annealing proposals, default set to 1.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size, default set to 1.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size, default set to 2.}
#'       \item{\code{t.init}}{The initial temperature for simulated annealing, default set to 10.}
#'       \item{\code{t.min}}{The minimum temperature for simulated annealing, default set to 0.0001.}
#'       \item{\code{dt}}{The temperature decrement factor, default set to 3.}
#'       \item{\code{M}}{The number of iterations in the simulated annealing process, default set to 12.}
#'     }
#'   }
#'
#'   \item{\code{greedy}}{A list containing parameters for the greedy algorithm:
#'     \describe{
#'       \item{\code{probs}}{A numeric vector of length 6 specifying the probabilities for different types of proposals in the greedy algorithm.}
#'       \item{\code{neigh.size}}{The size of the neighborhood for greedy algorithm proposals, set to 1.}
#'       \item{\code{neigh.min}}{The minimum neighborhood size for greedy proposals, set to 1.}
#'       \item{\code{neigh.max}}{The maximum neighborhood size for greedy proposals, set to 2.}
#'       \item{\code{steps}}{The number of steps for the greedy algorithm, set to 20.}
#'       \item{\code{tries}}{The number of tries for the greedy algorithm, set to 3.}
#'     }
#'   }
#'
#'   \item{\code{loglik}}{A list to store log-likelihood values, which is by default empty.}
#' }
#'
#' @examples
#' data <- data.frame(y = rnorm(100), x1 = rnorm(100), x2 = rnorm(100))
#' params <- gen.params.ffms_base(ncol(data) - 1)
#' str(params)
#'
#' @seealso \code{\link{gen.params.fms_base}}, \code{\link{ffms_base}}
#' 
#' @export gen.params.ffms_base
gen.params.ffms_base <- function (ncov) {
  # Get fms_base params
  params <- gen.params.fms_base(ncov)

  feat_params <- list(D = 5, L = 15,                                # Hard limits on feature complexity
                      alpha = "unit",                               # alpha strategy ("unit" = None, "deep" strategy 3 from Hubin et al., "random" fully Bayesian strategy) 
                      pop.max = min(100, as.integer(ncov * 1.5)),   # Max features population size
                      keep.org = FALSE,                             # Let original covariates leave the active population; F.0 remains available for generation
                      prel.filter = 0,                              # Filtration threshold for first population (i.e. filter covariates even if keep.org=TRUE)
                      keep.min = 0.8,                               # Minimum proportion of features to always keep [0,1]
                      eps = 0.1,                                    # Inclusion probability floor for feature generation (higher = more diversity)
                      check.col = TRUE,                             # Whether the colinearity should be checked
                      col.check.mock.data = FALSE,                  # Use mock data when checking for colinearity during feature generation
                      max.proj.size = 15)                           # Maximum projection size
  params$feat <- feat_params
  
  # SIC Optimization and SGD Parameters
  params$sic <- list(
      eps1 = 10.0,
      epsT = 1e-5,
      stepsT = 100,
      alpha = 0.01,
      decay = 0.99,
      subs = 0.5
  )
  
   # Large jump parameters
  large_params <- list(
    neigh.size = min(as.integer(params$feat$pop.max * 0.35), as.integer(ncov * 0.35), 35),
    neigh.min = min(as.integer(params$feat$pop.max * 0.35), as.integer(ncov * 0.25), 25),
    neigh.max = min(as.integer(params$feat$pop.max * 0.35), as.integer(ncov * 0.45), 45)
  )
  params$large <- large_params
  
  params$rescale.large <- FALSE
  params$prel.select <- NULL                                        # Specify which covariates to keep in the first population. See Issue #15.

  return(params)
}

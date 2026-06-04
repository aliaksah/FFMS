## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  message = TRUE,  # show package startup and other messages
  warning = FALSE, # suppress warnings
  echo    = TRUE,  # show code
  results = "markup"
)

## -----------------------------------------------------------------------------
library(FFMS)

## -----------------------------------------------------------------------------
# Load example dataset
data <- FFMS::exoplanet
df.train <- data[1:500, ]

# Define transforms
to3 <- function(x) x^3
p2  <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")

# Fast single-thread run (set small for the vignette)
result <- ffms(
  formula     = semimajoraxis ~ 1 + .,
  data        = df.train,
  method      = "ffms_base",
  transforms  = transforms,
  pop.max     = 10,
  P           = 5,
  N           = 100
)

# Summarize the top models found
summary(result)

## ----eval=FALSE---------------------------------------------------------------
# # Example of a fully tuned parallel run that reliably finds Kepler's Third Law
# result.parallel <- ffms(
#   formula     = semimajoraxis ~ 1 + .,
#   data        = df.train,
#   method      = "ffms.parallel",
#   transforms  = transforms,
#   runs        = 16,
#   pop.max     = 80,
#   prob_gen    = c(0.5, 0.3, 0.1, 0.1), # favour multiplication for chaining
#   prob_filter = 0.3,
#   penalty_a   = 2.0,                   # heavy penalty for complexity
#   P           = 100,
#   N           = 500,
#   cores       = parallel::detectCores() - 1
# )
# 
# summary(result.parallel)


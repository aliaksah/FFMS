library(FFMS)
data("exoplanet")
train.indx <- 1:500
df.train = exoplanet[train.indx, ]
df.test  = exoplanet[-train.indx, ]

to3 <- function(x) x^3
p2 <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")

cat("=== Example 1.1: Default ===\n")
set.seed(123)
result.default <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = df.train,
  method = "ffms_base",
  transforms = transforms,
  pop.max = 20,
  P = 20,
  N = 500
)
summary(result.default)

cat("\n=== Example 1.3: Longer single-thread ===\n")
set.seed(123)
result.P50 <- ffms(
  data = df.train,
  method = "ffms_base",
  transforms = transforms,
  pop.max = 30,
  prob_gen = c(0.5, 0.3, 0.1, 0.1),
  prob_filter = 0.3,
  P = 25, N = 500, N.final = 1000
)
summary(result.P50)

cat("\n=== Example 1.4: Parallel FFMS ===\n")
set.seed(42)
result.parallel <- ffms(
  data = df.train,
  method = "ffms.parallel",
  transforms = transforms,
  runs = 16,
  pop.max = 80,
  prob_gen = c(0.5, 0.3, 0.1, 0.1),
  prob_filter = 0.3,
  P = 50,
  N = 500,
  cores = parallel::detectCores() - 1
)
summary(result.parallel)

cat("\n=== Reference: True Kepler BIC ===\n")
kepler_pred <- (df.train$period^2 * df.train$hoststar_mass)^(1/3)
cat("True Kepler BIC:", BIC(lm(semimajoraxis ~ kepler_pred, data=df.train)), "\n")

library(FFMS)
data("exoplanet")
train.indx <- 1:500
df.train = exoplanet[train.indx, ]

to3 <- function(x) x^3
p2 <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")

set.seed(42)
result.parallel <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = df.train,
  method = "ffms.parallel",
  transforms = transforms,
  pop.max = 80,
  prob_gen = c(0.5, 0.3, 0.1, 0.1),   # favour multiplication more
  prob_filter = 0.3,                    # looser filter = keep more features for chaining
  P = 50,
  N = 500,
  runs = 16,
  cores = 16
)

summary(result.parallel)

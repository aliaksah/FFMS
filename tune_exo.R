library(FFMS)
data("exoplanet")
train.indx <- 1:500
df.train = exoplanet[train.indx, ]

to3 <- function(x) x^3
p2 <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")

set.seed(42)
result.parallel <- ffms(
  semimajoraxis ~ 1 + .,
  data = df.train,
  method = "ffms.parallel",
  transforms = transforms,
  pop.max = 20,
  prob_gen = c(0.4, 0.4, 0.1, 0.1),
  prob_filter = 0.5,
  P = 20,
  N = 1000,
  runs = 10,
  cores = 10
)

summary(result.parallel)

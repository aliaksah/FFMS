library(FFMS)
data("exoplanet")
to3 <- function(x) x^3
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "troot", "to3")

set.seed(1234)
result <- ffms(
  semimajoraxis ~ 1 + .,
  family = "gaussian",
  method = "ffms_base",
  data = exoplanet,
  transforms = transforms,
  P = 20,
  N = 500
)

print(summary(result))

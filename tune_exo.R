library(FFMS)
data("exoplanet")
train.indx <- 1:500
df.train = exoplanet[train.indx, ]

to3 <- function(x) x^3
p2 <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")

# More populations + more iterations to complete the 3-step chain:
# period -> p2(period) -> (p2(period)*hoststar_mass) -> troot(p2(period)*hoststar_mass)
set.seed(42)
result.parallel <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = df.train,
  method = "ffms.parallel",
  transforms = transforms,
  pop.max = 80,
  prob_gen = c(0.5, 0.3, 0.1, 0.1),
  prob_filter = 0.3,
  P = 80,          # double populations
  N = 500,
  runs = 16,
  cores = 16
)

summary(result.parallel)
cat("\nTrue Kepler BIC:", BIC(lm(semimajoraxis ~ I((period^2 * hoststar_mass)^(1/3)), data=df.train)), "\n")

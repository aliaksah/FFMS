library(FFMS)
data(exoplanet)
df.train <- exoplanet[1:500,]
transforms <- c("sin", "cos", "exp", "log", "sqrt")

result <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = df.train,
  method = "gmjmcmc",
  transforms = transforms,
  N = 100 # small number of iterations to test
)
print(summary(result))

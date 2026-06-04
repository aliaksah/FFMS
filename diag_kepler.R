library(FFMS)
data("exoplanet")
train.indx <- 1:500
df.train = exoplanet[train.indx, ]

# Check: what does the true law give vs. actual data?
semimajoraxis <- df.train$semimajoraxis
period <- df.train$period
hoststar_mass <- df.train$hoststar_mass

# True Kepler: a = (T^2 * M)^(1/3) in AU
kepler_pred <- (period^2 * hoststar_mass)^(1/3)

cat("Correlation of true Kepler prediction vs observed semimajoraxis:\n")
cat(cor(kepler_pred, semimajoraxis, use="complete.obs"), "\n\n")

# A linear model with just this feature
m_kepler <- lm(semimajoraxis ~ kepler_pred)
cat("R^2 from true Kepler feature:\n")
cat(summary(m_kepler)$r.squared, "\n\n")
cat("AIC of true Kepler model:\n")
cat(AIC(m_kepler), "\n\n")
cat("BIC of true Kepler model:\n")
cat(BIC(m_kepler), "\n\n")

# Now try with troot(period^2 * hoststar_mass) separately
kepler2 <- df.train$period^2 * df.train$hoststar_mass
m_alt <- lm(semimajoraxis ~ I(kepler2^(1/3)))
cat("R^2 from (period^2 * hoststar_mass)^(1/3):\n")
cat(summary(m_alt)$r.squared, "\n\n")

# Now try naive raw features
m_null <- lm(semimajoraxis ~ ., data = df.train)
cat("R^2 from all raw features:\n")
cat(summary(m_null)$r.squared, "\n\n")
cat("BIC of full raw model:\n")
cat(BIC(m_null), "\n\n")

# Can FFMS even CREATE troot(period^2 * hoststar_mass)?
# It would be: troot( p2(period) * hoststar_mass )
# feature tree: troot( multiplication( modification(period, p2), hoststar_mass) )
# depth = 3 > D=5 OK
# oc = 1(troot) + 1(mult) + 1(p2) = 3 OK

p2_period <- df.train$period^2
troot_kepler <- (p2_period * df.train$hoststar_mass)^(1/3)
m_gram <- lm(semimajoraxis ~ troot_kepler)
cat("\nBIC using troot(p2(period)*hoststar_mass):", BIC(m_gram), "\n")
cat("R^2:", summary(m_gram)$r.squared, "\n")

# Compare: BIC penalty for oc=3 feature with n=500
n <- 500
cat("\nlogn penalty for oc=3 feature with n=500:", 3 * log(n), "\n")
cat("logn penalty for standard linear term (oc=1):", 1 * log(n), "\n")
cat("\nDifference in BIC from raw to Kepler:", 1515.258 - (-2749.461), "\n")
cat("This gain of", 1515.258 + 2749.461, "far exceeds the oc=3 penalty of", 3*log(500), "\n")

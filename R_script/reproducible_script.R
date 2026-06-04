###############################################################
# FBMS Reproducibility Script (SoftwareX Submission)
# -------------------------------------------------------------
# This script reproduces examples in:
#
#   FFMS: Frequentist Flexible Model Selection
#
# It installs the correct package versions and runs the two
# main examples used in the article.
#
# The script uses minimal, readable checks suitable for SoftwareX:
#  - Mandatory packages are installed if missing
#  - Optional packages are installed if possible; otherwise skipped
#  - FFMS is always installed from a dedicated GitHub branch "softwareX"
###############################################################



###############################################################
# 0. Helper: Install a mandatory package (stop if fails)
###############################################################

install_mandatory <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing mandatory package: ", pkg)
    tryCatch(
      install.packages(pkg),
      error = function(e) {
        stop("Failed to install mandatory package ", pkg, call. = FALSE)
      }
    )
  }
}

###############################################################
# 1. Install mandatory packages
###############################################################

mandatory_pkgs <- c("devtools", "parallel", "tictoc", "lme4","cAIC4")

for (p in mandatory_pkgs) install_mandatory(p)

library(devtools)


###############################################################
# 2. Install FFMS (always from GitHub to enforce correct version)
###############################################################

# message("Installing FFMS from GitHub (branch softwareX)...")
# install_github("jonlachmann/FFMS@jsoftwareX",
#                force = TRUE, build_vignettes = FALSE)

library(FFMS)
library(tictoc)

################################################################
################################################################
#
#  EXAMPLE 1: EXOPLANET DATA
#
#  Section 3 of the article
#
################################################################
################################################################

library(FFMS)
data(exoplanet)

train.indx <- 1:500
df.train = exoplanet[train.indx, ]
df.test  = exoplanet[-train.indx, ]

to3 <- function(x) x^3
p2 <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")


###############################################################
# Example 1.1 — Default single-thread FFMS (Section 3)
###############################################################
set.seed(123)

result.default <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = df.train,
  method = "ffms_base",
  transforms = transforms
)


###############################################################
# Example 1.2 — High Penalty 
###############################################################

set.seed(234)
result.high.penalty <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = df.train,
  method = "ffms_base",
  transforms = transforms,
  penalty_a = 1.5
)


###############################################################
# Example 1.3 — Longer single-thread run
###############################################################
set.seed(123)

result.P50 <- ffms(
  data = df.train,
  method = "ffms_base",
  transforms = transforms,
  pop.max = 20,
  prob_gen = c(0.4, 0.4, 0.1, 0.1),
  prob_filter = 0.5,
  P = 25, N = 1000, N.final = 5000
)


###############################################################
# Example 1.4 — Parallel FFMS 
###############################################################
set.seed(123)

result.parallel <- ffms(
  data = df.train,
  method = "ffms.parallel",
  transforms = transforms,
  runs = 16,
  pop.max = 80,
  prob_gen = c(0.4, 0.4, 0.1, 0.1),
  P = 50,
  cores = parallel::detectCores() - 1
)


###############################################################
# Example 1.5 — Summaries and plotting
###############################################################

summary(result.default)
summary(result.default, pop = "all", labels = paste0("x",1:length(df.train[,-1])))


summary(result.P50)
summary(result.P50, pop = "best", labels = paste0("x",1:length(df.train[,-1])))
summary(result.P50, pop = "last", labels = paste0("x",1:length(df.train[,-1])))
summary(result.P50, pop = "last", tol = 0.01, labels = paste0("x",1:length(df.train[,-1])))
summary(result.P50, pop = "all")

summary(result.parallel)
library(tictoc)
tic()
summary(result.parallel, tol = 0.01, pop = "all",data = df.train)
toc()



plot(result.default)
plot(result.P50)
plot(result.parallel)



###############################################################
# Example 1.6 — Prediction
###############################################################
preds <-  predict(result.default, df.test[,-1])
str(aggr(preds))

rmse.default <- sqrt(mean((predmean(preds) - df.test$semimajoraxis)^2))
plot(predmean(preds), df.test$semimajoraxis)


###############################

preds.P50 <- predict(result.P50, df.test[,-1])  
rmse.P50 <-  sqrt(mean((predmean(preds.P50) - df.test$semimajoraxis)^2))
plot(predmean(preds.P50), df.test$semimajoraxis)


###############################


preds.multi <- predict(result.parallel , df.test[,-1], link = function(x) x)
rmse.parallel <- sqrt(mean((predmean(preds.multi) - df.test$semimajoraxis)^2))
plot(predmean(preds.multi), df.test$semimajoraxis)


round(c(rmse.default, rmse.P50, rmse.parallel),2)


###############################################################
# Example 1.7 — Best model & MPM
###############################################################

best.default <- get.best.model(result.default)
mpm.default  <- get.mpm.model(result.default,
                              y = df.train$semimajoraxis,
                              x = df.train[,-1])

sqrt(mean((predict(best.default, df.test[,-1]) -
             df.test$semimajoraxis)^2))

sqrt(mean((predict(mpm.default, df.test[,-1]) -
             df.test$semimajoraxis)^2))

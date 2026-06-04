pkgname <- "FFMS"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('FFMS')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("abalone")
### * abalone

flush(stderr()); flush(stdout())

### Name: abalone
### Title: Physical Measurements of 4177 Abalones, a Species of Sea Snail.
### Aliases: abalone
### Keywords: datasets

### ** Examples


data(abalone)
## maybe str(abalone) ; plot(abalone) ...




cleanEx()
nameEx("aggr.ffms_predict")
### * aggr.ffms_predict

flush(stderr()); flush(stdout())

### Name: aggr.ffms_predict
### Title: Access Aggregated Predictions
### Aliases: aggr.ffms_predict

### ** Examples




cleanEx()
nameEx("arcsinh")
### * arcsinh

flush(stderr()); flush(stdout())

### Name: arcsinh
### Title: Arcsinh Transform
### Aliases: arcsinh

### ** Examples

arcsinh(2)




cleanEx()
nameEx("coef.bgnlm_model")
### * coef.bgnlm_model

flush(stderr()); flush(stdout())

### Name: coef.bgnlm_model
### Title: Coefficients for BGNLM Model
### Aliases: coef.bgnlm_model

### ** Examples

data(exoplanet)
model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, family = "gaussian"))
coef(model)



cleanEx()
nameEx("coef.ffms_base")
### * coef.ffms_base

flush(stderr()); flush(stdout())

### Name: coef.ffms_base
### Title: Coefficients for FFMS Model
### Aliases: coef.ffms_base

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "ffms_base", transforms = c("sigmoid"))
coef(model)



cleanEx()
nameEx("coef.ffms_merged")
### * coef.ffms_merged

flush(stderr()); flush(stdout())

### Name: coef.ffms_merged
### Title: Coefficients for FFMS Merged Model
### Aliases: coef.ffms_merged

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, 
method = "ffms.parallel", transforms = c("sigmoid"), 
runs = 2, cores = 1)
coef(model)



cleanEx()
nameEx("coef.fms_base")
### * coef.fms_base

flush(stderr()); flush(stdout())

### Name: coef.fms_base
### Title: Coefficients for FMS Model
### Aliases: coef.fms_base

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
coef(model)



cleanEx()
nameEx("coef.fms_parallel")
### * coef.fms_parallel

flush(stderr()); flush(stdout())

### Name: coef.fms_parallel
### Title: Coefficients for FMS Parallel Model
### Aliases: coef.fms_parallel

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms.parallel", cores = 1, runs = 2)
coef(model)



cleanEx()
nameEx("compute_effects")
### * compute_effects

flush(stderr()); flush(stdout())

### Name: compute_effects
### Title: Compute Effects for Specified Covariates Using a Fitted Model
### Aliases: compute_effects

### ** Examples


data <- data.frame(matrix(rnorm(600), 100))
result <- fms.parallel(runs = 2, 
cores = 1, 
y = matrix(rnorm(100), 100),
x = data, 
loglik.pi = gaussian.loglik)
compute_effects(result,labels = names(data))




cleanEx()
nameEx("cos_deg")
### * cos_deg

flush(stderr()); flush(stdout())

### Name: cos_deg
### Title: Cosine Function for Degrees
### Aliases: cos_deg

### ** Examples

cos_deg(0)




cleanEx()
nameEx("diagn_plot")
### * diagn_plot

flush(stderr()); flush(stdout())

### Name: diagn_plot
### Title: Plot Convergence Diagnostics for FFMS or FFMS Merged Results
### Aliases: diagn_plot

### ** Examples

data(exoplanet)
result <- ffms(semimajoraxis ~ ., data = exoplanet, method = "ffms_base", transforms = c("sin"))
diagn_plot(result, FUN = median, conf = 0.95, main = "Convergence Plot")




cleanEx()
nameEx("erf")
### * erf

flush(stderr()); flush(stdout())

### Name: erf
### Title: Erf Function
### Aliases: erf

### ** Examples

erf(2)




cleanEx()
nameEx("exp_dbl")
### * exp_dbl

flush(stderr()); flush(stdout())

### Name: exp_dbl
### Title: Double Exponential Function
### Aliases: exp_dbl

### ** Examples

exp_dbl(2)




cleanEx()
nameEx("ffms")
### * ffms

flush(stderr()); flush(stdout())

### Name: ffms
### Title: Fit a BGNLM Model Using FMS or FFMS Sampling.
### Aliases: ffms

### ** Examples

# Fit a Gaussian multivariate time series model
ffms_result <- ffms(
 X1 ~ .,
 family = "gaussian",
 method = "ffms.parallel",
 data = data.frame(matrix(rnorm(600), 100)),
 transforms = c("sin","cos"),
 P = 10,
 runs = 1,
 cores = 1
)
summary(ffms_result)





cleanEx()
nameEx("ffms.mlik.master")
### * ffms.mlik.master

flush(stderr()); flush(stdout())

### Name: ffms.mlik.master
### Title: Master Log Marginal Likelihood Function
### Aliases: ffms.mlik.master

### ** Examples

ffms.mlik.master(y = rnorm(100), 
x = matrix(rnorm(100)), 
c(TRUE,TRUE), 
list(oc = 1),
mlpost_params = list(family = "gaussian", beta_prior = list(type = "g-prior", a = 2),
         r = exp(-0.5)))




cleanEx()
nameEx("ffms.parallel")
### * ffms.parallel

flush(stderr()); flush(stdout())

### Name: ffms.parallel
### Title: Run Multiple FFMS (Genetically Modified FMS) Runs in Parallel.
### Aliases: ffms.parallel

### ** Examples

result <- ffms.parallel(
  runs = 1,
  cores = 1,
  loglik.pi = NULL,
  y = matrix(rnorm(100), 100),
  x = matrix(rnorm(600), 100),
  transforms = c("p0", "exp_dbl")
)

summary(result)

plot(result)




cleanEx()
nameEx("ffms_base")
### * ffms_base

flush(stderr()); flush(stdout())

### Name: ffms_base
### Title: Main Algorithm for FFMS (Genetically Modified FMS)
### Aliases: ffms_base

### ** Examples

result <- ffms_base(y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100), 
P = 2, 
transform = c("p0", "exp_dbl"))
summary(result)
plot(result)




cleanEx()
nameEx("fitted.ffms_predict")
### * fitted.ffms_predict

flush(stderr()); flush(stdout())

### Name: fitted.ffms_predict
### Title: Access Fitted Values
### Aliases: fitted.ffms_predict

### ** Examples




cleanEx()
nameEx("fms.parallel")
### * fms.parallel

flush(stderr()); flush(stdout())

### Name: fms.parallel
### Title: Run Multiple FMS Runs in Parallel, Merging the Results Before
###   Returning.
### Aliases: fms.parallel

### ** Examples

result <- fms.parallel(runs = 1, 
cores = 1, 
loglik.pi = FFMS::gaussian.loglik,
y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100))
summary(result)
plot(result)




cleanEx()
nameEx("fms_base")
### * fms_base

flush(stderr()); flush(stdout())

### Name: fms_base
### Title: Main Algorithm for FMS (Genetically Modified FMS)
### Aliases: fms_base

### ** Examples

result <- fms_base(
y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100),
loglik.pi = gaussian.loglik)
summary(result)
plot(result)




cleanEx()
nameEx("gaussian.loglik")
### * gaussian.loglik

flush(stderr()); flush(stdout())

### Name: gaussian.loglik
### Title: Log Likelihood Function for Gaussian Regression with a Jeffreys
###   Prior and BIC Approximation
### Aliases: gaussian.loglik

### ** Examples

gaussian.loglik(rnorm(100), matrix(rnorm(100)), TRUE, list(oc = 1), NULL)





cleanEx()
nameEx("gelu")
### * gelu

flush(stderr()); flush(stdout())

### Name: gelu
### Title: GELU Function
### Aliases: gelu

### ** Examples

gelu(2)




cleanEx()
nameEx("gen.params.ffms_base")
### * gen.params.ffms_base

flush(stderr()); flush(stdout())

### Name: gen.params.ffms_base
### Title: Generate a Parameter List for FFMS (Genetically Modified FMS)
### Aliases: gen.params.ffms_base

### ** Examples

data <- data.frame(y = rnorm(100), x1 = rnorm(100), x2 = rnorm(100))
params <- gen.params.ffms_base(ncol(data) - 1)
str(params)




cleanEx()
nameEx("gen.params.fms_base")
### * gen.params.fms_base

flush(stderr()); flush(stdout())

### Name: gen.params.fms_base
### Title: Generate a Parameter List for FMS (Mode Jumping MCMC)
### Aliases: gen.params.fms_base

### ** Examples

gen.params.fms_base(matrix(rnorm(600), 100))





cleanEx()
nameEx("gen.probs.ffms_base")
### * gen.probs.ffms_base

flush(stderr()); flush(stdout())

### Name: gen.probs.ffms_base
### Title: Generate a Probability List for FFMS (Genetically Modified FMS)
### Aliases: gen.probs.ffms_base

### ** Examples

gen.probs.ffms_base(c("p0", "exp_dbl"))





cleanEx()
nameEx("gen.probs.fms_base")
### * gen.probs.fms_base

flush(stderr()); flush(stdout())

### Name: gen.probs.fms_base
### Title: Generate a Probability List for FMS (Mode Jumping MCMC)
### Aliases: gen.probs.fms_base

### ** Examples

gen.probs.fms_base()




cleanEx()
nameEx("get.best.model")
### * get.best.model

flush(stderr()); flush(stdout())

### Name: get.best.model
### Title: Extract the Best Model from MJMCMC or GMJMCMC Results
### Aliases: get.best.model

### ** Examples

data(exoplanet)
result <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
get.best.model(result)




cleanEx()
nameEx("get.mpm.model")
### * get.mpm.model

flush(stderr()); flush(stdout())

### Name: get.mpm.model
### Title: Retrieve the Median Probability Model (MPM)
### Aliases: get.mpm.model

### ** Examples

## Not run: 
##D # Simulate data
##D set.seed(42)
##D x <- data.frame(
##D   PlanetaryMassJpt = rnorm(100),
##D   RadiusJpt = rnorm(100),
##D   PeriodDays = rnorm(100)
##D )
##D y <- 1 + 0.5 * x$PlanetaryMassJpt - 0.3 * x$RadiusJpt + rnorm(100)
##D 
##D # Assume 'result' is a fitted object from ffms_base or fms_base
##D result <- fms_base(cbind(y,x))  
##D 
##D # Get the MPM
##D mpm_model <- get.mpm.model(result, y, x, family = "gaussian")
##D 
##D # Access coefficients
##D mpm_model$coefs
## End(Not run)




cleanEx()
nameEx("hs")
### * hs

flush(stderr()); flush(stdout())

### Name: hs
### Title: Heavy Side Function
### Aliases: hs

### ** Examples

hs(2)




cleanEx()
nameEx("impute_x")
### * impute_x

flush(stderr()); flush(stdout())

### Name: impute_x
### Title: Impute Missing Values in the Data
### Aliases: impute_x

### ** Examples




cleanEx()
nameEx("impute_x_pred")
### * impute_x_pred

flush(stderr()); flush(stdout())

### Name: impute_x_pred
### Title: Impute Missing Values in Test Data Using Training Data
### Aliases: impute_x_pred

### ** Examples




cleanEx()
nameEx("log_prior")
### * log_prior

flush(stderr()); flush(stdout())

### Name: log_prior
### Title: Log Model Prior Function
### Aliases: log_prior

### ** Examples

log_prior(mlpost_params = list(r=2), complex = list(oc = 2))




cleanEx()
nameEx("logistic.loglik")
### * logistic.loglik

flush(stderr()); flush(stdout())

### Name: logistic.loglik
### Title: Log Likelihood Function for Logistic Regression with a Jeffreys
###   Parameter Prior and BIC Approximations of the Posterior.
### Aliases: logistic.loglik

### ** Examples

logistic.loglik(as.integer(rnorm(100) > 0), matrix(rnorm(100)), TRUE, list(oc = 1))





cleanEx()
nameEx("marginal.probs")
### * marginal.probs

flush(stderr()); flush(stdout())

### Name: marginal.probs
### Title: Function for Calculating Marginal Inclusion Probabilities of
###   Features Given a List of Models
### Aliases: marginal.probs

### ** Examples

result <- ffms_base(x = matrix(rnorm(600), 100),
y = matrix(rnorm(100), 100), 
P = 2, 
transforms = c("p0", "exp_dbl"))
marginal.probs(result$models[[1]])




cleanEx()
nameEx("merge_results")
### * merge_results

flush(stderr()); flush(stdout())

### Name: merge_results
### Title: Merge a List of Multiple Results from Many Runs
### Aliases: merge_results

### ** Examples

result <-  ffms(semimajoraxis ~ ., data = exoplanet,
 method = "ffms.parallel", transforms = c("sigmoid"), 
 runs = 2, cores = 1)

summary(result)

plot(result)

merge_results(result$results.raw)




cleanEx()
nameEx("model.string")
### * model.string

flush(stderr()); flush(stdout())

### Name: model.string
### Title: Function to Generate a Function String for a Model Consisting of
###   Features
### Aliases: model.string

### ** Examples

result <- ffms_base(y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100), 
P = 2, transforms =  c("p0", "exp_dbl"))
summary(result)
plot(result)
model.string(c(TRUE, FALSE, TRUE, FALSE, TRUE), result$populations[[1]])
model.string(result$models[[1]][1][[1]]$model, result$populations[[1]])




cleanEx()
nameEx("ngelu")
### * ngelu

flush(stderr()); flush(stdout())

### Name: ngelu
### Title: Negative GELU Function
### Aliases: ngelu

### ** Examples

ngelu(2)




cleanEx()
nameEx("nhs")
### * nhs

flush(stderr()); flush(stdout())

### Name: nhs
### Title: Negative Heavy Side Function
### Aliases: nhs

### ** Examples

nhs(2)




cleanEx()
nameEx("not")
### * not

flush(stderr()); flush(stdout())

### Name: not
### Title: Not x
### Aliases: not

### ** Examples

not(TRUE)




cleanEx()
nameEx("nrelu")
### * nrelu

flush(stderr()); flush(stdout())

### Name: nrelu
### Title: Negative ReLU Function
### Aliases: nrelu

### ** Examples

nrelu(2)




cleanEx()
nameEx("p0")
### * p0

flush(stderr()); flush(stdout())

### Name: p0
### Title: p0 Polynomial Term
### Aliases: p0

### ** Examples

p0(2)




cleanEx()
nameEx("p05")
### * p05

flush(stderr()); flush(stdout())

### Name: p05
### Title: p05 Polynomial Term
### Aliases: p05

### ** Examples

p05(2)




cleanEx()
nameEx("p0p0")
### * p0p0

flush(stderr()); flush(stdout())

### Name: p0p0
### Title: p0p0 Polynomial Term
### Aliases: p0p0

### ** Examples

p0p0(2)




cleanEx()
nameEx("p0p05")
### * p0p05

flush(stderr()); flush(stdout())

### Name: p0p05
### Title: p0p05 Polynomial Term
### Aliases: p0p05

### ** Examples

p0p05(2)




cleanEx()
nameEx("p0p1")
### * p0p1

flush(stderr()); flush(stdout())

### Name: p0p1
### Title: p0p1 Polynomial Term
### Aliases: p0p1

### ** Examples

p0p1(2)




cleanEx()
nameEx("p0p2")
### * p0p2

flush(stderr()); flush(stdout())

### Name: p0p2
### Title: p0p2 Polynomial Term
### Aliases: p0p2

### ** Examples

p0p2(2)




cleanEx()
nameEx("p0p3")
### * p0p3

flush(stderr()); flush(stdout())

### Name: p0p3
### Title: p0p3 Polynomial Term
### Aliases: p0p3

### ** Examples

p0p3(2)




cleanEx()
nameEx("p0pm05")
### * p0pm05

flush(stderr()); flush(stdout())

### Name: p0pm05
### Title: p0pm05 Polynomial Term
### Aliases: p0pm05

### ** Examples

p0pm05(2)




cleanEx()
nameEx("p0pm1")
### * p0pm1

flush(stderr()); flush(stdout())

### Name: p0pm1
### Title: p0pm1 Polynomial Terms
### Aliases: p0pm1

### ** Examples

p0pm1(2)




cleanEx()
nameEx("p0pm2")
### * p0pm2

flush(stderr()); flush(stdout())

### Name: p0pm2
### Title: p0pm2 Polynomial Term
### Aliases: p0pm2

### ** Examples

p0pm2(2)




cleanEx()
nameEx("p2")
### * p2

flush(stderr()); flush(stdout())

### Name: p2
### Title: p2 Polynomial Term
### Aliases: p2

### ** Examples

p2(2)




cleanEx()
nameEx("p3")
### * p3

flush(stderr()); flush(stdout())

### Name: p3
### Title: p3 Polynomial Term
### Aliases: p3

### ** Examples

p3(2)




cleanEx()
nameEx("plot.bgnlm_model")
### * plot.bgnlm_model

flush(stderr()); flush(stdout())

### Name: plot.bgnlm_model
### Title: Plot BGNLM Model
### Aliases: plot.bgnlm_model

### ** Examples

data(exoplanet)
model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, family = "gaussian"))
plot(model)



cleanEx()
nameEx("plot.ffms_base")
### * plot.ffms_base

flush(stderr()); flush(stdout())

### Name: plot.ffms_base
### Title: Function to Plot GMJMCMC Results and Merged Results from
###   merge.results
### Aliases: plot.ffms_base

### ** Examples

result <- ffms_base(y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100), 
P = 2, 
transforms = c("p0", "exp_dbl"))
plot(result)





cleanEx()
nameEx("plot.ffms_merged")
### * plot.ffms_merged

flush(stderr()); flush(stdout())

### Name: plot.ffms_merged
### Title: Plot a ffms_merged Run
### Aliases: plot.ffms_merged

### ** Examples

result <- ffms.parallel(
 runs = 1,
 cores = 1,
 y = matrix(rnorm(100), 100),
 x = matrix(rnorm(600), 100),
 P = 2,
 transforms = c("p0", "exp_dbl")
)
plot(result)




cleanEx()
nameEx("plot.ffms_predict")
### * plot.ffms_predict

flush(stderr()); flush(stdout())

### Name: plot.ffms_predict
### Title: Plot FFMS Prediction Object
### Aliases: plot.ffms_predict

### ** Examples




cleanEx()
nameEx("plot.fms_base")
### * plot.fms_base

flush(stderr()); flush(stdout())

### Name: plot.fms_base
### Title: Function to Plot GMJMCMC Results and Merged Results from
###   merge.results
### Aliases: plot.fms_base

### ** Examples

result <- fms_base(
y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100),
loglik.pi = gaussian.loglik)
plot(result)




cleanEx()
nameEx("plot.fms_parallel")
### * plot.fms_parallel

flush(stderr()); flush(stdout())

### Name: plot.fms_parallel
### Title: Plot an fms.parallel Run
### Aliases: plot.fms_parallel

### ** Examples

result <- fms.parallel(runs = 1, 
cores = 1, 
y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100), 
loglik.pi = gaussian.loglik)
plot(result)




cleanEx()
nameEx("pm05")
### * pm05

flush(stderr()); flush(stdout())

### Name: pm05
### Title: pm05 Polynomial Term
### Aliases: pm05

### ** Examples

pm05(2)




cleanEx()
nameEx("pm1")
### * pm1

flush(stderr()); flush(stdout())

### Name: pm1
### Title: pm1 Polynomial Term
### Aliases: pm1

### ** Examples

pm1(2)




cleanEx()
nameEx("pm2")
### * pm2

flush(stderr()); flush(stdout())

### Name: pm2
### Title: pm2 Polynomial Term
### Aliases: pm2

### ** Examples

pm2(2)




cleanEx()
nameEx("predict.bgnlm_model")
### * predict.bgnlm_model

flush(stderr()); flush(stdout())

### Name: predict.bgnlm_model
### Title: Predict Responses from a BGNLM Model
### Aliases: predict.bgnlm_model

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet)
preds <- predict(get.best.model(model), exoplanet[,-1])



cleanEx()
nameEx("predict.ffms_base")
### * predict.ffms_base

flush(stderr()); flush(stdout())

### Name: predict.ffms_base
### Title: Predict Using a FFMS Result Object
### Aliases: predict.ffms_base

### ** Examples

result <- ffms_base(
 x = matrix(rnorm(600), 100),
 y = matrix(rnorm(100), 100),
 P = 2,
 transforms = c("p0", "exp_dbl")
)
preds <- predict(result, matrix(rnorm(600), 100))





cleanEx()
nameEx("predict.ffms_merged")
### * predict.ffms_merged

flush(stderr()); flush(stdout())

### Name: predict.ffms_merged
### Title: Predict Using a Merged FFMS Result Object
### Aliases: predict.ffms_merged

### ** Examples

result <- ffms.parallel(
 runs = 1,
 cores = 1,
 x = matrix(rnorm(600), 100),
 y = matrix(rnorm(100), 100),
 P = 2,
 transforms = c("p0", "exp_dbl")
)
preds <- predict(result, matrix(rnorm(600), 100))




cleanEx()
nameEx("predict.ffms_parallel")
### * predict.ffms_parallel

flush(stderr()); flush(stdout())

### Name: predict.ffms_parallel
### Title: Predict Using a FFMS Result Object from a Parallel Run
### Aliases: predict.ffms_parallel

### ** Examples

result <- ffms.parallel(
 runs = 1,
 cores = 1,
 x = matrix(rnorm(600), 100),
 y = matrix(rnorm(100), 100),
 P = 2,
 transforms = c("p0", "exp_dbl")
)
preds <- predict(result, matrix(rnorm(600), 100))




cleanEx()
nameEx("predict.fms_base")
### * predict.fms_base

flush(stderr()); flush(stdout())

### Name: predict.fms_base
### Title: Predict Using an FMS Result Object
### Aliases: predict.fms_base

### ** Examples

result <- fms_base(
x = matrix(rnorm(600), 100),
y = matrix(rnorm(100), 100),
loglik.pi = gaussian.loglik)
preds <- predict(result, matrix(rnorm(600), 100))




cleanEx()
nameEx("predict.fms_parallel")
### * predict.fms_parallel

flush(stderr()); flush(stdout())

### Name: predict.fms_parallel
### Title: Predict Using an FMS Result Object from a Parallel Run
### Aliases: predict.fms_parallel

### ** Examples

result <- fms.parallel(runs = 1, 
cores = 1, 
x = matrix(rnorm(600), 100),
y = matrix(rnorm(100), 100), 
loglik.pi = gaussian.loglik)
preds <- predict(result, matrix(rnorm(600), 100))




cleanEx()
nameEx("predmean.ffms_predict")
### * predmean.ffms_predict

flush(stderr()); flush(stdout())

### Name: predmean.ffms_predict
### Title: Access Mean Predictions
### Aliases: predmean.ffms_predict

### ** Examples




cleanEx()
nameEx("predquantiles.ffms_predict")
### * predquantiles.ffms_predict

flush(stderr()); flush(stdout())

### Name: predquantiles.ffms_predict
### Title: Access Quantile Predictions
### Aliases: predquantiles.ffms_predict

### ** Examples




cleanEx()
nameEx("print.bgnlm_model")
### * print.bgnlm_model

flush(stderr()); flush(stdout())

### Name: print.bgnlm_model
### Title: Print BGNLM Model Object
### Aliases: print.bgnlm_model

### ** Examples

data(exoplanet)
model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, 
family = "gaussian"))
print(model)
model <- get.mpm.model(ffms(semimajoraxis ~ ., data = exoplanet, 
family = "gaussian"), y = exoplanet[,1],x = exoplanet[,-1])
print(model)



cleanEx()
nameEx("print.feature")
### * print.feature

flush(stderr()); flush(stdout())

### Name: print.feature
### Title: Print Method for \"feature\" Class
### Aliases: print.feature

### ** Examples

result <- ffms_base(x = matrix(rnorm(600), 100),
y = matrix(rnorm(100), 100), 
P = 2, 
transforms = c("p0", "exp_dbl"))
print(result$populations[[1]][1])




cleanEx()
nameEx("print.ffms_base")
### * print.ffms_base

flush(stderr()); flush(stdout())

### Name: print.ffms_base
### Title: Print FFMS Model Object
### Aliases: print.ffms_base

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet,method = "ffms_base", transforms = c("sigmoid"))
print(model)



cleanEx()
nameEx("print.ffms_merged")
### * print.ffms_merged

flush(stderr()); flush(stdout())

### Name: print.ffms_merged
### Title: Print FFMS Merged Model Object
### Aliases: print.ffms_merged

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, 
method = "ffms.parallel", cores = 1, runs = 2, 
transforms = c("sigmoid"))

print(model)



cleanEx()
nameEx("print.ffms_predict")
### * print.ffms_predict

flush(stderr()); flush(stdout())

### Name: print.ffms_predict
### Title: Print FFMS Prediction Object
### Aliases: print.ffms_predict

### ** Examples




cleanEx()
nameEx("print.fms_base")
### * print.fms_base

flush(stderr()); flush(stdout())

### Name: print.fms_base
### Title: Print FMS Model Object
### Aliases: print.fms_base

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
print(model)



cleanEx()
nameEx("print.fms_parallel")
### * print.fms_parallel

flush(stderr()); flush(stdout())

### Name: print.fms_parallel
### Title: Print FMS Parallel Model Object
### Aliases: print.fms_parallel

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms.parallel", cores = 1, runs = 2)
print(model)



cleanEx()
nameEx("relu")
### * relu

flush(stderr()); flush(stdout())

### Name: relu
### Title: ReLU Function
### Aliases: relu

### ** Examples

relu(2)




cleanEx()
nameEx("residuals.bgnlm_model")
### * residuals.bgnlm_model

flush(stderr()); flush(stdout())

### Name: residuals.bgnlm_model
### Title: Residuals for BGNLM Model
### Aliases: residuals.bgnlm_model

### ** Examples

library(FFMS)
data(exoplanet)
model <- get.best.model(ffms(semimajoraxis ~ ., data = exoplanet, family = "gaussian"))
hist(residuals(model, exoplanet[,1], exoplanet[,-1]))



cleanEx()
nameEx("residuals.ffms_base")
### * residuals.ffms_base

flush(stderr()); flush(stdout())

### Name: residuals.ffms_base
### Title: Residuals for FFMS Model
### Aliases: residuals.ffms_base

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "ffms_base", transforms = c("sigmoid"))
hist(residuals(model, exoplanet[,1], exoplanet[,-1]))



cleanEx()
nameEx("residuals.ffms_merged")
### * residuals.ffms_merged

flush(stderr()); flush(stdout())

### Name: residuals.ffms_merged
### Title: Residuals for FFMS Merged Model
### Aliases: residuals.ffms_merged

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, 
method = "ffms.parallel", transforms = c("sigmoid"), 
runs = 2, cores = 1)
hist(residuals(model, exoplanet[,1], exoplanet[,-1]))



cleanEx()
nameEx("residuals.fms_base")
### * residuals.fms_base

flush(stderr()); flush(stdout())

### Name: residuals.fms_base
### Title: Residuals for FMS Model
### Aliases: residuals.fms_base

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms_base")
hist(residuals(model, exoplanet[,1], exoplanet[,-1]))



cleanEx()
nameEx("residuals.fms_parallel")
### * residuals.fms_parallel

flush(stderr()); flush(stdout())

### Name: residuals.fms_parallel
### Title: Residuals for FMS Parallel Model
### Aliases: residuals.fms_parallel

### ** Examples

data(exoplanet)
model <- ffms(semimajoraxis ~ ., data = exoplanet, method = "fms.parallel",runs = 2, cores = 1)
hist(residuals(model, exoplanet[,1], exoplanet[,-1]))



cleanEx()
nameEx("set.transforms")
### * set.transforms

flush(stderr()); flush(stdout())

### Name: set.transforms
### Title: Set the Transformations Option for FFMS (Genetically Modified
###   FMS).
### Aliases: set.transforms

### ** Examples

set.transforms(c("p0","p1"))





cleanEx()
nameEx("sigmoid")
### * sigmoid

flush(stderr()); flush(stdout())

### Name: sigmoid
### Title: Sigmoid Function
### Aliases: sigmoid

### ** Examples

sigmoid(2)





cleanEx()
nameEx("sin_deg")
### * sin_deg

flush(stderr()); flush(stdout())

### Name: sin_deg
### Title: Sine Function for Degrees
### Aliases: sin_deg

### ** Examples

sin_deg(0)




cleanEx()
nameEx("sqroot")
### * sqroot

flush(stderr()); flush(stdout())

### Name: sqroot
### Title: Square Root Function
### Aliases: sqroot

### ** Examples

sqroot(4)




cleanEx()
nameEx("string.population")
### * string.population

flush(stderr()); flush(stdout())

### Name: string.population
### Title: Function to Get a Character Representation of a List of Features
### Aliases: string.population

### ** Examples

result <- ffms_base(y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100), 
P = 2, 
transforms = c("p0", "exp_dbl"))
string.population(result$populations[[1]])




cleanEx()
nameEx("string.population.models")
### * string.population.models

flush(stderr()); flush(stdout())

### Name: string.population.models
### Title: Function to Get a Character Representation of a List of Models
### Aliases: string.population.models

### ** Examples

result <- ffms_base(y = matrix(rnorm(100), 100),
x = matrix(rnorm(600), 100), 
P = 2, 
transforms = c("p0", "exp_dbl"))
string.population.models(result$populations[[2]], result$models[[2]])




cleanEx()
nameEx("summary.ffms_predict")
### * summary.ffms_predict

flush(stderr()); flush(stdout())

### Name: summary.ffms_predict
### Title: Summary of FFMS Prediction Object
### Aliases: summary.ffms_predict

### ** Examples




cleanEx()
nameEx("troot")
### * troot

flush(stderr()); flush(stdout())

### Name: troot
### Title: Cube Root Function
### Aliases: troot

### ** Examples

troot(27)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')

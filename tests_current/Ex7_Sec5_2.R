#######################################################
#
# Example 7 (Section 5.2):
#
# Logic-regression-style FFMS with a frequentist BIC score
#
# DATA - simulated 
#
#
#
# Frequentist adaptation of the ordinal logic-regression example
#
#######################################################

library(FFMS)
library(fastglm)

n = 2000
p = 50

set.seed(1)
X2 <- as.data.frame(array(data = rbinom(n = n*p,size = 1,prob = runif(n = n*p,0,1)),dim = c(n,p)))
y2.Mean = 1+7*(X2$V4*X2$V17*X2$V30*X2$V10) + 9*(X2$V7*X2$V20*X2$V12)+ 3.5*(X2$V9*X2$V2)+1.5*(X2$V37)
Y2 <- rnorm(n = n,mean = y2.Mean,sd = 0.7)
df <- data.frame(Y2,X2)
summary(df)

str(df)


# Split data into training and test dataset
df.training <- df[1:(n/2),]
df.test <- df[(n/2 + 1):n,]
df.test$Mean <- y2.Mean[(n/2 + 1):n]



#############################################################################
#
#   FFMS logic regression with a BIC score and logic-tree penalty
#
#############################################################################



# FFMS can represent logic-regression-style effects without an explicit "or"
# operator, since "and" and "not" can compute "or" via De Morgan's law.

transforms <- c("not")
probs <- gen.probs.ffms_base(transforms)
probs$gen <- c(1,1,0,1) #No projections allowed

params <- gen.params.ffms_base(p)
params$feat$pop.max <- 50
params$feat$L <- 15


logic_width_penalty <- function(width, p)
{
  if (length(width) == 0)
    return(0)

  # Approximate log inverse of the number of logic trees of each width:
  # N(w) ~= choose(p, w) * 2^(2w - 2) ~= (4p)^w / (4*w!).
  sum(log(factorial(width))) - sum(width * log(4 * p) - log(4))
}

estimate.logic.bic = function(y, x, model, complex, mlpost_params)
{
  # Gaussian model fit and BIC-adjusted model score
  suppressWarnings({
    mod <- fastglm(as.matrix(x[, model]), y, family = gaussian())
  })
  fit_score <- -(mod$aic + (log(length(y))-2) * (mod$rank))/2

  # Structural multiplicity penalty for logic-feature width
  complexity_penalty <- logic_width_penalty(complex$width, mlpost_params$p)
  
  # Penalized score used for model selection
  score <- fit_score + complexity_penalty

  if(score==-Inf)
    score = -10000
  
  return(list(crit = score, coefs = mod$coefficients))
}



#############################################################################
#
#   Logic regression training
#
#############################################################################

set.seed(5001)

result <- ffms(formula = Y2~1+., data = df.training, probs = probs, params = params,  
               method = "ffms_base", transforms = transforms, N = 500, P = 25,
               family = "custom", loglik.pi = estimate.logic.bic, pop.max = 50,
               extra_params = list(p = p))
summary(result)
mpm <- get.mpm.model(result, y = df.training$Y2, x = df.training[,-1],
                     family = "custom", loglik.pi = estimate.logic.bic,
                     params = list(p = p))
mpm$coefs
mbest <- get.best.model(result)
mbest$coefs


pred <- predict(result, x =  df.test[,-1], link = function(x)(x))  
pred_mpm <- predict(mpm, x =  df.test[,-1], link = function(x)(x))
pred_best <- predict(mbest, x =  df.test[,-1], link = function(x)(x))


#prediction errors
sqrt(mean((pred$aggr$mean - df.test$Y2)^2))
sqrt(mean((pred_mpm - df.test$Y2)^2))
sqrt(mean((pred_best - df.test$Y2)^2))
sqrt(mean((df.test$Mean - df.test$Y2)^2))

#prediction errors to the true means
sqrt(mean((pred$aggr$mean - df.test$Mean)^2))
sqrt(mean((pred_best - df.test$Mean)^2))
sqrt(mean((pred_mpm - df.test$Mean)^2))



plot(pred$aggr$mean, df.test$Y2)
points(pred$aggr$mean,df.test$Mean,col = 2)
points(pred_best,df.test$Mean,col = 3)
points(pred_mpm,df.test$Mean,col = 4)




#############################################################################
#
#   Parallel version
#
#############################################################################


set.seed(5002)

result_parallel <- ffms(formula = Y2~1+.,data = df.training, probs = probs, params = params, 
                   method = "ffms.parallel", transforms = transforms, N = 500, P=25,
                   family = "custom", loglik.pi = estimate.logic.bic, pop.max = 50,
                   extra_params = list(p = p), runs = 2, cores = 2)
summary(result_parallel)
mpm <- get.mpm.model(result_parallel, y = df.training$Y2, x = df.training[,-1],
                     family = "custom", loglik.pi = estimate.logic.bic,
                     params = list(p = p))
mbest <- get.best.model(result_parallel)


pred_parallel <- predict(result_parallel, x =  df.test[,-1], link = function(x)(x))  
pred_par_mpm <- predict(mpm, x =  df.test[,-1], link = function(x)(x))
pred_par_best <- predict(mbest, x =  df.test[,-1], link = function(x)(x))


#prediction errors
sqrt(mean((pred_parallel$aggr$mean - df.test$Y2)^2))
sqrt(mean((pred_par_best - df.test$Y2)^2))
sqrt(mean((pred_par_mpm - df.test$Y2)^2))
sqrt(mean((df.test$Mean - df.test$Y2)^2))

#prediction errors to the true means
sqrt(mean((pred_parallel$aggr$mean - df.test$Mean)^2))
sqrt(mean((pred_par_best - df.test$Mean)^2))
sqrt(mean((pred_par_mpm - df.test$Mean)^2))



plot(pred_parallel$aggr$mean, df.test$Y2)
points(pred_parallel$aggr$mean,df.test$Mean,col = 2)
points(pred_par_best,df.test$Mean,col = 3)
points(pred_par_mpm,df.test$Mean,col = 4)

marg.probs <- matrix(runif(5), nrow = 1)
marg.probs.full <- c(1, marg.probs)
mock_model <- list(
      model = (marg.probs > 0.5),
      coefs = c(1,2,3,4,5)[marg.probs.full > 0.5],
      crit = 100
)

models <- list(mock_model)
models <- lapply(models, function (x) x[c("model", "crit")])
model.size <- length(models[[1]]$model)
models.matrix <- matrix(unlist(models), ncol = model.size + 1, byrow = TRUE)
duplicates <- duplicated(models.matrix[, 1:(model.size), drop = FALSE], dim = 1, fromLast = TRUE)
print(dim(models.matrix))
print(length(duplicates))
models.matrix <- models.matrix[!duplicates, , drop = FALSE]
print(models.matrix)

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://img.shields.io/github/last-commit/aliaksah/FFMS.svg)](https://github.com/aliaksah/FFMS/commits/master)
[![](https://img.shields.io/github/languages/code-size/aliaksah/FFMS.svg)](https://github.com/aliaksah/FFMS)
[![R build status](https://github.com/aliaksah/FFMS/workflows/R-CMD-check/badge.svg)](https://github.com/aliaksah/FFMS/actions)
[![License: GPL](https://img.shields.io/badge/license-GPL-blue.svg)](https://cran.r-project.org/web/licenses/GPL)

# FFMS — Flexible Frequentist Model Selection

The `FFMS` package provides functions to fit **Frequentist Generalized Nonlinear Models (FGNLMs)** through a Genetically Modified Feature Selection algorithm. It combines symbolic regression with BIC-penalized model selection to automatically discover interpretable nonlinear structure in data.

## Key Features

- **Automatic feature construction**: generates interactions, polynomial transformations, projections, and compositions from raw covariates
- **BIC-consistent penalization**: feature complexity is penalized using `oc_j * log(n)` per feature-tree operation, consistent with Bayesian log-posterior penalties
- **Parallel search**: multiple independent evolutionary chains run in parallel and their results are merged
- **Scientific law discovery**: shown to reliably rediscover Kepler's Third Law from exoplanet data

## Installation

To install and load the development version of the package, run:

```r
library(devtools)
install_github("aliaksah/FFMS", force = TRUE, build_vignettes = TRUE)
library(FFMS)
```

## Quick Start

```r
library(FFMS)
data(exoplanet)

to3 <- function(x) x^3
p2  <- function(x) x^2
transforms <- c("sigmoid", "sin_deg", "exp_dbl", "p0", "p2", "troot", "to3")

# Fast single-thread run
result <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = exoplanet[1:500, ],
  method = "ffms_base",
  transforms = transforms,
  pop.max = 20, P = 20, N = 500
)
summary(result)

# Parallel run — reliably discovers Kepler's Third Law
result.parallel <- ffms(
  formula = semimajoraxis ~ 1 + .,
  data = exoplanet[1:500, ],
  method = "ffms.parallel",
  transforms = transforms,
  runs = 16,
  pop.max = 80,
  prob_gen = c(0.5, 0.3, 0.1, 0.1),   # favour multiplication for chaining
  prob_filter = 0.3,                    # keep intermediate building blocks
  P = 80,
  N = 500,
  cores = parallel::detectCores() - 1
)
summary(result.parallel)
# Top models consistently contain (hoststar_mass * p2(troot(period)))
# → matching the true law: a ∝ (M · P²)^(1/3) = M^(1/3) · P^(2/3)
```

## Algorithm Overview

FFMS implements a Genetically Modified Feature Selection algorithm:

1. **Population initialization**: start with raw covariates as candidate features
2. **SIC optimization (continuous relaxation)**: for each population, find which features are informative using a continuous bridge penalty that shrinks irrelevant feature coefficients to zero via BFGS optimization with epsilon-telescope
3. **Discrete evaluation**: evaluate the thresholded feature set via BIC-penalized log-likelihood
4. **Genetic transition**: generate a new feature population by:
   - **Multiplication**: pair two existing features as an interaction
   - **Modification**: apply a nonlinear transform to an existing feature
   - **Projection**: apply a transform to a linear combination of features
   - **New**: sample a fresh raw covariate
5. Repeat for `P` populations; run multiple independent chains in parallel

### Feature Complexity Penalty

Each feature is penalized by `oc_j × log(n)` where `oc_j` is the number of operations (tree nodes) in the feature's symbolic expression. This ensures deep nested features like `troot(period² × M)` (3 operations) are penalized proportionally, consistent with BIC.

## Exoplanet Example: Recovering Kepler's Third Law

The exoplanet dataset contains orbital and physical properties of confirmed exoplanets. The true underlying law (Kepler's Third Law) is:

**a = (G/4π²)^(1/3) × (M · P²)^(1/3)** ∝ **M^(1/3) · P^(2/3)**

FFMS reliably discovers this structure in the parallel run's top models:
- `(troot(period) * troot(period))` = P^(2/3)
- `((troot(period) * troot(period)) * hoststar_mass)` = M · P^(2/3) ≈ Kepler's law
- With more populations, recovers the exact `troot(p2(period) * hoststar_mass)` = (M · P²)^(1/3)

## Available Transforms

| Name | Function | Description |
|------|----------|-------------|
| `troot` | x^(1/3) | Cube root |
| `p2` | x^2 | Square |
| `to3` | x^3 | Cube |
| `p0` | log(1+exp(x)) | Softplus |
| `sigmoid` | 1/(1+exp(-x)) | Logistic |
| `sin_deg` | sin(x°) | Sine (degrees) |
| `exp_dbl` | exp(x/2) | Half-exponential |

## Methods

| Method | Description |
|--------|-------------|
| `ffms_base` | Single-thread evolutinary feature selection |
| `ffms.parallel` | Multi-thread parallel runs, results merged |
| `fms_base` | Classical frequentist model selection (no feature generation) |

## Key Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `pop.max` | Max population size (features per generation) | 15 |
| `P` | Number of evolutionary populations | 10 |
| `N` | Iterations per population | 100 |
| `prob_gen` | Probabilities for (multiplication, modification, projection, new) | c(0.4, 0.4, 0.1, 0.1) |
| `prob_filter` | Feature survival threshold | 0.6 |
| `penalty_a` | Multiplier on BIC complexity penalty | 1.0 |
| `runs` | Number of parallel chains (ffms.parallel) | 2 |
| `cores` | CPU cores for parallel execution | 2 |

## Citation

If you use FFMS in your research, please cite the original FBMS paper on which this package is based:

> Hubin A., Storvik G., Frommlet F. (2021). Flexible Bayesian Nonlinear Model Configuration. *Journal of Artificial Intelligence Research*, 72, 901–942.

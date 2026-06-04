[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://img.shields.io/github/last-commit/jonlachmann/FFMS.svg)](https://github.com/jonlachmann/FFMS/commits/master)
[![](https://img.shields.io/github/languages/code-size/jonlachmann/FFMS.svg)](https://github.com/jonlachmann/FFMS)
[![R build status](https://github.com/jonlachmann/FFMS/workflows/R-CMD-check/badge.svg)](https://github.com/jonlachmann/FFMS/actions)
[![codecov](https://codecov.io/gh/jonlachmann/FFMS/branch/master/graph/badge.svg)](https://codecov.io/gh/jonlachmann/FFMS)
[![License: GPL](https://img.shields.io/badge/license-GPL-blue.svg)](https://cran.r-project.org/web/licenses/GPL)

# FFMS - Flexible Frequentist Model Selection

The `FFMS` package provides functions to estimate Frequentist Generalized nonlinear models through a Genetically Modified Mode Jumping MCMC algorithm.

# Installation and getting started
To install and load the development version of the package, just run
```
library(devtools)
install_github("jonlachmann/FFMS", force=T, build_vignettes=T)
library(FFMS)
```
With the package loaded, a vignette that shows how to run the package is available by running
```
vignette("FFMS-guide")
```

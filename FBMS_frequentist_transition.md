# Transition Guide: Bayesian FBMS (GMJMCMC) to Frequentist FBMS (SIC-GM)

This guide outlines the architectural and mathematical changes required to transition the **FBMS** repository (`https://github.com/jonlachmann/FBMS`) from a Bayesian Genetically Modified Mode Jumping MCMC (GMJMCMC) framework to a frequentist approach utilizing the **Smooth Information Criterion (SIC)** with a relaxed $L_0$ norm.

---

## 1. Conceptual Overview

Currently, the `FBMS` package operates in two main phases:
1. **Intra-Population Search (`mjmcmc.loop`)**: Uses Mode Jumping MCMC to explore the model space of the current feature population $S_p$, generating Bayesian marginal inclusion probabilities (`marg.probs`) for each feature.
2. **Inter-Population Transition (`gmjmcmc.transition`)**: Uses a genetic algorithm to breed a new population of features $S_{p+1}$. Features with high `marg.probs` survive and are used as parents (via interactions and nonlinear transformations) to generate new features.

**The Frequentist SIC Transition:**
We will replace the Bayesian MJMCMC sampling with a gradient-based optimization using the **relaxed $L_0$ norm (SIC penalty)**. The optimized soft-inclusion values ($\phi_\epsilon(\beta)$) will replace the Bayesian `marg.probs` to drive the survival and genetic proposals of the next population.

---

## 2. Replacing MJMCMC with SIC Optimization

Inside `R/gmjmcmc.R`, the call to `mjmcmc.loop()` will be replaced by a continuous optimizer (e.g., via `torch` for R or `optim`).

### A. The Objective Function
For a given population of features $S_p$, construct a design matrix $X_p$. Instead of Bayesian sampling, we optimize the coefficients $\beta$ to minimize the SIC objective:
$$\mathcal{L}(\beta) = -2\ell(\beta) + \sum_{j \in S_p} \lambda_j \phi_\epsilon(\beta_j)$$
where $\phi_\epsilon(\beta_j) = \frac{\beta_j^2}{\beta_j^2 + \epsilon^2}$.

### B. Penalty Corresponding to Prior Inclusions
In standard GMJMCMC, features have prior inclusion probabilities (often scaled by complexity). To mirror this in the frequentist SIC framework, the penalty term $\lambda_j$ must be feature-specific. 

If a feature $j$ has a prior inclusion probability $\pi_j$, the equivalent SIC penalty can be derived from the log-odds of the prior:
$$\lambda_j = c - 2 \log\left(\frac{\pi_j}{1 - \pi_j}\right)$$
- Features with **high** prior probabilities ($\pi_j \to 1$) receive a **lower** penalty $\lambda_j$, making it easier for them to be selected.
- Features with **low** prior probabilities (e.g., highly complex deep interactions) receive a **higher** penalty.
*(Note: $c$ is a baseline complexity penalty, e.g., $\log(n)$ for BIC equivalence).*

### C. The $\epsilon$-Telescope
During the optimization of population $p$, apply the $\epsilon$-telescope schedule (decaying $\epsilon$ from $\epsilon_1 = 1.0$ down to $\epsilon_T = 10^{-4}$) to strictly separate active features from inactive ones.

---

## 3. Modifying the Genetic Transitions

Once the SIC optimization converges for population $p$, we evaluate the relaxed $L_0$ norm for each feature's coefficient:
$$P_{\text{include}}(\beta_j) = \phi_{\epsilon_T}(\beta_j) = \frac{\beta_j^2}{\beta_j^2 + \epsilon_T^2}$$

These values $P_{\text{include}}(\beta_j) \in (0, 1)$ act as the frequentist equivalent of `marg.probs` and dictate the genetic algorithm.

### A. Feature Survival
In `R/gmjmcmc.R` and `R/feature_generation.R`, features survive to the next population based on $P_{\text{include}}$:
- **Selected Features**: If $\phi_{\epsilon_T}(\beta_j) \approx 1$, the feature survives with high probability.
- **Non-Selected Features**: If $\phi_{\epsilon_T}(\beta_j) \approx 0$, the feature can still survive with a small baseline probability (e.g., `params$eps` in FBMS), preserving genetic diversity.

```R
# Conceptual R replacement in gmjmcmc.transition()
marg.probs <- phi_epsilon(optimized_betas, epsilon_T)
feats.keep <- as.logical(rbinom(n = length(marg.probs), size = 1, prob = pmin(marg.probs / probs$filter, 1)))
```

### B. Generating Genetic Proposals (Parents)
When generating new features (mutations, crossovers/interactions), the algorithm samples parent features from the current population. 
- The sampling weights for picking parents should be strictly proportional to $P_{\text{include}}(\beta_j)$.
- **Result**: Features successfully selected by the SIC optimization become parents with vastly higher probabilities than those shrunk to zero by the SIC penalty.

---

## 4. Required Code Adjustments in the FBMS Repo

1. **`R/mjmcmc.R` $\to$ `R/sic_optimize.R`**:
   - Create a new script containing the gradient descent loop with the $\epsilon$-telescope.
   - Input: Design matrix of current population $X_p$, response $y$, prior inclusion probabilities $\pi$.
   - Output: Optimized $\beta$ coefficients and their corresponding $\phi_{\epsilon_T}(\beta)$ scores.

2. **`R/gmjmcmc.R`**:
   - Locate the main population loop: `for (p in seq_len(P)) { ... }`
   - Replace `mjmcmc_res <- mjmcmc.loop(...)` with `sic_res <- sic_optimize.loop(...)`.
   - Map `sic_res$phi_scores` to the `marg.probs[[p]]` variable so the downstream genetic transition code continues to function seamlessly.

3. **`R/arguments.R` (Parameters)**:
   - Add default hyperparameters for the SIC $\epsilon$-telescope (e.g., `epsilon_1`, `epsilon_T`, `steps_T`) to `gen.params.gmjmcmc()`.
   - Update `gen.probs.gmjmcmc()` to manage the baseline survival rate (previously $0.05$ or $0.01$) for features completely pruned by the SIC penalty.

## 5. Updating Predictions and Summaries

Since we are shifting from a Bayesian perspective to a Frequentist one, the methods for summarizing and predicting must be adjusted to reflect deterministic point estimates rather than posterior distributions.

1. **`predict.gmjmcmc`**:
   - **Old Behavior:** Predictions were computed using Bayesian Model Averaging (BMA), where predictions from various visited models were weighted by their marginal posterior model probabilities.
   - **New Behavior:** BMA is no longer applicable. Instead, predictions should be based on the **best sparse model** discovered across all multi-restart optimization runs. The prediction uses the deterministic optimized weights $\beta$, effectively applying a hard threshold where features with $\phi_{\epsilon_T}(\beta_j) \le \tau$ are zeroed out (or evaluated simply using the relaxed weights). Alternatively, one can average predictions across the top local minima (restarts) weighted by their SIC scores.

2. **`summary.gmjmcmc`**:
   - **Old Behavior:** Reported Bayesian marginal posterior inclusion probabilities for features and models.
   - **New Behavior:** The summary must now report the **soft-inclusion values ($\phi_{\epsilon_T}(\beta_j)$)**, the specific SIC penalty sizes applied to each feature ($\lambda_j$), and the sparsity percentage of the model (the proportion of features effectively pruned vs. active).

## 6. Developing the Methodological White Paper (.tex)

To properly document this theoretical transition and its mathematical properties, a formal LaTeX white paper must be drafted. 

- The paper should be structurally and theoretically based on the foundational JAIR article: [Flexible Bayesian Nonlinear Model Configuration (Hubin, Storvik, Frommlet, 2021)](https://www.jair.org/index.php/jair/article/view/13047/26740).
- **Core Focus:** The white paper will adapt the Bayesian nonlinear feature generation and genetic mode-jumping methodology introduced in the JAIR article, reformulating the statistical inference portion. It will rigorously define how the Bayesian marginal likelihoods and priors on the function space are substituted by the **Smooth Information Criterion (SIC)** with corresponding feature-specific penalties ($\lambda_j$), ensuring that the search for flexible nonlinear models remains theoretically sound and practically scalable in a frequentist framework.

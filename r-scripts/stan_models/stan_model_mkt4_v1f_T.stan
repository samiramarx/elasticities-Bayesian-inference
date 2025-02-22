data {
  // In this section, we define the data that must be passed to Stan (from whichever environment you are using)

  int N; // number of observations
  int K; // number of covariates
  matrix[N, K] X; //covariate matrix
  vector[N] y; //outcome vector
}
parameters {
  // Define the parameters that we will estimate, as well as any restrictions on the parameter values (standard deviations can't be negative...)

  vector [K] beta; // the regression coefficients
  real<lower = 0> sigma; // the residual standard deviation (note that it's restricted to be non-negative)
}
model {
  // This is where we write out the probability model, in very similar form to how we would using paper and pen

  // Define the priors
  beta[1] ~ normal(0, 1); // same prior for all betas; we could define a different one for each, or use a multivariate prior
  beta[2] ~ normal(-0.5, 0.5) T[ ,0];
  beta[3] ~ normal(0.5, 0.5) T[0, ];
  beta[4] ~ normal(0.5, 0.5) T[0, ];
  beta[5] ~ normal(0.5, 0.5) T[0, ];
  beta[6] ~ normal(0.5, 0.5) T[0, ];
  beta[7] ~ normal(0.5, 0.5) T[0, ];
  beta[8] ~ normal(0, 1) T[0, ];
  beta[9] ~ normal(0, 1) T[ ,0];
  // sigma ~ cauchy(0, 2.5);
  

  // The likelihood
  y ~ normal(X*beta, sigma);
}

generated quantities {
  // For model comparison, we'll want to keep the likelihood contribution of each point
  // We will also generate posterior predictive draws (yhat) for each data point. These will be elaborated on below.

  vector[N] log_lik;
  vector[N] y_sim;
  for(i in 1:N){
    log_lik[i] = normal_log(y[i], X[i,]*beta, sigma);
    y_sim[i] = normal_rng(X[i,]*beta, sigma);
  }
  
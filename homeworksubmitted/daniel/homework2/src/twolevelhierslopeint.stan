// Two-level (1 hierarchical grouping) `random' slope and intercept model
// Partial pooling on intercepts and slopes 

data{
int<lower=0> N; 	// number of total individuals (observations)
int<lower=0> Nspp; 	// number of species (grouping factor)
int species[N]; 	// species identity, coded as int
vector[N] wetmass; 	// wetmass (predictor for slope)
real y[N]; 		// swimming speed (response)
}

parameters{
real mu_a;		// mean intercept across species
real<lower=0> sigma_a;	// variation of intercept across species	
real mu_b;		// mean slope for individuals across species
real<lower=0> sigma_b;	// variation of slope across species
real<lower=0> sigma_y; 	// measurement error, noise etc. 	
real a[Nspp]; 		//the intercept for each species
real b[Nspp]; 		//the slope for each species 

}

transformed parameters{
real ypred[N];
for (i in 1:N){
    ypred[i]=a[species[i]]+b[species[i]]*wetmass[i];
}
}

model{	
b ~ normal(mu_b, sigma_b); // this creates the partial pooling on slopes
a ~ normal(mu_a, sigma_a); // this creates the partial pooling on intercepts
y ~ normal(ypred, sigma_y); // this creates an error model where error is normally distributed
// Priors ...
mu_a ~ normal(16,8);
sigma_a ~ normal(8,4);
mu_b ~ normal(1,0.5);
sigma_b ~ normal(0.5,0.25);
sigma_y ~ normal(20,10);
}	

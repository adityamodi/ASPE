function val = prob_mass(mu,sd)
	val = normcdf(1,mu,sd) - normcdf(0,mu,sd);
end
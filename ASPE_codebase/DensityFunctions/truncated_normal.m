function tnprob = trunc_normal(x,m,sd)
	tnprob = normpdf((x,m,sd)/normcdf(1,m,sd) - normcdf(0,m,sd);
end
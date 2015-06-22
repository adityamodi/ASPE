function [lik,der] = trunc_normal(x,params)
	% returns the vector of per sample likelihood and derivative wrt parameters
	% params = [mu;stddev]
	% lik = TN(x;mu,sd,0,1)
	if isempty(x)
		lik = '';
		der = '';
	else
		mu = params(1);
		sd = params(2);
		ep = 1e-6;
		% mass = prob_mass(mu,sd);
		% massder_mu = (prob_mass(mu+eps,sd)-prob_mass(mu-eps,sd))/(2*eps);
		% massder_sd = (prob_mass(mu,sd+eps)-prob_mass(mu,sd-eps))/(2*eps);

		% lik = normpdf(x,mu,sd)/mass;

		% dermu = lik .* (mass*(x-mu)/sd^2 - massder_mu)/mass^2;
		% ds = -1/sd + (x-mu).^2/sd^3;
		% dersd = lik .* (mass*ds - massder_sd)/mass^2;

		% der = [dermu dersd];

		pd = makedist('normal',mu,sd);
		pd = truncate(pd,0,1);
		lik = pdf(pd,x);

		pd = makedist('normal',mu+ep,sd);
		pd = truncate(pd,0,1);
		likr = pdf(pd,x);
		pd = makedist('normal',mu-ep,sd);
		pd = truncate(pd,0,1);
		likl = pdf(pd,x);

		dermu = (likr-likl)/(2*ep);

		pd = makedist('normal',mu,sd+ep);
		pd = truncate(pd,0,1);
		likr = pdf(pd,x);
		pd = makedist('normal',mu,sd-ep);
		pd = truncate(pd,0,1);
		likl = pdf(pd,x);

		dersd = (likr-likl)/(2*ep);

		der = [dermu dersd];

	end
end
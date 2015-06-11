function [lik,der] = normal_density(x,params)
	% returns the vector of per sample likelihood and derivative wrt parameters
	% params = [mu;stddev]
	% lik = N(x;mu,sd)

	if isempty(x)
		lik = '';
		der = '';
	else
		mu = params(1);
		sd = params(2);

		lik = normpdf(x,mu,sd);

		dermu = bsxfun(@times,lik,(x-mu)/sd^2);

		ds = -1/sd + (x-mu).^2/sd^3;
		dersd = bsxfun(@times,lik,ds);

		der = [dermu dersd];
	end
end
function [lik,der] = beta_density(x,params)
	% returns the vector of per sample likelihood and derivative wrt parameters
	% params = [a;b]
	% lik = Beta(x;a,b)

	if isempty(x)
		lik = '';
		der = '';
	else
		a = params(1);
		b = params(2);

		lik = (bsxfun(@times,x.^(a-1),(1-x).^(b-1)))/beta_f(a,b);

		dera = bsxfun(@times,lik,log(x)+psi(a+b)-psi(a));
		derb = bsxfun(@times,lik,log(1-x)+psi(a+b)-psi(b));

		der = [dera derb];
	end
end
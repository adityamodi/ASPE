function [loglik,loglik_der] = try_trunc_normal(params,scores,labels)

	lik_der = zeros(length(params),1);

	pos_scores = labels(labels==1);

	pos = length(pos_scores);

% returns the per sample likelihood (class-conditional) and derivative wrt parameters

	[lik,lik_der] = truncated_normal(pos_scores,params);

% adding epsilon term for preventing numerical errors;

	lik = lik + eps;

	loglik = -sum(log(lik))
	pause;

	loglik_der = -sum(bsxfun(@times,lik_der,1./lik))';

end

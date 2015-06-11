function [maxent_lik,lik_der] = get_maxent_likelihood(scores,labels,params,lambda,distHandler0,disthandler1,m0,m1)
	% distId - 0 - truncated normal
	% distId - 1 - normal
	% distId - 2 - beta

	% lambda - value given for the lanmbda value in the modified likelihood expression

	p1 = params(0);

	params0 = params(2:1+m0);
	params1 = params(m0+2:m1+m0+1);

	p0 = 1 - p1;

	unlabeledscores = scores(isnan(labels));
	pos_scores = scores(labels==1);
	neg_scores = scores(labels==0);

% returns the per sample likelihood and derivative wrt parameters

	[labeled_lik1,labeled_lik_der1] = disthandler1(params1,pos_scores);
	[labeled_lik0,labeled_lik_der0] = distHandler0(params0,neg_scores);

	[unlabeled_lik1,unlabeled_lik_der1] = disthandler1(params1,unlabeledscores);
	[unlabeled_lik0,unlabeled_lik_der0] = distHandler0(params0,unlabeledscores);

% adding epsilon term for preventing numerical errors;

	labeled_lik1 = labeled_lik1 + eps;
	labeled_lik0 = labeled_lik0 + eps;
	unlabeled_lik0 = unlabeled_lik0 + eps;
	unlabeled_lik1 = unlabeled_lik1 + eps;

	log_lik_lab1 = log(labeled_lik1);
	log_lik_lab0 = log(labeled_lik0);
	log_lik_unlab0 = log(unlabeled_lik0);
	log_lik_unlab1 = log(unlabeled_lik1);

	maxent_lik = lambda*(p1*log(p1) + p0*log(p0));
	lik_der = zeros(length(params),1);

	num_lab = length(pos_scores)+length(neg_scores);
	num_unlab = length(unlabeledscores);

% value of modified likelihood

	maxent_lik = maxent_lik + (sum(log(p1*labeled_lik1)) + sum(log(p0*labeled_lik0)))/(num_lab);
	maxent_lik = maxent_lik + (lambda/num_unlab)*(sum(p1*bsxfun(@times,unlabeled_lik1,log_lik_unlab1) + ...
		p0*bsxfun(@times,unlabeled_lik0,log_lik_unlab0) ));

% derivative of likelihood on the parameters

	lik_der(1) = (length(pos_scores)*(1/p1) - length(neg_scores)*(1/p0))/num_lab + lambda*(log(p1) - log(p0));
	lik_der(1) = (lambda*(sum( bsxfun(@times,log_lik_unlab1,unlabeled_lik1) - ...
		bsxfun(@times,unlabeled_lik0,log_lik_unlab0) )))/num_unlab;

	lik_der(2:m0+1) = ((sum( bsxfun(@times,labeled_lik_der0,1./labeled_lik0) ))/num_lab)' + ...
		((lambda*(p0*sum( bsxfun(@times,labeled_lik_der0,1+log(labeled_lik0)) )))/num_unlab)';

	lik_der(m0+2:m1+m0+1) = ((sum( bsxfun(@times,labeled_lik_der1,1./labeled_lik1) ))/num_lab)' + ...
		((lambda*(p1*sum( bsxfun(@times,labeled_lik_der1,1+log(labeled_lik1)) )))/num_unlab)';

% we call a minimiser on the function

	maxent_lik = -maxent_lik;
	lik_der = -lik_der;
function [maxent_lik,lik_der] = get_likelihood_ER(params,scores,labels,lambda,distHandler0,disthandler1,m0,m1)
	% distId - 0 - truncated normal
	% distId - 1 - normal
	% distId - 2 - beta

	% lambda - value given for the lanmbda value in the modified likelihood expression

	p1 = params(1);

	lik_der = zeros(length(params),1);

	params0 = params(2:1+m0);
	params1 = params(m0+2:m1+m0+1);

	n = length(scores);

	p0 = 1 - p1;

	unlabeledscores = scores(isnan(labels));
	labeled_scores = scores(~isnan(labels));
	glabels = labels(~isnan(labels));
	pos_scores = labeled_scores(glabels==1);
	neg_scores = labeled_scores(glabels==0);

	pos = length(pos_scores);
	neg = length(neg_scores);

	% hist(pos_scores,100);
	% hold on;
	% hist(neg_scores,100);
	% h = findobj(gca,'Type','patch');
	% set(h(1),'Facecolor',[1 0 0],'EdgeColor','k');
	% pause

% returns the per sample likelihood (class-conditional) and derivative wrt parameters

	[labeled_lik1,labeled_lik_der1] = disthandler1(labeled_scores,params1);
	[labeled_lik0,labeled_lik_der0] = distHandler0(labeled_scores,params0);

	[unlabeled_lik1,unlabeled_lik_der1] = disthandler1(unlabeledscores,params1);
	[unlabeled_lik0,unlabeled_lik_der0] = distHandler0(unlabeledscores,params0);

% adding epsilon term for preventing numerical errors;

	labeled_lik1 = labeled_lik1 + eps;
	labeled_lik0 = labeled_lik0 + eps;
	unlabeled_lik0 = unlabeled_lik0 + eps;
	unlabeled_lik1 = unlabeled_lik1 + eps;

% Separating the class conditional probabilities for the two classes

	pos_lik1 = labeled_lik1(glabels==1);
	pos_lik0 = labeled_lik0(glabels==1);

	neg_lik1 = labeled_lik1(glabels==0);
	neg_lik0 = labeled_lik0(glabels==0);

% marginal likelihood of various scores

	marg_pos = p1*pos_lik1 + p0*pos_lik0;
	marg_neg = p1*neg_lik1 + p0*neg_lik0;
	marg_unlab = p1*unlabeled_lik1 + p0*unlabeled_lik0;

% Log derivatives of class conditional probabilities

	pos_lik_der1 = labeled_lik_der1(glabels==1);
	pos_lik_der0 = labeled_lik_der0(glabels==1);

	neg_lik_der1 = labeled_lik_der1(glabels==0);
	neg_lik_der0 = labeled_lik_der0(glabels==0);


% Ratio of likelihood derivative with marginal probability

	log_der_unlab0 = bsxfun(@times,1./marg_unlab,unlabeled_lik_der0);
	log_der_unlab1 = bsxfun(@times,1./marg_unlab,unlabeled_lik_der1);

% Label likelihood for all scores

	pos_lab_lik = bsxfun(@times,p1*pos_lik1,1./marg_pos);
	neg_lab_lik = bsxfun(@times,p0*neg_lik0,1./marg_neg);
	unlab_lik1 = bsxfun(@times,p1*unlabeled_lik1,1./marg_unlab);
	unlab_lik0 = bsxfun(@times,p0*unlabeled_lik0,1./marg_unlab);


% value of modified likelihood

	maxent_lik =  sum(log(p1*pos_lik1))  + sum(log(p0*neg_lik0)) + ...
		lambda*sum( unlab_lik1 .* log(unlab_lik1) + unlab_lik0 .* log(unlab_lik0) );
	
% derivative of likelihood on the parameters

	lik_der(1) = pos/p1 - neg/p0 + ...
		lambda*sum( bsxfun(@times,log(unlab_lik1) + 1, unlab_lik1/p1 - unlab_lik1 .* ((unlabeled_lik1 - unlabeled_lik0)./marg_unlab) ) ) + ...
		lambda*sum( bsxfun(@times,log(unlab_lik0) + 1, -unlab_lik0/p0 - unlab_lik0 .* ((unlabeled_lik1 - unlabeled_lik0)./marg_unlab) ));

	lik_der(2:m0+1) = sum( bsxfun(@times,1./neg_lik0,neg_lik_der0) )' + ...
		lambda*sum( bsxfun(@times , -(1+log(unlab_lik1)).*unlab_lik1 , log_der_unlab0) )' + ...
		lambda*sum( bsxfun(@times , p0*(1+log(unlab_lik0)).*(1- unlab_lik0) , log_der_unlab0) )';

	lik_der(m0+2:m1+m0+1) = sum( bsxfun(@times,1./pos_lik1,pos_lik_der1) )' + ...
		lambda*sum( bsxfun(@times, -(1+log(unlab_lik0)).*unlab_lik0 , log_der_unlab1) )' + ...
		lambda*sum( bsxfun(@times, p1*(1+log(unlab_lik1)).*(1- unlab_lik1), log_der_unlab1 ))';

% we call a minimiser on the function

	maxent_lik = -maxent_lik;
	lik_der = -lik_der;
end
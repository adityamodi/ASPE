function MAPestimate = getLabelfromMAP(scores,labels,weights,distHandler0,distHandler1,m0,m1)

	% returns 100 sampled vectors of missing labels so that an average estimate can be obtained for the performance metrics

	p1 = weights(1);
	p0 = 1 - p1;
	params0 = weights(2:m0+1);
	params1 = weights(m0+2:end);

	unlab_indices = find(isnan(labels));
	label_indices = setdiff(1:length(labels),unlab_indices);

	lik0 = distHandler0(scores,params0);
	lik1 = distHandler1(scores,params1);

	marg_lik = p0*lik0 + p1*lik1;

	pos_lik = (p1*lik1)./marg_lik;
	neg_lik = (p0*lik0)./marg_lik;

	pred_labels = [];
	for i=1:100
		pred_labels = [pred_labels sum(mnrnd(ones(length(scores),1),[pos_lik neg_lik]).*[0 1],2)];
	end

	
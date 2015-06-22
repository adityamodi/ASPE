function PerfEval(scores,samplabels,truelabels,densityParams)
	% returns matrix containing various performance metrics for different threshold values
	% can further be used to generate performance curves
	% Performance metrics returned for true labels, sampled labels

	distId0 = densityParams.distId0;
	distId1 = densityParams.distId1;
	weights = densityParams.weights;

	[~,distHandler0,distHandler1,m0,m1] = get_dist_handlers(distId0,distId1);
	predLabels = getLabelsfromMAP(scores,samplabels,weights,distHandler0,distHandler1,m0,m1);



	% generate samples from the observed density parameters
	Performance.TruePF = TruePerfEval(scores,truelabels);
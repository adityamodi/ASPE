function [scores,labels,numsamples,initlabels] = ASPE_initialise(dataId,selectId,percLabel,sampleId,varargin)
	% dataId - 1 to 3
	% selectId - 0 - AUROC
	% selectId - 1 - Accuracy
	% selectId - 2 - F-measure
	% percLabel - Percentage of scores to be labeled,
	% densityId - 0 - truncated Normal
	% densityId - 1 - normal
	% densityId - 2 - beta
	% sampleId - 0 - Random one time sampling
	% sampleId - 1 - Iterative but passive sampling
	% sampleId - 2 - Iterative active sampling
	% initPerc - Initial percentage of labeling in case of active sampling
	datadir = dir('data_processed/binary*');
	load(['data_processed/' datadir(dataId).name]);

	switch selectId
		case 0
			scores = test_scores_AUROC(:,1);
		case 1
			scores = test_scores_acc(:,1);
		case 2
			scores = test_scores_fmeas(:,1);
	end

	labels = test_label;
	labels(labels<=0) = 0;

	numsamples = ceil(double(percLabel*length(scores))/100);

	if sampleId ~= 0
		initPerc = varargin{1};
		initlabels = ceil(double(initPerc*numsamples)/100);
	else
		initlabels = numsamples;
	end

end
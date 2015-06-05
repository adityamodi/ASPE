function ASPE_main(dataId,selectId,percLabel,sampleId,densityId_0,densityId_1)

	% Main function to call the procedure on given parameters

	if sampleId ~= 0
		initPerc = input('Enter the percentage of labels to be initially labeled:\n');
		[scores,labels,budget,initlabel] = ASPE_initialise(dataId,selectId,percLabel,sampleId,initPerc);
	else
		[scores,labels,budget,initlabel] = ASPE_initialise(dataId,selectId,percLabel,sampleId);
	end

	size(scores)
	sel = randperm(length(scores));
	initlabel
	nsel = sel(initlabel+1:length(scores));
	sel = sel(1:initlabel);
	scores_lab = scores(sel);
	scores_unlab = scores(nsel);
	labels_sel = labels(sel);
	labels_nsel = labels(nsel);
end
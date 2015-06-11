function ASPE_main(dataId,selectId,percLabel,sampleId,densityId_0,densityId_1)

	% Main function to call the procedure on given parameters

	if sampleId ~= 0
		initPerc = input('Enter the percentage of labels to be initially labeled:\n');
		[scores,labels,budget,initlabel] = ASPE_initialise(dataId,selectId,percLabel,sampleId,initPerc);
	else
		[scores,labels,budget,initlabel] = ASPE_initialise(dataId,selectId,percLabel,sampleId);
	end

	size(scores)

%	samplabels = NaN(length(scores),1);
	[samplabels,budget] = initialLabeling(labels,initlabel);
	[params,distHandler0,distHandler1,m0,m1] = get_dist_handlers(densityId_0,densityId_1);

	if sampleId == 0
		lambda = 0.5;
		

end
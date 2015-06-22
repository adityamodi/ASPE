function ASPE_main(dataId,selectId,percLabel,sampleId,distId0,distId1,isPriorAvail)

	% Main function to call the procedure on given parameters

	% dataId denotes the dataset to be taken
	% selectId denotes which classifier score is to be chosen
	% percLabel denotes the total budget for labeled samples - percentage of the budget
	% sampleId is the sampling strategy used
	% sampleId = 0 - no active sampling
	% otherwise
	% 1 - maxmin change based greedy sampling
	% 2 - expected change based greedy sampling
	% 3 - density based uncertainity sampling
	% 4 - uncertainity based sampling
	% 5 - random sampling


	if sampleId ~= 0
		initPerc = input('Enter the percentage of labels to be initially labeled:\n');
		[scores,labels,budget,initlabel] = ASPE_initialise(dataId,selectId,percLabel,sampleId,initPerc);
	else
		[scores,labels,budget,initlabel] = ASPE_initialise(dataId,selectId,percLabel,sampleId);
	end

%	samplabels = NaN(length(scores),1);
	[samplabels,budget] = initialLabeling(labels,budget,initlabel);

	% addpath(genpath('DensityFunctions'));
	% addpath(genpath('lib/minFunc_2012'));

	% options = [];
	% params = [0.7;0.2];
	% [pos_weights,~,~,~] = minFunc(@try_trunc_normal,params,options,scores,labels);

	% pos_scores = scores(labels==0);
	% [n1,c1] = hist(pos_scores,100);
	% dx = diff(c1(1:2));
	% bar(c1,n1/sum(n1*dx),'b');
	% hold on;
	% x = 0:0.01:1;
	% pd = makedist('normal',pos_weights(1),pos_weights(2));
	% pd = truncate(pd,0,1);
	% pdd = pdf(pd,x);
	% plot(x,pdd,'r','Linewidth',2);
	% pause;

	% rmpath(genpath('DensityFunctions'));
	% rmpath(genpath('lib/minFunc_2012'));

	% Fit the density parameters for initial labels provided
	disp('Starting to fit density parameters.....');
	initDenistyParameters = fit_density_model(scores,samplabels,distId0,distId1,-5,0,isPriorAvail);
	% Initial density parameters found
	initDenistyParameters.weights

	while budget > 0

	end

	plotcurves(scores,labels,initDenistyParameters);


	
		

end
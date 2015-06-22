function densityParams = fit_density_model(scores,currentlabels,distId0,distId1,minTemp,maxTemp,isPriorAvail)

	% returns the parameters found by applying minfunc over the objective function
	% current set of labeled and unlabeled examples given
	% labeled - 0/1 , unlabeled - NaN
	% to get a better local maxima, we apply deterministic annealing strategy over the optimisation routine

	% distId - 0 - truncated normal
	% distId - 1 - normal
	% distId - 2 - beta

	% minTemp - minimum temperature for the DA method (antilog value)
	% maxTemp - maximum temperature for the DA method (antilog value)

	% likelihood function is provided as the function over different objective functions

	[params0,distHandler0,distHandler1,m0,m1] = get_dist_handlers(distId0,distId1);

	addpath(genpath('DensityFunctions'));
	addpath(genpath('lib/minFunc_2012'));

	options = [];
	% options.display = 'full';
	options.display = 'none';
	%options.DerivativeCheck = 'on';

	if ~isPriorAvail
		params = [0.5 ; params0];
		lambda = 10^minTemp;
		% disp('First minFunc');
		% disp(lambda);
		[weights,lik,~,~] = minFunc(@get_likelihood_KL_weighted,params,options,scores,currentlabels,lambda,distHandler0,distHandler1,m0,m1);
		params = weights;

		for lambda = logspace(minTemp,maxTemp,10)
			%Deterministic annealing step
			% disp('Current lambda');
			% disp(lambda);
			[weights,lik,~,~] = minFunc(@get_likelihood_KL_weighted,params,options,scores,currentlabels,lambda,distHandler0,distHandler1,m0,m1);
			params = weights;
		end
	else
		params = params0;
		lambda = 10^minTemp;

		[weights,lik,~,~] = minFunc(@get_likelihood_KL_p,params,options,scores,currentlabels,lambda,distHandler0,distHandler1,m0,m1,isPriorAvail);
		params = weights;

		for lambda = logspace(minTemp,maxTemp,5)
			%Deterministic annealing step
			[weights,lik,~,~] = minFunc(@get_likelihood_KL_p,params,options,scores,currentlabels,lambda,distHandler0,distHandler1,m0,m1,isPriorAvail);
			params = weights;
		end
		weights = [isPriorAvail ; weights];
	end

	densityParams.distId0 = distId0;
	densityParams.distId1 = distId1;
	densityParams.weights = weights;

	rmpath(genpath('DensityFunctions'));
	rmpath(genpath('lib/minFunc_2012'));

end

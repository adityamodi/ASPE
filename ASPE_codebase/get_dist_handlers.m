function [params,distHandler0,distHandler1,m0,m1] = get_dist_handlers(distId0,distId1)

	% returns matrix of initialisation values and function handler for value and derivative
	% also returns the sizes of parameter vector involved
	% distId - 0 - truncated normal
	% distId - 1 - normal
	% distId - 2 - beta

	addpath(genpath('DensityFunctions'));

	[params0,distHandler0] = getHandler(distId0,0);
	[params1,distHandler1] = getHandler(distId1,1);

	params0 = params0';
	params1 = params1';

	m0 = length(params0);
	m1 = length(params1);

	params = [params0;params1];

	rmpath(genpath('DensityFunctions'));
end
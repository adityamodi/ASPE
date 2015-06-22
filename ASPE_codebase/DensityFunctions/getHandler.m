function [params,distHandler] = getHandler(distId,classId)
	% returns initialised parameters and function handler for the distribution
	% distId - 0 - truncated normal
	% distId - 1 - normal
	% distId - 2 - beta

	if distId == 0
		distHandler = @truncated_normal;
		if classId == 0
			params(1) = 0.2;
			params(2) = 0.2;
		else
			params(1) = 0.80;
			params(2) = 0.2;
		end
	elseif distId == 1
		distHandler = @normal_density;
		if classId == 0
			params(1) = 0.2;
			params(2) = 0.2;
		else
			params(1) = 0.80;
			params(2) = 0.2;
		end
	else
		distHandler = @beta_density;
		if classId == 0
			params(1) = 3;
			params(2) = 5;
		else
			params(1) = 5;
			params(2) = 3;
		end
	end
end
function [params,distHandler] = getHandler(distId,classId)
	% returns initialised parameters and function handler for the distribution
	% distId - 0 - truncated normal
	% distId - 1 - normal
	% distId - 2 - beta

	if distId == 0
		distHandler = @truncated_normal;
		if classId == 0
			params(1) = 0.15;
			params(2) = 0.2;
		else
			params(1) = 0.85;
			params(2) = 0.2;
		end
	elseif distId == 1
		distHandler = @normal_density;
		if classId == 0
			params(1) = 0.15;
			params(2) = 0.2;
		else
			params(1) = 0.85;
			params(2) = 0.2;
		end
	else
		distHandler = @beta_density;
		if classId == 0
			params(1) = 1.5;
			params(2) = 8.5;
		else
			params(1) = 8.5;
			params(2) = 1.5;
		end
	end
end
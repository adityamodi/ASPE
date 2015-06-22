function [samplabels,budget] = initialLabeling(labels,budget,numlabels)
	% gets labels for given number of samples randomly

	samplabels = NaN(length(labels),1);

	indx = randperm(length(labels));
	indx = indx';

	indx = indx(1:numlabels,1);

	samplabels(indx) = labels(indx);
	budget = budget - numlabels;
end
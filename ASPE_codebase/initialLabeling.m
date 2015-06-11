function [samplabels,budget] = initialLabeling(labels,numlabels)
	% gets labels for given number of samples randomly

	samplabels = NaN(length(scores),1);

	indx = randperm(length(scores),1);
	indx = indx(1:numlabels);

	samplabels(indx) = labels(indx);
	budget = budget - numlabels;
end
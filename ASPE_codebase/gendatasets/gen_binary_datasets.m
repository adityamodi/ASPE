function gen_binary_datasets(dataId,varargin)

	% processes unprocessed datasets to return scores for the modified binary classification problems
	% clfId - denotes the type of svm classifier used
	% 1 => linear
	% 2 => C-SVC with 'rbf' kernel
	% 3 => C-SVC with '' kernel
	% model selected according to criteria given
	% 1 => AUC
	% 2 => accuracy
	% 3 => f-measure
	addpath(genpath('gendatasets'));
	base = 'C:\Users\t-admodi\oneDrive\OneDrive - Microsoft\aspE_all\aspe_codebase';
	datadir = dir([base '/data/']);
	[labels,tdata] = libsvmread([base '/data/' datadir(dataId).name]);
	numlabels = max(labels);
	rand('seed',123456);
	nlabels = randperm(numlabels);
	newlabels = double(ismember(labels,nlabels(1:numlabels/2)));
	labels = newlabels;
	save([base '/data/binary_' datadir(dataId).name '.mat'],'tdata','labels');
end
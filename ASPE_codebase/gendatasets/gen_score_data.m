function gen_score_data(dataId,clfId,C,varargin)

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
	datadir = dir([base '/data/binary*']);
	load([base '/data/' datadir(dataId).name]);
	data = [tdata labels];
	data = data(randperm(size(data,1)),:);
	train = data(1:ceil(0.6*size(data,1)),1:size(tdata,2));
	train_label = data(1:ceil(0.6*size(data,1)),size(tdata,2)+1);
	test = data(ceil(0.6*size(data,1))+1:end,1:size(tdata,2));
	test_label = data(ceil(0.6*size(data,1))+1:end,size(tdata,2)+1);

	if clfId ~= 1
		gammav = varargin{1};
		gammav = [gammav 1/size(tdata,2)];
	end

	weights = [0 , 1];

	if clfId == 1

		accuracy = zeros(length(C),length(weights));
		AUROC = zeros(length(C),length(weights));
		f_measure = zeros(length(C),length(weights));

		for i=1:length(C)
			for j=1:length(weights)
				params.C = C(i);
				params.weight = weights(j);
				[accuracy(i,j),AUROC(i,j),f_measure(i,j)] = crossvalf(train,train_label,clfId,params);
			end
		end

		[max_acc,max_accuracy_ind] = max(accuracy(:));[max_auroc,max_auroc_ind] = max(AUROC(:));[max_fmeas,max_f_measure_ind] = max(f_measure(:));
		params.clfId = 1;
		fprintf('Parameters found\n\n');
		for selectId=1:3
			switch selectId
				case 1
					[i,j] = ind2sub(size(AUROC),max_auroc_ind);
					params.C = C(i);
					params.weight = weights(j);
					params
					fprintf('Calculating scores for max auroc.\n');
					test_scores_AUROC = svmgetscores(train,train_label,test,test_label,params);
				case 2
					[i,j] = ind2sub(size(accuracy),max_accuracy_ind);
					params.C = C(i);
					params.weight = weights(j);
					params
					fprintf('Calculating scores for max accuracy.\n');
					test_scores_acc = svmgetscores(train,train_label,test,test_label,params);
				case 3
					[i,j] = ind2sub(size(f_measure),max_f_measure_ind);
					params.C = C(i);
					params.weight = weights(j);
					params
					fprintf('Calculating scores for max fmeas.\n');
					test_scores_fmeas = svmgetscores(train,train_label,test,test_label,params);
			end
		end
	end

	if clfId == 2

		accuracy = zeros(length(C),length(weights),length(gammav));
		AUROC = zeros(length(C),length(weights),length(gammav));
		f_measure = zeros(length(C),length(weights),length(gammav));

		for i=1:length(C)
			for j=1:length(weights)
				for k=1:length(gammav)
					params.C = C(i);
					params.weight = weights(j);
					params.g = gammav(k);
					[accuracy(i,j),AUROC(i,j),f_measure(i,j)] = crossvalf(train,train_label,clfId,params);
				end
			end
		end

		[~,max_accuracy_ind] = max(accuracy(:));[~,max_auroc_ind] = max(accuracy(:));[~,max_f_measure_ind] = max(accuracy(:));
		params.clfId = 2;
		fprintf('Parameters found\n\n');
		for selectId=1:3
			switch selectId
				case 1
					[i,j,k] = ind2sub(size(AUROC),max_auroc_ind);
					params.C = C(i);
					params.weight = weights(j);
					params.g = gammav(k);
					fprintf('Calculating scores for max auroc.\n');
					test_scores_AUROC = svmgetscores(train,train_label,test,test_label,params);
				case 2
					[i,j,k] = ind2sub(size(accuracy),max_accuracy_ind);
					params.C = C(i);
					params.weight = weights(j);
					params.g = gammav(k);
					fprintf('Calculating scores for max accuracy.\n');
					test_scores_acc = svmgetscores(train,train_label,test,test_label,params);
				case 3
					[i,j,k] = ind2sub(size(f_measure),max_f_measure_ind);
					params.C = C(i);
					params.weight = weights(j);
					params.g = gammav(k);
					fprintf('Calculating scores for max fmeas.\n');
					test_scores_fmeas = svmgetscores(train,train_label,test,test_label,params);
			end
		end
	end

	fprintf('Saving data into file.\n');
	save(['data_processed/' strrep(datadir(dataId).name,'.mat','') '_' num2str(clfId) '.mat'] , 'test', 'test_label', 'test_scores_AUROC', 'test_scores_acc',...
	 'test_scores_fmeas', 'train', 'train_label', 'max_auroc','max_fmeas','max_acc');
end
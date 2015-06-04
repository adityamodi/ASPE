function [acc,auroc,fmeas] = crossvalf(traind,train_label,clfId,params)
	train_label = double(train_label);
	train_label(train_label==0)=-1;
	ind = randperm(length(train_label));
	len = int32(length(train_label)/5);
	%indices = crossvalind('Kfold',train_label,5);
	c = params.C;
	acct = double(zeros(5,1));
	auroct = double(zeros(5,1));
	fmeast = double(zeros(5,1));
	for i=1:5
		test = ind((i-1)*len+1:min(length(train_label),i*len));
		%indices
		%test = (indices == i);traindcv = ~test;
		traindcv = setdiff([1:length(train_label)],test);
		label = train_label(traindcv,:);
		label = full(label); 
		tlabel = train_label(test,:);
		tlabel = full(tlabel);
		if params.weight == 1
			w1 = sum(label==-1)/sum(label==1);
			w0 = 1;
		else
			w1 = 1;
			w0 = 1;
		end
		if clfId == 1
			addpath(genpath('lib/liblinear-1.96'));

			model = train(label,traind(traindcv,:),['-c ' num2str(c) ' -w1 ' num2str(w1) ' w-1 ' num2str(w0) ' -b 1 -B 1 -q']);
			[labels,acctq,scores] = predict(tlabel,traind(test,:),model);
			acct(i) = acctq(1);
			size(scores)
			[X,Y,T,auroct(i)] = perfcurve(tlabel,scores,1);
			%plot(X,Y);
			prec = double(sum(tlabel==1 & labels==1))/double(sum(labels==1));
			recall = double(sum(tlabel==1 & labels==1))/double(sum(tlabel==1));
			fmeast(i) = (2*prec*recall)/(prec+recall);

			rmpath(genpath('lib/liblinear-1.96'));
		end
		if clfId == 2
			addpath(genpath('lib/libsvm-3.20'));
			size(traind(traindcv,:))
			size(label)
			model = svmtrain(label,traind(traindcv,:),['-c ' num2str(c) ' -w1 ' num2str(w1) ' w-1 ' num2str(w0) ' -g ' num2str(params.g) ' -b 1 -q']);
			[labels,acctq,scores] = svmpredict(tlabel,traind(test,:),model);
			size(scores)
			acct(i) = acctq(1);
			[X,Y,T,auroct(i)] = perfcurve(tlabel,scores,1);
			plot(X,Y);
			prec = double(sum(tlabel==1 & labels==1))/double(sum(labels==1));
			recall = double(sum(tlabel==1 & labels==1))/double(sum(tlabel==1));
			fmeast(i) = (2*prec*recall)/(prec+recall);

			rmpath(genpath('lib/libsvm-3.20'));
		end
	end
	acc = mean(acct);
	auroc = mean(auroct);
	fmeas = mean(fmeast);
	fprintf('Cross validation completed.\nResults found are : acc = %f , auroc = %f , fmeas = %f\n\n',acc,auroc,fmeas);
end
function scores = svmgetscores(traind,label,test,test_label,params)
	if params.weight == 1
		w1 = double(sum(label==0))/double(sum(label==1));
		w0 = 1;
	else
		w1 = 1;
		w0 = 1;
	end
	label(label==0)=-1;
	test_label(test_label==0)=-1;
	test_label
	%traind = full(traind);
	label = full(label);
	%test = full(test);
	test_label = full(test_label);
	if params.clfId == 1
		addpath(genpath('lib/liblinear-1.96'));
		model = train(label, traind, ['-s 0 -c ' num2str(params.C) ' -w1 ' num2str(w1) ' w-1 ' num2str(w0) ' -B 1 -q']);
		[l,~,scores] = predict(test_label,test,model,'-b 1');
		l
		%scores = zeros(length(test_label),1);
		rmpath(genpath('lib/liblinear-1.96'));
	elseif params.clfId == 2
		addpath(genpath('lib/libsvm-3.20'));
		model = svmtrain(label,traind,['-c ' num2str(params.C) ' -w1 ' num2str(w1) ' w-1 ' num2str(w0) ' -b 1 -q -g ' num2str(params.g)]);
		[~,~,scores] = svmpredict(test_label,test,model);
		rmpath(genpath('lib/libsvm-3.20'));
	end
end
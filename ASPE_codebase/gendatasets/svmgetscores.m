function scores = svmgetscores(traind,label,test,test_label,params)
	fprintf('Entered here.\n');
	size(traind)
	size(label)
	size(test)
	size(test_label)
	pause
	if params.weight == 1
		w1 = double(sum(label==0))/double(sum(label==1));
		w0 = 1;
	else
		w1 = 1;
		w0 = 1;
	end
	fprintf('huh\?\n');
	pause
	label(label==0)=-1;
	test_label(test_label==0)=-1;
	%traind = full(traind);
	%label = full(label);
	%test = full(test);
	%test_label = full(test_label);
	fprintf('Here\n');
	if params.clfId == 1
		addpath(genpath('lib/liblinear-1.96'));
		%model = train(label, traind, ['-c ' num2str(params.C) ' -w1 ' num2str(w1) ' w-1 ' num2str(w0) ' -b 1 -B 1 -q']);
		%[~,~,scores] = predict(test_label,test,model);
		scores = zeros(length(test_label),1);
		rmpath(genpath('lib/liblinear-1.96'));
	elseif params.clfId == 2
		addpath(genpath('lib/libsvm-3.20'));
		model = svmtrain(label,traind,['-c ' num2str(params.C) ' -w1 ' num2str(w1) ' w-1 ' num2str(w0) ' -b 1 -q -g ' num2str(params.g)]);
		[~,~,scores] = svmpredict(test_label,test,model);
		rmpath(genpath('lib/libsvm-3.20'));
	end
end
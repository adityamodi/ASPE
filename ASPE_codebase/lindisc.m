function main()
[train,test] = createdata();
size(train)
scores = returnsvmscores(train,test);
scores
hist(scores(:,1),100);
end

function Xs = standardize(X)
len = size(X,1);
mean = sum(X)/len;
mean2 = sum(X.^2)/len;
stddev = sqrt(mean2 - mean.^2);
Xs = (X - ones(len,1)*mean)./(ones(len,1)*stddev);
end

function scores = returnsvmscores(train,test)
cd C:\Users\t-admodi\Downloads;
addpath('C:\Users\t-admodi\Downloads\MAT_libraries\libsvm-3.20\matlab\');
traind = train(1:6000,1:size(train,2)-1);
trainlabel = train(1:6000,size(train,2));
size(trainlabel)
testd = test(:,1:size(test,2)-1);
testlabel = test(:,size(test,2));
model = svmtrain(trainlabel,traind,'-t 0 -b 1 -c 1');
model
[predict_label,accuracy,scores] = svmpredict(testlabel,testd,model,'-b 1');
scores = scores(:,1);
scores = scores-min(scores)+1e-4;
scores = scores./(max(scores)+1e-4);
%predict_label
end

function [train,test] = createdata()
cd C:\Users\t-admodi\Downloads;
addpath('C:\Users\t-admodi\Downloads\MAT_libraries\libsvm-3.20\matlab\');
mnist = load('-mat','mnist_all.mat');
train4 = [mnist.train4];
train9 = [mnist.train9];
label = [ones(length(train4),1) ; -1*ones(length(train9),1)];
train = [train4 ; train9];
train = double(train);
temp = [train label];
train = temp(randperm(length(temp)),:);
test = double([mnist.test4 ones(length(mnist.test4),1); mnist.test9 -1*ones(length(mnist.test9),1)]);
end
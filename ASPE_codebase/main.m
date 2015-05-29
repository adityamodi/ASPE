[train,test] = createdata();
scores = returnsvmscores(train,test);
histogram(scores);
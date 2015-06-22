function plotcurves(scores,labels,densityparameters)

	pos_scores = scores(labels==1);
	neg_scores = scores(labels==0);

	[n1,c1] = hist(pos_scores,100);
	dx = diff(c1(1:2));
	bar(c1,n1/sum(n1*dx),'b');
	hold on;
	[n1,c1] = hist(neg_scores,100);
	dx = diff(c1(1:2));
	bar(c1,n1/sum(n1*dx),'r');
	
	distId0 = densityparameters.distId0;
	distId1 = densityparameters.distId1;

	weights = densityparameters.weights;

	x = 0:0.01:1;

	p1 = densityparameters.weights(1);
	p0 = 1-p1;

	if distId0 == 0
		pd = makedist('normal',weights(2),weights(3));
		pd = truncate(pd,0,1);
		pdd = pdf(pd,x);
		plot(x,p0*pdd,'r','Linewidth',2);
	elseif distId0 == 1
		pd = makedist('normal',weights(2),weights(3));
		pdd = pdf(pd,x);
		plot(x,p0*pdd,'r','Linewidth',2);
	else
		pd = makedist('beta',weights(2),weights(3));
		pdd = pdf(pd,x);
		plot(x,p0*pdd,'r','Linewidth',2);
	end

	if distId1 == 0
		pd = makedist('normal',weights(4),weights(5));
		pd = truncate(pd,0,1);
		pdd = pdf(pd,x);
		plot(x,p1*pdd,'b','Linewidth',2);
	elseif distId1 == 1
		pd = makedist('normal',weights(4),weights(5));
		pdd = pdf(pd,x);
		plot(x,p1*pdd,'b','Linewidth',2);
	else
		pd = makedist('beta',weights(4),weights(5));
		pdd = pdf(pd,x);
		plot(x,p1*pdd,'b','Linewidth',2);
	end

	pause;
end
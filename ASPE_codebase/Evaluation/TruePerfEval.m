function TruePerf = TruePerfEval(scores,labels)

	% returns the vectors of precision and recall for different values of the score threshold
	% also returns the f-score for all threshold values as well

	thresh = linspace(0,1,25);
	for i=1:25
		currThresh = thresh(i);
		currentPred = double(scores>=currThresh);

		TP = sum(currentPos & labels);
		predPos = sum(currentPos);
		Pos = sum(labels);

		TruePerf.precision(i) = TP/predPos;
		TruePerf.recall(i) = TP/Pos;
		TruePerf.f_meas(i) = 2*precision*recall/(precision+recall);
	end
end
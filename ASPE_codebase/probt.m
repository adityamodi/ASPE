function tnprob = probt( x,m,sd )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tnprob = normpdf(x,m,sd)/(normcdf(1,m,sd) - normcdf(0,m,sd));

end


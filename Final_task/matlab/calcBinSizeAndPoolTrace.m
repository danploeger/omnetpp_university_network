function [nbins, pd, trcCounts, expCounts] = calcBinSizeAndPoolTrace(assumedDist, trace)
%CALCBINSIZEANDPOOLTRACE 
%
%   Calculation of number of equi-distant intervals (nbins).
%   Returns number of bins, probability distribution, 
%   and pooled trace sample data bins and expected value bins

%   Daniel Ploeger, 2016/08/13 13:06:00

%% initial number of intervals 
% (initialized with half the trace length to speed up calculations)
nbins = length(trace)/2;

while 1
    % Probability over interval of expected PDF 
    % (vector of n * p_j, 0 <= j <= nbins)
    bins = 1:nbins;
    trcCounts = histcounts(trace, nbins);
    pd = fitdist(bins', assumedDist, 'Frequency', trcCounts');
    expCounts = sum(trcCounts) * pdf(pd, bins);
    
    % y(5) = No. of intervals with n * p_j < 5
    y5 = sum(lt(expCounts, 5));
    if and(min(expCounts) >= 5*y5/nbins, nbins >= 3)
        break;
    end
    if nbins >= 3
        nbins = nbins - 1;
    else
        error('Error: no valid number of intervals found');
    end
end
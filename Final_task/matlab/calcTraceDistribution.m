function [h, p, mean] = calcTraceDistribution(traceFileName, assumedDist, alpha)
%CALCTRACEDISTRIBUTION 
%   Identifies statistic behaviour of HTTP requests by analysing the
%   recorded traces and validating them with the goodness-of-fit test.
%
%   The returned value h = 0 indicates that chi2gof does not reject the 
%   null hypothesis at the selected significance level.
%
%   The double p is the p-value of the hypothesis test.
%   p is the probability of observing a test statistic as extreme as,
%   or more extreme than, the observed value under the null hypothesis. 
%   Small values of p cast doubt on the validity of the null hypothesis.
%
%   The returned mean value is the mean of the fitted distribution of the
%   HTTP request size, extrapolated to the sample data message size values.

%   Daniel Ploeger, 2016/08/13 13:06:00

%% Set default values
if nargin < 3
    alpha = 0.05;                           % significance level
end
if nargin < 2
    assumedDist = 'Exponential';            % distribution hypothesis
end
if nargin < 1    
    traceFileName = 'trace_10.txt';
end
    trace = traceImport(traceFileName);    % trace file with one trace per line

%% Estimate Distribution
[nbins, pd, trcCounts, expCounts] = calcBinSizeAndPoolTrace(assumedDist, trace);
mean = max(trace) * pd.mean / nbins;

%% Chi-square goodness-of-fit test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chi2gof input arguments  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bins — sample data for the hypothesis test.
% Ctrs — bin centers.
% Frequency — frequency of data values; a vector of nonnegative integer 
%   values that is the same length as the sample data.
% CDF — if CDF is a probability distribution object, the degrees of 
%   freedom account for whether you estimate the parameters using fitdist 
%   or specify them using makedist.
% Expected — expected counts for each bin, specified as the 
%   comma-separated pair of 'Expected' and a vector of nonnegative values.
% NParams — number of estimated parameters used to describe the null 
%   distribution. This value adjusts the degrees of freedom of the test 
%   based on the number of estimated parameters used to compute the cdf 
%   or expected counts. Default is 0 (if 'Expected' is specified).
%   For Poisson we expect 1 parameter.
% Alpha — significance level.

[h,p] = chi2gof(trcCounts, 'CDF', pd, 'Alpha', alpha);
                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chi2gof output arguments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The returned value h = 0 indicates that chi2gof does not reject the 
% null hypothesis at the selected significance level.

% The double p is the p-value of the hypothesis test.
% p is the probability of observing a test statistic as extreme as,
% or more extreme than, the observed value under the null hypothesis. 
% Small values of p cast doubt on the validity of the null hypothesis.

% Struct st:
% chi2stat — Value of the test statistic.
% df — Degrees of freedom of the test.
% edges — Vector of bin edges after pooling.
% O — Vector of observed counts for each bin.
% E — Vector of expected counts for each bin.

%% Plot
figure
smplPlot = subplot(3,1,1); % top subplot: trace plot
histPlot = subplot(3,1,2); % middle subplot: histogram plot
diffPlot = subplot(3,1,3); % bottom subplot: fitted distribution

smplPlotRange = linspace (min(trace), max(trace), length(trace));
hst = hist(trace, smplPlotRange);
plot(smplPlot, smplPlotRange, hst', 'b')
title(smplPlot, 'Trace Sample Data')
xlabel(smplPlot, 'Message size (bytes)')
ylabel(smplPlot, 'Messages')

histCounts = [trcCounts', expCounts'];
m = bar(histPlot, histCounts, 1);
title(histPlot, 'Sample Data (blue) and Expected Exponential Distribution (red)')
xlabel(histPlot, 'Bin number (between min and max of message size)')
ylabel(histPlot, 'Sum of messages')
m(1).FaceColor = 'b';
m(2).FaceColor = 'r';

bar(diffPlot, (trcCounts' - expCounts').^2, 1, 'k')
title(diffPlot, 'Difference Between Sample Data and Expected Values')
xlabel(diffPlot, 'Bin number (between min and max of message size)')
ylabel(diffPlot, 'Squared difference')
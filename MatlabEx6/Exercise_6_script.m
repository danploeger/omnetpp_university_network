% Import sim-results as column vector 'packetsec'. 
% If sim-results come in a row vector, uncomment following line:
% packetsec = packetsec';

significance_level = 0.05;
nbins = 20; % number of intervals
bins = 1:nbins;

% Probability over interval of expected PDF
packet_intervals = histcounts(packetsec, nbins);
n = sum(packet_intervals);

pd = fitdist(bins', 'Poisson', 'Frequency', packet_intervals');
expected_packets = n* pdf(pd, bins);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chi2gof input arguments  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bins — sample data for the hypothesis test.
% Ctrs — bin centers.
% Frequency — frequency of data values a vector of nonnegative integer 
%   values that is the same length as the sample data.
% Expected — expected counts for each bin, specified as the 
%   comma-separated pair of 'Expected' and a vector of nonnegative values.
% NParams — number of estimated parameters used to describe the null 
%   distribution. This value adjusts the degrees of freedom of the test 
%   based on the number of estimated parameters used to compute the cdf 
%   or expected counts. Default is 0 (if 'Expected' is specified).
%   For the Poisson we expect 1 parameter.
% Alpha — significance level.

[h,p,st] = chi2gof(bins, 'Ctrs', bins, ...
                         'Frequency', packet_intervals, ...
                         'Expected', expected_packets, ...
                         'NParams', 1, ...
                         'Alpha', significance_level);
                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chi2gof output arguments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The returned value h = 0 indicates that chi2gof does not reject the 
% null hypothesis at the default 5% significance level.

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


% Plot
figure
smpl_plot = subplot(3,1,1); % top subplot: sample data plot
hist_plot = subplot(3,1,2); % middle subplot: histogram plot
fttd_plot = subplot(3,1,3); % bottom subplot: fitted distribution
smpl_plot_range = linspace (50, 150, 100);
hist_plot_range = linspace (0, nbins, nbins);
fttd_plot_range = linspace (0, length(expected_packets), length(expected_packets));

hst = hist(packetsec, smpl_plot_range);
plot(smpl_plot, smpl_plot_range, hst')
title(smpl_plot, 'sample data')

plot(hist_plot, hist_plot_range, packet_intervals')
title(hist_plot, 'histogram plot')

plot(fttd_plot, fttd_plot_range, expected_packets')
title(fttd_plot, 'fitted distribution (expected counts)')
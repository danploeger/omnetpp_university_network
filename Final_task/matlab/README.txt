##########################################################################
## Calculate the distribution of file sizes from given trace statistics ##
##########################################################################

[h, p, mean] = calcTraceDistribution(traceFileName, assumedDist, alpha)

traceFileName = @default: 'trace_10.txt'	% trace file with one trace per line
assumedDist = @default: 'Exponential'		% distribution hypothesis
alpha = @default: 0.05						% significance level


##########################################################################
##       Calculate the QoS of the network and plot everything		    ##
##########################################################################

calcPacketLossCi(maxNumberHttpUser, cctvOn, repeat)


repeat = @default: 10            % Number of simulation runs with different seed
cctvOn = @default: 1			 % choose the CCTV camera to be on or off
maxNumberHttpUser = @default: 13 % number of users for which simulation results exist

Note: simulation result paths have to be adjusted in: 
qos.m (variable resultPath, and if the precalculated results in folder "qos" shall be used, the variable resultFileName needs to be right, too)
importVec.m, importSca.m (variable path, only if NO precalculated results exist in the subfoldder "qos" and if vector and scalar results are available)
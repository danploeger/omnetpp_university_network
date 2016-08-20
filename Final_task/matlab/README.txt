##########################################################################
##                                HOWTO                                 ##
##########################################################################


##########################################################################
## Calculate the distribution of file sizes from given trace statistics ##
##########################################################################

[h, p, mean] = calcTraceDistribution(traceFileName, assumedDist, alpha)

traceFileName = @default: 'trace_10.txt'	% trace file with one trace per line
assumedDist = @default: 'Exponential'		% distribution hypothesis
alpha = @default: 0.05						% significance level


##########################################################################
##             Calculate the QoS of the network 				        ##
##########################################################################

[videoConfDownload, videoConfUpload, cctv] = qos(...
        folderName, ...
        cctvOn, ...
        repeat, ...
        acceptableDelay, ...
        warmupPeriod))
		
		
folderName = @default: '10on';		% subfolder name within the script folder
warmupPeriod = @default: 5;	
acceptableDelay = @default: 0.1;	% 100 ms delay
repeat = @default: 10;            	% Number of simulation runs with different seed
cctvOn = @default: 1;	

Note: needs to have the following *.csv files within the specified folder
/qos/[folderName]/

CCTV_sentPkSum.csv
ccTVMonitoringHost_endToEndDelay-1.csv
...
ccTVMonitoringHost_endToEndDelay-[repeat].csv
ccTVMonitoringHost_rcvdPkSum.csv
profLaptop_rcvdPkLifetime-1.csv
...
profLaptop_rcvdPkLifetime-[repeat].csv
profLaptop_rcvdPkSum.csv
profLaptop_sentPkSum.csv
whostVideoConf_rcvdPkLifetime-1.csv
...
whostVideoConf_rcvdPkLifetime-[repeat].csv
whostVideoConf_rcvdPkSum.csv
whostVideoConf_sentPkSum.csv
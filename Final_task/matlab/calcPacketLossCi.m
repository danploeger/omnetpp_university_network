function calcPacketLossCi(maxNumberHttpUser, cctvOn, repeat)
%CALCPACKETLOSSCI Summary of this function goes here
%   Detailed explanation goes here

%   Daniel Ploeger, 2016/08/20 17:57:00
    
    %% Initialize variables.
    if nargin < 3 
        repeat = 10;            % Number of simulation runs with different seed
    end
    if nargin < 2
        cctvOn = 1;
    end
    if nargin < 1
        maxNumberHttpUser = 15;
    end
    
    warmupPeriod = 5;
    acceptableDelay = 0.1;  % 100 ms delay
%     if cctvOn == 1
%         cctvPath = 'on';
%     else 
%         cctvPath = 'off';
%     end
    
    %% Loop over number of HTTP user
    videoConfDownload = cell(1,maxNumberHttpUser + 1);
    videoConfUpload = cell(1,maxNumberHttpUser + 1);
    cctv = cell(1,maxNumberHttpUser + 1);
    for i = 1 : maxNumberHttpUser + 1
%         if i - 1 < 10
%             path = strcat('0', num2str(i - 1), cctvPath);
%         else
%             path = strcat(num2str(i - 1), cctvPath);
%         end
        [videoConfDownload{i}, videoConfUpload{i}, cctv{i}] = qos(...
            i - 1, ...
            cctvOn, ...
            repeat, ...
            acceptableDelay, ...
            warmupPeriod);
    end
    
    
    %% Calculate confidence intervals
    videoConfDownloadCiLower(1:maxNumberHttpUser + 1) = double(NaN);
    videoConfDownloadCiHigher(1:maxNumberHttpUser + 1) = double(NaN);
    videoConfDownloadMean(1:maxNumberHttpUser + 1) = double(NaN);
    
    videoConfUploadCiLower(1:maxNumberHttpUser + 1) = double(NaN);
    videoConfUploadCiHigher(1:maxNumberHttpUser + 1) = double(NaN);
    videoConfUploadMean(1:maxNumberHttpUser + 1) = double(NaN);
    
    cctvCiLower(1:maxNumberHttpUser + 1) = double(NaN);
    cctvCiHigher(1:maxNumberHttpUser + 1) = double(NaN);
    cctvMean(1:maxNumberHttpUser + 1) = double(NaN);
    for i = 1:maxNumberHttpUser + 1
        [videoConfDownloadCiLower(i),videoConfDownloadCiHigher(i)] = confint2( ...
            videoConfDownload{i}.videoConfDownloadLossRate, str2double(i));
        videoConfDownloadMean(i) = mean(videoConfDownload{i}.videoConfDownloadLossRate);
        
        [videoConfUploadCiLower(i),videoConfUploadCiHigher(i)] = confint2( ...
            videoConfUpload{i}.videoConfUploadLossRate, str2double(i));
        videoConfUploadMean(i) = mean(videoConfUpload{i}.videoConfUploadLossRate);
        
        [cctvCiLower(i),cctvCiHigher(i)] = confint2( ...
            cctv{i}.cctvLossRate, str2double(i));
        cctvMean(i) = mean(cctv{i}.cctvLossRate);
    end
    
    %% Plot
    figure(1);
    for i = 1:maxNumberHttpUser + 1
        j = i - 1;
        plot([j j], [videoConfDownloadCiLower(i) videoConfDownloadCiHigher(i)], 'r', ...
            j, videoConfDownloadMean(i), 'xb');
        hold on
    end
    legend('Confidence interval', 'Mean')
    title(strcat('Confidence Intervals and Mean Values of the Video Conference Download for ', repeat, ' Runs'))
    xlabel('Number of HTTP users web browsing simultaneously')
    ylabel('Packet Loss Rate')
    plotUpperBound = maxNumberHttpUser + 1;
    set(figure(1), 'XLim', [0 plotUpperBound]);
    
    figure(2);
    for i = 1:maxNumberHttpUser + 1
        j = i - 1;
        plot([j j], [videoConfUploadCiLower(i) videoConfUploadCiHigher(i)], 'r', ...
            j, videoConfUploadMean(i), 'xb');
        hold on
    end
    legend('Confidence interval', 'Mean')
    title(strcat('Confidence Intervals and Mean Values of the Video Conference Upload for ', repeat, ' Runs'))
    xlabel('Number of HTTP users web browsing simultaneously')
    ylabel('Packet Loss Rate')
    
    figure(3);
    for i = 1:maxNumberHttpUser + 1
        j = i - 1;
        plot([j j], [cctvCiLower(i) cctvCiHigher(i)], 'r', ...
            j, cctvMean(i), 'xb');
        hold on
    end
    legend('Confidence interval', 'Mean')
    title(strcat('Confidence Intervals and Mean Values of the CCTV camera for ', repeat, ' Runs'))
    xlabel('Number of HTTP users web browsing simultaneously')
    ylabel('Packet Loss Rate')
end
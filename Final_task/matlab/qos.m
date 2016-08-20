function [videoConfDownload, videoConfUpload, cctv] = qos(...
        folderName, ...
        cctvOn, ...
        repeat, ...
        acceptableDelay)
    %QoSCALCULATION
    %

    %   Daniel Ploeger, 2016/08/19 17:09:00

    %% Initialize variables.
    if nargin < 2
        acceptableDelay = 0.1;  % 100 ms delay
        repeat = 10;            % Number of simulation runs with different seed
        cctvOn = 1;
    end
    if nargin < 1
        folderName = '10on';
    end

    %% Data Import
    path = strcat('qos/', folderName, '/');

    videoConfSimTime = cell(repeat,1);
    videoConfE2eDelay = cell(repeat,1);
    for i = 1:repeat
        [videoConfSimTime{i}, videoConfE2eDelay{i}] = ...
            rcvdPkLifetimeVectorImport(strcat(path, 'whostVideoConf_rcvdPkLifetime-', num2str(i), '.csv'));
    end
    profLaptopSimTime = cell(repeat,1);
    profLaptopE2eDelay = cell(repeat,1);
    for i = 1:repeat
        [profLaptopSimTime{i}, profLaptopE2eDelay{i}] = ...
            rcvdPkLifetimeVectorImport(strcat(path, 'profLaptop_rcvdPkLifetime-', num2str(i), '.csv'));
    end
    if cctvOn == 1
        cctvSimTime = cell(repeat,1);
        cctvE2eDelay = cell(repeat,1);
        for i = 1:repeat
            [cctvSimTime{i}, cctvE2eDelay{i}] = ...
                rcvdPkLifetimeVectorImport(strcat(path, 'ccTVMonitoringHost_endToEndDelay-', num2str(i), '.csv'));
        end        
    end

    [~, profLaptopRcvdPkSum] = importPkSum(...
        strcat(path, 'profLaptop_rcvdPkSum.csv'));
    [~, profLaptopSentPkSum] = importPkSum(...
        strcat(path, 'profLaptop_sentPkSum.csv'));
    [~, whostVideoConfRcvdPkSum] = importPkSum(...
        strcat(path, 'whostVideoConf_rcvdPkSum.csv'));
    [~, whostVideoConfSentPkSum] = importPkSum(...
        strcat(path, 'whostVideoConf_sentPkSum.csv'));
    if cctvOn == 1
        [~, cctvSentPkSum] = importPkSum(...
            strcat(path, 'CCTV_sentPkSum.csv'));
        [~, cctvMonitoringHostRcvdPkSum] = importPkSum(...
            strcat(path, 'ccTVMonitoringHost_rcvdPkSum.csv'));
    end

    %% Delay download profLaptop -> whostVideoConf
    [videoConfDownloadExceededDelayRate, videoConfDownloadAvgDelay] = calcDelay(...
        repeat, videoConfE2eDelay, acceptableDelay);

    %% Delay upload whostVideoConf -> profLaptop
    [videoConfUploadExceededDelayRate, videoConfUploadAvgDelay] = calcDelay(...
        repeat, profLaptopE2eDelay, acceptableDelay);
    
    %% Delay CCTV
    if cctvOn == 1
    [cctvExceededDelayRate, cctvAvgDelay] = calcDelay(...
        repeat, cctvE2eDelay, acceptableDelay);        
    else
        cctvExceededDelayRate = double(NaN);
        cctvAvgDelay = double(NaN);
    end
    
    %% Nested function for delay calculation
    function [exceededDelayRate, avgDelay] = calcDelay(repeat, e2eDelayData, acceptableDelay)
        exceededDelayRate(1:repeat) = double(NaN);
        avgDelay(1:repeat) = double(NaN);
        for j = 1:repeat
            avgDelay(j) = mean(e2eDelayData{j});
            delayVector = e2eDelayData{j};
            exceededDelays = zeros(1,repeat);
            for delay = delayVector
                if delay > acceptableDelay
                    exceededDelays(j) = exceededDelays(j) + 1;
                end
            end
            exceededDelayRate(j) = exceededDelays(j) / length(e2eDelayData{j});
        end
    end

    %% Drops download profLaptop -> whostVideoConf
    videoConfDownloadDroppedPacketRate = calcDroppedPacketRate(...
        repeat, profLaptopSentPkSum, videoConfDownloadAvgDelay, videoConfSimTime, whostVideoConfRcvdPkSum);
    
    %% Drops upload whostVideoConf -> profLaptop
    videoConfUploadDroppedPacketRate = calcDroppedPacketRate(...
        repeat, whostVideoConfSentPkSum, videoConfUploadAvgDelay, profLaptopSimTime, profLaptopRcvdPkSum);
    
    %% Drops CCTV
    if cctvOn == 1
    cctvDroppedPacketRate = calcDroppedPacketRate(...
        repeat, cctvSentPkSum, cctvAvgDelay, cctvSimTime, cctvMonitoringHostRcvdPkSum);     
    else
        cctvDroppedPacketRate = double(NaN);
    end
    
    %% Nested function for packet drop calculation
    function droppedPacketRate = calcDroppedPacketRate(repeat, sentPkSum, avgDelay, simTime, rcvdPkSum)
        sentPkPerPkLifetime(1:repeat) = double(NaN);
        droppedPacketRate(1:repeat) = double(NaN);
        for j = 1:repeat
            % Subtract packets still in the pipeline at sim-time end
            sentPkPerPkLifetime(j) = sentPkSum(j) * avgDelay(j) / max(simTime{j}); 
            droppedPacketRate(j) = (sentPkSum(j) - rcvdPkSum(j) - sentPkPerPkLifetime(j)) ...
                / sentPkSum(j);
        end
    end
%     %% Drops download profLaptop -> whostVideoConf
%     function droppedPacketRate = calcDroppedPacketRate(repeat, profLaptopSentPkSum, avgDelay, videoConfSimTime, whostVideoConfRcvdPkSum)
%         sentPkPerPkLifetime(1:repeat) = double(Inf);
%         droppedPacketRate(1:repeat) = double(Inf);
%         for j = 1:repeat
%             % Subtract packets still in the pipeline at sim-time end
%             sentPkPerPkLifetime(j) = profLaptopSentPkSum(j) * avgDelay(j) / max(videoConfSimTime{j}); 
%             droppedPacketRate(j) = (profLaptopSentPkSum(j) - whostVideoConfRcvdPkSum(j) - sentPkPerPkLifetime(j)) ...
%                 / profLaptopSentPkSum(j);
%         end
%     end

    %% Sum up
    videoConfDownloadLossRate(1:repeat) = double(NaN);
    for i = 1:repeat
        videoConfDownloadLossRate(i) = videoConfDownloadExceededDelayRate(i) + videoConfDownloadDroppedPacketRate(i);
    end
    videoConfUploadLossRate(1:repeat) = double(NaN);
    for i = 1:repeat
        videoConfUploadLossRate(i) = videoConfUploadExceededDelayRate(i) + videoConfUploadDroppedPacketRate(i);
    end
    if cctvOn == 1
        cctvLossRate(1:repeat) = double(NaN);
        for i = 1:repeat
            cctvLossRate(i) = cctvExceededDelayRate(i) + cctvDroppedPacketRate(i);
        end   
    else
        cctvLossRate = double(NaN);
    end
    videoConfDownload = struct('videoConfDownloadLossRate', videoConfDownloadLossRate, ...
        'videoConfDownloadExceededDelayRate', videoConfDownloadExceededDelayRate, ...
        'videoConfDownloadDroppedPacketRate', videoConfDownloadDroppedPacketRate, ...
        'videoConfDownloadAvgDelay', videoConfDownloadAvgDelay);
    videoConfUpload = struct('videoConfUploadLossRate', videoConfUploadLossRate, ...
        'videoConfUploadExceededDelayRate', videoConfUploadExceededDelayRate, ...
        'videoConfUploadDroppedPacketRate', videoConfUploadDroppedPacketRate, ...
        'videoConfUploadAvgDelay', videoConfUploadAvgDelay);   
    if cctvOn == 1
        cctv = struct('cctvLossRate', cctvLossRate, ...
            'cctvExceededDelayRate', cctvExceededDelayRate, ...
            'cctvDroppedPacketRate', cctvDroppedPacketRate, ...
            'cctvAvgDelay', cctvAvgDelay);
    else
        cctv = struct('cctvLossRate', [], ...
            'cctvExceededDelayRate', [], ...
            'cctvDroppedPacketRate', [], ...
            'cctvAvgDelay', []);
    end
end
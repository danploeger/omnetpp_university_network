function [simTime, value] = importVec(moduleFilter, statisticNameFilter, numberHttpUser, cctvOn, repeat, vecPath)
%IMPORTVEC Summary of this function goes here
%   Detailed explanation goes here
   
%   Daniel Ploeger, 2016/08/19 16:12:00

    %% Initialize variables with default values
    if nargin < 6
        vecPath = 'C:\Users\Daniel\Documents\omnetpp-4.6\exercises\OMNeT_Git\Final_task\_20816results\';
    end
    if nargin < 5
        repeat = 10;            % Number of simulation runs with different seed
    end
    if nargin < 4
        cctvOn = 1;
    end
    if nargin < 3
        numberHttpUser = 0;
    end
    if nargin < 2
        moduleFilter = 'University.ccTVMonitoringHost.udpApp[0]';
        statisticNameFilter = 'endToEndDelay:vector';
    end
    
    if cctvOn == 1
        cctvPath = 'on';
    else 
        cctvPath = 'off';
    end
    
    %% Import
    simTime = cell(repeat, 1);
    value = cell(repeat, 1);
    for i = 1:repeat
        % path needs to be adapted to your personal simulation results
        % folder structure and file names. Currently it works with:
        % [vecPath]\_[on/off][numberHttpUser]\_[on/off][numberHttpUser]-[i].vec
        % where i is the current simulation repetition, and [on/off] is the
        % condition of the CCTV camera. E.g.: [vecPath]\_on0\_on0-0.vec
        path = strcat(vecPath, '_', cctvPath, num2str(numberHttpUser), ...
            '\_', cctvPath, num2str(numberHttpUser), '-', num2str(i - 1), '.vec');
        [controlData, moduleFilterAndEventNumber, statisticNameAndTime, rawValue] = ...
            importRawVec(path);
        [rowCandidate, ~] = find(strcmp(moduleFilterAndEventNumber, moduleFilter));
        row = NaN;
        for j = 1:length(rowCandidate)
            currentRow = rowCandidate(j);
           if strcmp(statisticNameAndTime(currentRow), statisticNameFilter)
               row = currentRow;
           end
        end
            
        vectorNumber = controlData(row, 1);
        vectorNumber = vectorNumber{1};
        vectorNumber = vectorNumber(8:end);
        resultIndices = find(strcmp(controlData, vectorNumber));
        simTime{i} = double(1:length(resultIndices));
        value{i} = double(1:length(resultIndices));
        for j = 1:length(resultIndices)
            currentIndex = resultIndices(j);
            simTime{i}(1, j) = str2double(statisticNameAndTime(currentIndex));
            value{i}(1, j) = str2double(rawValue(currentIndex));
        end
    end
end


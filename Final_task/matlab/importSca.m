function [value] = importSca(moduleFilter, statisticNameFilter, numberHttpUser, cctvOn, repeat, scaPath)
%IMPORTSCA Summary of this function goes here
%   Detailed explanation goes here

%   Daniel Ploeger, 2016/08/21 18:30:00

    %% Initialize variables with default values
    if nargin < 6
        scaPath = 'C:\Users\Daniel\Documents\omnetpp-4.6\exercises\OMNeT_Git\Final_task\_20816results\';
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
        statisticNameFilter = 'rcvdPk:sum(packetBytes)';
    end
    
    if cctvOn == 1
        cctvPath = 'on';
    else 
        cctvPath = 'off';
    end
    
    %% Import
    value = double(1:repeat);
    for i = 1:repeat
        % path needs to be adapted to your personal simulation results
        % folder structure and file names. Currently it works with:
        % [scaPath]\_[on/off][numberHttpUser]\_[on/off][numberHttpUser]-[i].sca
        % where i is the current simulation repetition, and [on/off] is the
        % condition of the CCTV camera. E.g.: [scaPath]\_on0\_on0-0.sca
        path = strcat(scaPath, '_', cctvPath, num2str(numberHttpUser), ...
        '\_', cctvPath, num2str(numberHttpUser), '-', num2str(i - 1), '.sca');
        [moduleFilterList,statisticNameFilterList,valueList] = importRawSca(path);
        fittedModuleFilter = ['scalar '  moduleFilter  ' '];
        [rowCandidate, ~] = find(strcmp(moduleFilterList, fittedModuleFilter));
        row = NaN;
        for j = 1:length(rowCandidate)
            currentRow = rowCandidate(j);
            if strcmp(statisticNameFilterList(currentRow), [statisticNameFilter ' '])
                row = currentRow;
            end
        end
        value(i) = str2double(valueList(row));
    end
    value = value';
end


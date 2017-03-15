% script reads data from original scoring file, extracts the
% classification of the sleep stages per epoch and saves each sleep stage
% as a numeric value:
% wake = 0
% s1 = 1
% s2 = 2
% s3 = 3
% s4 = 4
% rem = 5
%
% author: Stefanie Breuer
% date: 22.02.2017
% -------------------------------------------------------------------------

% path of folder containing scoring data
hypno_path = 'C:\Users\Stefka\Desktop\Masterarbeit\Scoring';
% list all hypnogram files
hypno_listing = dir(hypno_path); %including . and ..
[pathstr,name,ext] = fileparts(hypno_path);

% path of folder containing edf files
edf_path = 'C:\Users\Stefka\Desktop\Masterarbeit\INSOMNIA\';
% list all edf files
edf_listing = dir(edf_path); %including . and ..

% description of sleep stages in scoring data
sleep_stage_W = {'Wach', 'SLEEP-S0'};
sleep_stage_S1 = {'S1', 'SLEEP-S1'};
sleep_stage_S2 = {'S2', 'SLEEP-S2'};
sleep_stage_S3 = {'S3', 'SLEEP-S3'};
sleep_stage_S4 = {'S4', 'SLEEP-S4'};
sleep_stage_R = {'REM', 'SLEEP-REM'};

timestamps = 'C:\Users\Stefka\Desktop\Masterarbeit\timestamps.txt';
%fileIDtimestamps = fopen(timestamps, 'a');


% loop over all hypnogram files
for i = 3:length(hypno_listing)
    
    % extract name of hypnogram file
    hypno_file = hypno_listing(i).name;
    hypno = hypno_file(12:end-4);
    hypno_file = [pathstr, '\', name, '\', hypno_file];
    
    % read scoring file
    T = readtable(hypno_file);
    % create new file to save the sleep stages
    restructured_hypnogram = [hypno_file(1:37), 'Hypnograms', '\', 'Hypnogram_', hypno_file(57:end)];
    fileIDhypnogram = fopen(restructured_hypnogram, 'a');
    
    [row, col] = size(T);
    % loop over table
    for j = 1:row
        
        % extract content of one row and convert each element into one string
        C = table2cell(T(j, col));
        M = cell2mat(C);
        newrow = strsplit(M);
        
        % find row of appearing 'Schlafstadium'
        ss = strcmpi('Schlafstadium', newrow);
        nr_ss = find(ss, 1);
        
        if ~isempty(nr_ss)
            hypnostart = j+1;
            ind_ss = nr_ss;
        end
    end

    
    % extract starttime of hypnogram
    for k = hypnostart:row
        
        % extract content of row k and convert each element into one string
        C = table2cell(T(k, col));
        M = cell2mat(C);
        newrow = strsplit(M);
        
        % find row containing ':' from time specification (like 20:25:10]
        tm = strfind(newrow, ':');
        ind_ev = find(not(cellfun('isempty', tm)))+1;
        
        if (any(ismember(newrow(ind_ss),sleep_stage_W)) && any(ismember(newrow(ind_ev),sleep_stage_W)))
            hypno_starttime = newrow(ind_ev-1);
            break;
        end
    end
    
    % loop over all edf files
    for l = 3:length(edf_listing)
        % extract name of edf file
        edffilename = edf_listing(l).name;
        edffile = [edf_path, edffilename];
        edf = edffilename(1:end-20);
        
        % compare edf and hypno names
        if strcmp(edf, hypno)
            % load EDF
            header = sn_edfScan2matScan('data', edffile);
            % extract starttime of header
            header_starttime = header.recording_starttime;
            header_starttime_cell = cellstr(header_starttime);
            % calculate elapsed seconds between header starttime and hypnogram
            % starttime
            [t, durationsecs] = subtract_timestrings(header_starttime_cell, hypno_starttime);
            % add elapsed seconds to header starttime and return the time stamp as
            % a string
            %timestr = addsec2time(header_starttime, durationsecs);

            % compare the new time stamp with the hypnogram starttime
            %if strcmp(timestr, hypno_starttime)
                %fprintf(fileIDtimestamps, '%s %s \r\n', hypno_file(end-12:end-4), 'timestamps okay');
                %fprintf(fileIDtimestamps, '%s %s \r\n', 'edf starttime + elapsed time = ', timestr);
                %fprintf(fileIDtimestamps, '%s %s\r\n',  'hypnogram starttime =          ', cell2mat(hypno_starttime));
            %else
                %fprintf(fileIDtimestamps, '%s %s \r\n', hypno_file(end-12:end-4), 'no');
                %fprintf(fileIDtimestamps, '%s %s\r\n', 'edf starttime + elapsed time = ', timestr);
                %fprintf(fileIDtimestamps, '%s %s\r\n', 'hypnogram starttime =          ', cell2mat(hypno_starttime));
            %end

            %epochs = durationsecs/30;
        end
    end
    
    fprintf(fileIDhypnogram, '%d \r\n', durationsecs);
    
    hypnogram_scoring = [0];
    % loop over table beginning at row hypnostart
    for k = hypnostart:row
        
        % extract content of row k and convert each element into one string
        C = table2cell(T(k, col));
        M = cell2mat(C);
        newrow = strsplit(M);
        
        % find row containing ':' from time specification (like 20:25:10]
        tm = strfind(newrow, ':');
        ind_ev = find(not(cellfun('isempty', tm)))+1;
        
        % compare columns of 'Schlafphase' and 'Ereignis' and write numeric
        % sleep stage into hypnogram text file
        if (any(ismember(newrow(ind_ss),sleep_stage_W)) && any(ismember(newrow(ind_ev),sleep_stage_W)))
            sleepstage = 0;
            hypnogram_scoring(end+1) = sleepstage;
            fprintf(fileIDhypnogram, '%u \r\n', sleepstage);
        elseif (any(ismember(newrow(ind_ss),sleep_stage_S1)) && any(ismember(newrow(ind_ev),sleep_stage_S1)))
            sleepstage = 1;
            hypnogram_scoring(end+1) = sleepstage;
            fprintf(fileIDhypnogram, '%u \r\n', sleepstage);
        elseif (any(ismember(newrow(ind_ss),sleep_stage_S2)) && any(ismember(newrow(ind_ev),sleep_stage_S2)))
            sleepstage = 2;
            hypnogram_scoring(end+1) = sleepstage;
            fprintf(fileIDhypnogram, '%u \r\n', sleepstage);
        elseif (any(ismember(newrow(ind_ss),sleep_stage_S3)) && any(ismember(newrow(ind_ev),sleep_stage_S3)))
            sleepstage = 3;
            hypnogram_scoring(end+1) = sleepstage;
            fprintf(fileIDhypnogram, '%u \r\n', sleepstage);
        elseif (any(ismember(newrow(ind_ss),sleep_stage_S4)) && any(ismember(newrow(ind_ev),sleep_stage_S4)))
            sleepstage = 4;
            hypnogram_scoring(end+1) = sleepstage;
            fprintf(fileIDhypnogram, '%u \r\n', sleepstage);
        elseif (any(ismember(newrow(ind_ss),sleep_stage_R)) && any(ismember(newrow(ind_ev),sleep_stage_R)))
            sleepstage = 5;
            hypnogram_scoring(end+1) = sleepstage;
            fprintf(fileIDhypnogram, '%u \r\n', sleepstage);
        end
    end
    
    
end

fclose('all');



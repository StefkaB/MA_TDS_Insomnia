% script to check if apneas occur more than five times per hour;
% in that case write the hypnogram file into the result text file
%
%% Metadata
% Stefanie Breuer, 28.02.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% folder to save result file
apnea_path = 'C:\Users\Stefka\Desktop\Masterarbeit\';
% folder of scoring files
hypno_path = 'C:\Users\Stefka\Desktop\Masterarbeit\Scoring';

% list all scoring files of folder
hypno_listing = dir(hypno_path); %including . and ..
[pathstr,name,ext] = fileparts(hypno_path);

% define all apnea descriptions and sleep stages
apnea = {'APNEA', 'HYPOPNEA', 'APNEA-CENTRAL', 'APNEA-MIXED', 'APNEA-OBSTRUCTIVE'};
sleep_stages = {'Wach', 'SLEEP-S0', 'S1', 'SLEEP-S1', 'S2', 'SLEEP-S2', ...
    'S3', 'SLEEP-S3', 'S4', 'SLEEP-S4', 'REM', 'SLEEP-REM'};

% create and open file to save apneas
apneafile = [apnea_path, 'Apnea5perhour.txt'];
fileID = fopen(apneafile, 'a');
fprintf(fileID, '%s \r\n', 'Files containing more than five apneas per hour');

% loop over all hypnogram files
for i = 3:length(hypno_listing)
    % extract name of hypnogram
    hypno_file = hypno_listing(i).name;
    hypno_file = [pathstr, '\', name, '\', hypno_file];
    [hypnofilepath, hypnofilename, hypnofileext] = fileparts(hypno_file);
    
    % read hypnogram file into table
    T = readtable(hypno_file);
    [row, col] = size(T);
    
    % loop over table
    for j = 1:row
        % extract content of one row and convert each element into one string
        C = table2cell(T(j, col));
        M = cell2mat(C);
        Mrow = strsplit(M);
        
        % find row containing 'Schlafstadium'
        ss = strcmpi('Schlafstadium', Mrow);
        nr_ss = find(ss, 1);
        
        % define where table of sleep stages begins
        if ~isempty(nr_ss)
            hypnostart = j+1;
            ind_ss = nr_ss;
        end
    end
    
    % extract content of row hypnostart and convert each element into one string
    C = table2cell(T(hypnostart, col));
    M = cell2mat(C);
    Mrow = strsplit(M);

    % find row containing ':' from time specification (like 20:25:10]
    tm = strfind(Mrow, ':');
    ind_ev = find(not(cellfun('isempty', tm)))+1;
   
    % loop over table beginning at row hypnostart
    significance = 0;
    countapnea = 0;
    for k = hypnostart:row
        
        % extract content of row k and convert each element into one string
        C = table2cell(T(k, col));
        M = cell2mat(C);
        Mrow = strsplit(M);
        
        % compare 'Schlafstadium' and 'Ereignis'; count if there is an apnea
        % event and save point of time
        if (any(ismember(Mrow(ind_ss),sleep_stages)) && any(ismember(Mrow(ind_ev),apnea)))
            apnearow = k;
            countapnea = countapnea+1;
            time = Mrow(ind_ev-1);
            
            % loop over the next rows
            for l = apnearow+1:row
                
                % extract content of row l and convert each element into one string
                C = table2cell(T(l, col));
                M = cell2mat(C);
                Mrow = strsplit(M);
                
                % compare 'Schlafstadium' and 'Ereignis'; save point of time
                if (any(ismember(Mrow(ind_ss),sleep_stages)) && any(ismember(Mrow(ind_ev),apnea)))
                    time2 = Mrow(ind_ev-1);
                    % calculate elapsed time between both time stamps
                    [t, durationsecs] = subtract_timestrings(time, time2);
                    % count apnea if elapsed time is <= one hour
                    if t == 1
                        countapnea = countapnea+1;
                    else
                        % count significance if more than five apneas per
                        % hour
                        if countapnea > 5
                            significance = significance + 1;
                            countapnea = 0;
                        end
                        % reset k to next row after first apnea of the
                        % investigated hour
                        k = apnearow+1;
                        % end this loop
                        l = row;
                    end
                end
            end
        end
    end
    
    % if apneas occur more often than five per hour write name of dataset
    % and amount of significance into result file
    if significance > 0
        fprintf(fileID, '%s \r\n', hypnofilename(12:end));
        fprintf(fileID, '%d \r\n', significance);
    end
end


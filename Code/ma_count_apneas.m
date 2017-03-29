% script to count occuring apnea events in hypnogram files
%
%% Metadata
% Stefanie Breuer, 22.02.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% folder to save result file
apnea_path = 'C:\Users\Stefka\Desktop\Masterarbeit\';
% folder of scoring files
hypno_path = 'C:\Users\Stefka\Desktop\Masterarbeit\Scoring';

% list all scoring files in folder
hypno_listing = dir(hypno_path); %including . and ..
[pathstr,name,ext] = fileparts(hypno_path);

% define all apnea descriptions and sleep stages
apnea = {'APNEA', 'HYPOPNEA', 'APNEA-CENTRAL', 'APNEA-MIXED', 'APNEA-OBSTRUCTIVE'};
sleep_stages = {'Wach', 'SLEEP-S0', 'S1', 'SLEEP-S1', 'S2', 'SLEEP-S2', ...
    'S3', 'SLEEP-S3', 'S4', 'SLEEP-S4', 'REM', 'SLEEP-REM'};

% loop over all hypnograms
for i = 3:length(hypno_listing)
    
    % set counter
    count_apnea = 0;
    
    % extract name and build path of hypnogramfile
    hypno_file = hypno_listing(i).name;
    hypno_file = [pathstr, '\', name, '\', hypno_file];
    
    % read scoring file
    T = readtable(hypno_file);
    % create and open file to save apneas
    apneafile = [apnea_path, 'Apnea.txt'];
    fileID = fopen(apneafile, 'a');
    
    [row, col] = size(T);
    % loop over hypnogramfile
    for j = 1:row
        
        % convert data
        C = table2cell(T(j, col));
        M = cell2mat(C);
        newrow = strsplit(M);
        
        % find row containing 'Schlafstadium'
        ss = strcmpi('Schlafstadium', newrow);
        nr_ss = find(ss, 1);
        
        % define where table of sleep stages begins
        if ~isempty(nr_ss)
            hypnostart = j+1;
            ind_ss = nr_ss;
        end
    end
    
    % loop over table in hypnogramfile
    for k = hypnostart:row
        
        % convert data
        C = table2cell(T(k, col));
        M = cell2mat(C);
        newrow = strsplit(M);
        
        % find row containing ':' from time specification (like 20:25:10]
        tm = strfind(newrow, ':');
        ind_ev = find(not(cellfun('isempty', tm)))+1;
        
        % compare 'Schlafstadium' and 'Ereignis'; count if there is an apnea
        % event
        if (any(ismember(newrow(ind_ss),sleep_stages)) && any(ismember(newrow(ind_ev),apnea)))
            count_apnea = count_apnea+1;
        end
        
    end
    
    % save number of occuring apneas into text file
    fprintf(fileID, '%s%s%u \r\n', hypno_file(57:end-4), ':  ', count_apnea);
end

fclose('all');



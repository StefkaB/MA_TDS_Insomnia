% script to check if each hypnogramm contains all sleep stages and every
% sleep stage at least for 2.5 minutes (5 epochs)
%
%% Metadata
% Stefanie Breuer, 26.02.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% folder containing all reconstructed hypnograms (with function
% restructure_hypnogram.m)
hypno_path = 'C:\Users\Stefka\Desktop\Masterarbeit\Hypnograms\';
% list all files
hypno_listing = dir(hypno_path);

% folder to save results
stages_path = 'C:\Users\Stefka\Desktop\Masterarbeit\';
[pathstr,name,ext] = fileparts(hypno_path);
% create and open text file for results of missing sleep stages
stages_file = [pathstr(1:end-11), '\', 'sleep_stages.txt'];
fileIDstages = fopen(stages_file, 'a');
fprintf(fileIDstages, '%s \r\n', 'Files with missing sleep stages:');
% create and open text file for results of consecutive epochs of same sleep
% stage
consec_file = [pathstr(1:end-11), '\', 'consecutive_stages.txt'];
fileIDconsec = fopen(consec_file, 'a');
fprintf(fileIDconsec, '%s \r\n', 'Files with insufficient amount of consecutive epochs of the same sleep stage');

% loop over all hypnogram files
for i = 3:length(hypno_listing)
    
    % extract name and build path of hypnogramfile
    hypnogram = hypno_listing(i).name;
    hypnogramfile = [hypno_path, hypnogram];
    
    % read data from hypnogram file
    T = dlmread(hypnogramfile);
    Tarr = T(2:end);
    
    % set all amounts of sleep stages to zero
    s0 = 0;
    s1 = 0;
    s2 = 0;
    s3 = 0;
    s4 = 0;
    r = 0;
    
    % check if all sleep stages exist
    if ismember(0, Tarr) == 1
        s0 = 1;
    end
    if ismember(1, Tarr) == 1
        s1 = 1;
    end
    if ismember(2, Tarr) == 1
        s2 = 1;
    end
    if ismember(3, Tarr) ==1
        s3 = 1;
    end
    if ismember(4, Tarr) == 1
        s4 = 1;
    end
    if ismember(5, Tarr) == 1
        r = 1;
    end
    
    % if a sleep stage is missing write file name into result text file
    if (s0 == 0 || s1 == 0 || s2 == 0 || s3 == 0 || s4 == 0 || r == 0)
        fprintf(fileIDstages, '%s \r\n', hypnogram);
    end
    
    if s0 == 0
        fprintf(fileIDstages, '%s \r\n', 'missing: S0');
    end
    if s1 == 0
        fprintf(fileIDstages, '%s \r\n', 'missing: S1');
    end
    if s2 == 0
        fprintf(fileIDstages, '%s \r\n', 'missing: S2');
    end
    if s3 == 0
        fprintf(fileIDstages, '%s \r\n', 'missing: S3');
    end
    if s4 == 0
        fprintf(fileIDstages, '%s \r\n', 'missing: S4');
    end
    if r == 0
        fprintf(fileIDstages, '%s \r\n', 'missing: R');
    end
    
    % check if each sleep stage occurs in an apropriate duration of at
    % least five epochs (2.5 minutes)
    countarr = zeros(6, 1);
    for j = 1:length(Tarr)-5
        counts0 = 1;
        counts1 = 1;
        counts2 = 1;
        counts3 = 1;
        counts4 = 1;
        countr = 1;
        
        % check for at least six consecutive epochs of the same sleep stage
        for k = j:j+3
            if Tarr(k) == 0 && Tarr(k) == Tarr(k+1)
                counts0 = counts0 + 1;
                if counts0 == 5
                    countarr(1, end+1) = counts0;
                end
            elseif Tarr(k) == 1 && Tarr(k) == Tarr(k+1)
                counts1 = counts1 + 1;
                if counts1 == 5
                    countarr(2, end+1) = counts1;
                end
            elseif Tarr(k) == 2 && Tarr(k) == Tarr(k+1)
                counts2 = counts2 + 1;
                if counts2 == 5
                    countarr(3, end+1) = counts2;
                end
            elseif Tarr(k) == 3 && Tarr(k) == Tarr(k+1)
                counts3 = counts3 + 1;
                if counts3 == 5
                    countarr(4, end+1) = counts3;
                end
            
            elseif Tarr(k) == 4 && Tarr(k) == Tarr(k+1)
                counts4 = counts4 + 1;
                if counts4 == 5
                    countarr(5, end+1) = counts4;
                end
            
            elseif Tarr(k) == 5 && Tarr(k) == Tarr(k+1)
                countr = countr + 1;
                if countr == 5
                    countarr(6, end+1) = countr;
                end
            end
        end
    end
        
        s0 = countarr(1, 2:end) == 5;
        s1 = countarr(2, 2:end) == 5;
        s2 = countarr(3, 2:end) == 5;
        s3 = countarr(4, 2:end) == 5;
        s4 = countarr(5, 2:end) == 5;
        r = countarr(6, 2:end) == 5;
        
        % if at least one sleep stage has no consecutive fife epochs wirte
        % name of dataset into result file
        if (max(s0) == 0 || max(s1) == 0 || max(s2) == 0 || max(s3) == 0 ||...
                max(s4) == 0 || max(r) == 0)
            fprintf(fileIDconsec, '%s \r\n', hypnogram);
        end
        
        % check which sleep stage is too short and write sleep stage into
        % result file
        if max(s0) == 0
            fprintf(fileIDconsec, '%s \r\n', 'S0 too short');
        end
        
        if max(s1) == 0
            fprintf(fileIDconsec, '%s \r\n', 'S1 too short');
        end
        
        if max(s2) == 0
            fprintf(fileIDconsec, '%s \r\n', 'S2 too short');
        end
        
        if max(s3) == 0
            fprintf(fileIDconsec, '%s \r\n', 'S3 too short');
        end
        
        if max(s4) == 0
            fprintf(fileIDconsec, '%s \r\n', 'S4 too short');
        end
        
        if max(r) == 0
            fprintf(fileIDconsec, '%s \r\n', 'R too short');
        end
end

fclose('all');
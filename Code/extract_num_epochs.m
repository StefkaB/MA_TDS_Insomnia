% script compares amount of epochs extracted from header and extracted from
% hypnogram file for each psg and writes results into result file
%
% author: Stefanie Breuer
% date: 01.03.2017
% -------------------------------------------------------------------------

% path of folder containing edf files
edf_path = 'C:\Users\Stefka\Desktop\Masterarbeit\INSOMNIA\';
% list all edf files
edf_listing = dir(edf_path); %including . and ..

% path of folder containing hypnogram files
hypno_path = 'C:\Users\Stefka\Desktop\Masterarbeit\Hypnograms\';
% list all hypnogram files
hypno_listing = dir(hypno_path); %including . and ..

% path to save result file
result_file = 'C:\Users\Stefka\Desktop\Masterarbeit\Epoch_Lengths.txt';
% create and open result file
fileID = fopen(result_file, 'a');
fprintf(fileID, '%s \r\n', 'Number of Epochs extracted from header and from hypnogram');

% loop over all edf files
for i = 3:length(edf_listing)
    % extract name of edf file
    edffilename = edf_listing(i).name;
    edffile = [edf_path, edffilename];
    edf = edffilename(1:end-20);
    
    % loop over all hypnogram files
    for j = 3:length(hypno_listing)
        % extract name of hypnogram file
        hypnofilename = hypno_listing(j).name;
        hypnofile = [hypno_path, hypnofilename];
        hypno = hypnofilename(11:end-4);
        
        % compare names of edf and hypnogram
        if strcmp(edf, hypno)
            % load edf
            header = sn_edfScan2matScan('data', edffile);
            % extract length of recording in seconds and calculate as
            % number of epochs
            header_epochs = floor(header.num_data_records*header.data_record_duration/30);
            % read hypnogram file
            T = dlmread(hypnofile);
            hypnogram = T(2:end);
            % extract length of hypnogram as amount of epochs
            hypno_epochs = length(hypnogram);
            
            % write file name, amount of epochs in header and in hypnogram
            % into result file
            fprintf(fileID, '%s \r\n', edf);
            fprintf(fileID, '%s %d \r\n', 'header epochs: ', header_epochs);
            fprintf(fileID, '%s %d \r\n', 'hypnogram epochs: ', hypno_epochs);
        end
    end
end

fclose('all');
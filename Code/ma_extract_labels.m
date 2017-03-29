% script to extract all labels from each edf file
%
%% Metadata
% Stefanie Breuer, 22.02.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% define folder containing edf files
edf_path = 'C:\Users\Stefka\Desktop\Masterarbeit\INSOMNIA\';

% create and open text file to save labels
labels_file = [edf_path(1:end-9), 'labels.txt'];
fileID = fopen(labels_file, 'a');

% list all edf files
edf_listing = dir(edf_path);
[edfpathstr, edfname, edfext] = fileparts(edf_path);

% loop over all data sets
for i = 3:length(edf_listing)
    
    % extract edf file name
    edf_file = edf_listing(i).name;
    edf_filepath = [edfpathstr, '\', edfname, edf_file];
    edf_name = edf_file(1:end-20);
    
    % write edf file name into text file
    fprintf(fileID, '%s \r\n', edf_name);

    % load edf
    [header, signalHeader] = blockEdfLoad(edf_filepath);
    % extract number of signals
    hd_num = header.num_signals;
    
    % extract label and write label into result file
    for j = 1:hd_num
        label = signalHeader(j).signal_labels;
        fprintf(fileID, '%s \r\n', label);
    end
    
    fprintf(fileID, '%s \r\n', '');
end

fclose('all');
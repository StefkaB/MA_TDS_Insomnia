% script to create a struct containing all tds results for each
% patient of the insomnia charite dataset
%
%% Metadata
% Stefanie Breuer, 09.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% folder containing all edf files of the dataset
edfpath = 'C:\Users\Stefka\Desktop\Masterarbeit\INSOMNIA\';
% list all files in folder
edf_listing = dir(edfpath); %including . and ..
% folder containing all result files
result_path = 'C:\Users\Stefka\Desktop\Masterarbeit\TDS-Results\';

% create fields for the insomnia charite dataset
field1 = 'name';
field2 = 'hypnogram';
field3 = 'biosignals';
field4 = 'xcc';
field5 = 'xcl';
field6 = 'tds'; %date of birth
field7 = 'nsis';
field8 = 'result';

% allocate cell arrays for values
value1 = cell(1, 8);
value2 = cell(1, 8);
value3 = cell(1, 8);
value4 = cell(1, 8);
value5 = cell(1, 8);
value6 = cell(1, 8);
value7 = cell(1, 8);
value8 = cell(1, 8);

% loop over edf files
for i = 3:length(edf_listing)
    
    % extract name
    edffile = edf_listing(i).name;
    edfname = edffile(1:end-20);
    
    % define paths for data that should be saved to struct
    hypnogram = [result_path, edfname, '_hypnogram.mat'];
    biosignals_tds = [result_path, edfname, '_biosignals_tds.mat'];
    xcc = [result_path, edfname, '_xcc.mat'];
    xcl = [result_path, edfname, '_xcl.mat'];
    tds = [result_path, edfname, '_tds.mat'];
    nsis = [result_path, edfname, '_nsis.mat'];
    result = [result_path, edfname, '_result.mat'];
    
%     load(hypnogram)
%     load(biosignals_tds)
%     load(xcc)
%     load(xcl)
%     load(tds)
%     load(nsis)
%     load(result)
    
    % write data into values of struct
    value1{i-2} = edfname;
    value2{i-2} = hypnogram;
    value3{i-2} = biosignals_tds;
    value4{i-2} = xcc;
    value5{i-2} = xcl;
    value6{i-2} = tds;
    value7{i-2} = nsis;
    value8{i-2} = result;
end

% create struct of tds results for charite insomnia dataset with fields and values
insomresults = struct(field1, value1, field2, value2, field3, value3, ...
    field4, value4, field5, value5, field6, value6, field7, value7, ...
    field8, value8);

% save struct
save('insomresults.mat', 'insomresults');
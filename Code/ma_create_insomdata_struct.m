% script to create a struct containing all relevant information about each
% patient of the insomnia charite dataset
%
%% Metadata
% Stefanie Breuer, 09.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% excel file containing relevant data of all patients from the dataset
xlsfile = 'C:\Users\Stefka\Desktop\Masterarbeit\Insomnie_Eignung_Struct.xlsx';
% read excel file
xlRange = 'B2:M65';
[num,txt,raw] = xlsread(xlsfile, xlRange);
xlsdata = raw;

% folder containing all edf files of the dataset
edfpath = 'C:\Users\Stefka\Desktop\Masterarbeit\INSOMNIA\';
% list all files in folder
edf_listing = dir(edfpath); %including . and ..

% folder containing all event files of the dataset
eventpath = 'C:\Users\Stefka\Desktop\Masterarbeit\Scoring\';
% list all files in folder
event_listing = dir(eventpath); %including . and ..

% folder containing all hypnogram files of the dataset
hypnopath = 'C:\Users\Stefka\Desktop\Masterarbeit\Hypnograms\';
% list all files in folder
hypno_listing = dir(hypnopath); %including . and ..

% create fields for the insomnia charite dataset
field1 = 'edffile';
field2 = 'eventfile';
field3 = 'hypnogramfile';
field4 = 'sex';
field5 = 'age';
field6 = 'dob'; %date of birth
field7 = 'height';
field8 = 'weight';
field9 = 'bmi'; %body mass index
field10 = 'recordingdate'; % date of first recording
field11 = 'disease';
field12 = 'medication';
field13 = 'group';

% create values containing information of the insomnia charite dataset for
% every field
value1 = cell(1, 13);
value2 = cell(1, 13);
value3 = cell(1, 13);
value4 = cell(1, 13);
value5 = cell(1, 13);
value6 = cell(1, 13);
value7 = cell(1, 13);
value8 = cell(1, 13);
value9 = cell(1, 13);
value10 = cell(1, 13);
value11 = cell(1, 13);
value12 = cell(1, 13);
value13 = cell(1, 13);


[row, col] = size(xlsdata);
% loop over excel data and write relevant information into the values
for i = 1:row
    
    % edf file name
    for j = 3:length(edf_listing)
        edffilename = edf_listing(j).name;
        if strcmp(xlsdata(i, 1), edffilename(1:end-20))
            value1(i) = cellstr(edffilename);
        end
    end
    
    % event file name
    for k = 3:length(event_listing)
        eventfilename = event_listing(k).name;
        if strcmp(xlsdata(i, 1), eventfilename(12:end-4))
            value2(i) = cellstr(eventfilename);
        end
    end
    
    % hypno file name
    for l = 3:length(hypno_listing)
        hypnofilename = hypno_listing(l).name;
        if strcmp(xlsdata(i, 1), hypnofilename(11:end-4))
            value3(i) = cellstr(hypnofilename);
        end
    end
    
    % patient sex
    value4(i) = xlsdata(i, 4);
    
    % patient age
    value5(i) = xlsdata(i, 5);
    
    %patient day of birth
    value6(i) = xlsdata(i, 3);
    
    % patient height
    value7(i) = xlsdata(i, 6);
    
    % patient weight
    value8(i) = xlsdata(i, 7);
    
    % patient body mass index
    value9(i) = xlsdata(i, 8);
    
    % date of first recording
    value10(i) = xlsdata(i, 9);
    
    % patient diseases
    value11(i) = xlsdata(i, 11);
    
    % patient medication
    value12(i) = xlsdata(i, 10);
    
    % classification group
    value13(i) = xlsdata(i, 12);
end

% create struct of charite insomnia datasets with fields and values
insomdata = struct(field1, value1, field2, value2, field3, value3, ...
    field4, value4, field5, value5, field6, value6, field7, value7, ...
    field8, value8, field9, value9, field10, value10, field11, value11, ...
    field12, value12, field13, value13);

% save struct
save('insomdata.mat', 'insomdata');


function [ s_infos,infos_raw_joined,infos_raw_joined_cp] = sn_getAlice6Metadata(filename,varargin)
% gets metadata info from automatically generated reports in rtf-fileformat
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 27.5.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
% USAGE: [ s_age,s_bmi,s_length,s_weight] = sn_getAlice6Metadata(filename,varargin)
%
% INPUT:
% filename   filename of rtf-report including path
%
% OPTIONAL INPUT:
% rtfformat  default: gai.rtf, 
%           '2_599': the columns are shifted by one
%
% OUTPUT:
% s_infos   double-array(4,1) with following infos
%               age in years
%               body mass index
%               subject's length in cm
%               subject's weight in kg
%
% MODIFICATIONS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%% defaults
rtfformat ='';

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %outputfile
        if strcmp(varargin{i},'rtfformat')
            rtfformat = varargin{i+1};
            %outputfile
        elseif strcmp(varargin{i},'wls')
            wls = varargin{i+1};
        end
    end
end

%% start processing

% open file and read all strings separated by blanks or linebreaks in cells
fileID = fopen(filename,'r');
C = textscan(fileID,'%s');
fclose(fileID);

%find ':' at beginning of word, and '\cell', 
% as we expect our values to be in between these markers
%findColon = regexp(C{:},'^:');
findColon = regexp(C{:},'^(:|BMI:)');
%whos findColon
%findColon2 = regexp(C{:},'^BMI:');



findCell = strfind(C{:},'\cell');

%find all instances where occurences where found
colonFound = cellfun(@(x) ~isempty(x), findColon);
cellFound = cellfun(@(x) ~isempty(x), findCell);

%get indices rather than logicals
colonFound_idx = find(colonFound);
cellFound_idx = find(cellFound);

%assign cell arrays
infos_raw = {};
infos_raw_joined = {};
infos_raw_joined_cp = {};

%define number of colons, that are processed
startcolons = 1;
stopcolons = 10;

%for each colon-mark, find the matching cell,
for i =startcolons:stopcolons
%     %debug info
%     disp(['Processing ColonIndex :', num2str(colonFound_idx(i))])
    %find all occurences of '\cell' after the occurence of current ':'
    cells_behind = find(cellFound_idx > colonFound_idx(i));
    %get the first preceding, this is our upper limit
    matching_cell = cells_behind(1);
%     %debug info
%     disp(['Next Cell found :' num2str(cellFound_idx(matching_cell))])
    %get all cells in temporary array
    infos_raw_tmp = {C{1}(colonFound_idx(i)+1:cellFound_idx(matching_cell)-1)};
    %get all cells in array, that start with '\', these are controls
    findControl = regexp(infos_raw_tmp{:},'^\');
    %find all instances where occurences where found
    controlFound = cellfun(@(x) ~isempty(x), findControl);
    infos_raw_tmp{1}(controlFound) = [];
    %join the remaining cells to a common string
    infos_raw_joined{i} = strjoin(infos_raw_tmp{1});
%     %debug info, a copy of the stringarray
     infos_raw_joined_cp{i} = strjoin(infos_raw_tmp{1});
    %check for remaining controls
    remain_controls = strfind(infos_raw_joined{i},'}{\rtlch\fcs1');
    %use the quite complicated procedure to delete ALL occurences
    if ~isempty(remain_controls)
        %create logical array with all indices of cell
        del_indices = false(length(infos_raw_joined),1);
        %set all char indices of control sequences to true
        for m = 1:13
            del_indices(remain_controls) = true;
            remain_controls = remain_controls+1;
        end
        %delete the control sequences
        infos_raw_joined{i}(del_indices)=[];
    end
    %check for remaining controls
    remain_controls = strfind(infos_raw_joined{i},'} {\rtlch\fcs1');
    %use the quite complicated procedure to delete ALL occurences
    if ~isempty(remain_controls)
        %create logical array with all indices of cell
        del_indices = false(length(infos_raw_joined),1);
        %set all char indices of control sequences to true
        for m = 1:14
            del_indices(remain_controls) = true;
            remain_controls = remain_controls+1;
        end
        %delete the control sequences
        infos_raw_joined{i}(del_indices)=[];
    end 
    %found other remaining controls
    remain_controls = strfind(infos_raw_joined{i},'\hich\af1\dbch\af13\loch\f1 ');
    %use the quite complicated procedure to delete ALL occurences
    if ~isempty(remain_controls)
        %create logical array with all indices of cell
        del_indices = false(length(infos_raw_joined),1);
        %set all char indices of control sequences to true
        for m = 1:28
            del_indices(remain_controls) = true;
            remain_controls = remain_controls+1;
        end
        %delete the control sequences
        infos_raw_joined{i}(del_indices)=[];
    end
    
    
    
end

s_infos = zeros(4,1);
%postprocessing, get rid of units and blanks and other dirt
%age, supposed to be at index 5
col_offset = 4;
if(strcmp(rtfformat,'2_599'))
    col_offset = 5;
end
for i =1:4
    [si,ei] = regexp(infos_raw_joined{i+col_offset},'[0-9\.]*');
    %debug info
    value = infos_raw_joined{i+col_offset}(si:ei);
    if ~isempty(value)
    s_infos(i,1) = str2num(value);
    else
        s_infos(i,1) = -1;
    end
end
    





function [header,signalheader,signalcells,header_tmp,signalheader_tmp,signalcells_tmp ] = sn_readEdfAlice6( subjectfolder )
% wraps sn_blockEdfLoad for Alice6 edfs, which come in chunks
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 13.5.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
% [header,headersignal,signalcells ] = sn_readEdfAlice6(subjectfolder)
%
% INPUT:
% subjectfolder  path where edfs are located. Folder has the same name as
% the edf-files!
% 
% OPTIONAL INPUT:
%
% OUTPUT:
% header        struct containing main header information
% signalheader  struct containing information about channels
% signalcells   cell array containing the actual data
% see sn_blockEdfLoad for more information 
%MODIFICATION LIST:
%------------------------------------------------------------
%% defaults

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %samplevarargin
        if strcmp(varargin{i},'hypno_coding')
            hypno_coding = varargin{i+1};
            %samplevarargin
        elseif strcmp(varargin{i},'stage_standard')
            stage_standard = varargin{i+1};
        end
    end
end

%% get all edf-files
edffiles = dir(fullfile(subjectfolder,'*].edf'))
if ~isempty(edffiles)
    %get first edf-file to set up everything
    [header,signalheader,signalcells] = sn_blockEdfLoad(fullfile(subjectfolder,{edffiles(1).name}));
    nfiles = length(edffiles);
    if (nfiles > 1)
        for i =2: nfiles
            %load data
            [header_tmp,signalheader_tmp,signalcells_tmp] = sn_blockEdfLoad(fullfile(subjectfolder,{edffiles(i).name}));
        end
    end
end
    
    
end


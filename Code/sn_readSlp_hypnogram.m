function [ hypnogram ] = sn_readSlp_hypnogram(filename,varargin)
%reads the scoring data of an Alice6 recording
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 13.5.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%

%USAGE: hypnogram = sn_readSlp_hypnogram(filename,varargin)
%
%INPUT:
%filename        Metadatafile of Compumedics, presumably SLPSTAG.DAT
%
%OPTIONAL INPUT:
% sl  signal length of the polysomnographic data, to match end of recording
% wls        windowlength of signal feature extraction in seconds, default 4 secs
%
%OUTPUT:
% hypnogram     an array containing the stages in 30s
% -----------------------------------------------------------------------

%% Defaults


%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %outputfile
        if strcmp(varargin{i},'mintd_rr')
            mintd_rr = varargin{i+1};
            %outputfile
        elseif strcmp(varargin{i},'wls')
            wls = varargin{i+1};
        end
    end
end

%open binary file and read data bytewise
fid = fopen(filename,'r')
hypnogram = fread(fid)
fclose(fid)

%set wake to zero, following siesta-schema
hypnogram(hypnogram > 9) = 0;



function sex = sn_readAlice6_getSex(rml,varargin);
%reads the sex information of the alice rml-file
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 14.5.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: sex = sn_readAlice6_getSex(rml)
%
%INPUT:
%rml        Metadatafile of Alice6
%
%OPTIONAL INPUT:
% sl  signal length of the polysomnographic data, to match end of recording
% wls        windowlength of signal feature extraction in seconds, default 4 secs
% FD1_slopeTh slopethreshold for QRS-method FD1th, default 0.2
% AF2_ampFactorTh scaling factor threshold for AF2th-method, default 0.65
% AF2_ampTh fixed threshold for amplitude in AF2th-method, default 0.8
% DF2_ampFactorTh scaling factor threshold for DF2th-method, default 0.125
% DF2_windowSize window size for DF2th-method, default 3
% ch_emgchin channelnumber of chin (submental) EMG signal, default 10;
%
%OUTPUT:
% hypnogram     an array containing the stages in 30s
% -----------------------------------------------------------------------

%% Defaults

%testfile
rml = '/home/dagi/DATA/POLYSOM-DATA/GUOJI/NARCOLEPSY/A6-firstComputer/00000007-100599/00000007-100599.rml'


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

%% read in data structure
xDoc = xmlread(rml);

%get sex information, there should be only one :-)
sexNode = xDoc.getElementsByTagName('Gender');
sexData = char(sexNode.item(0).getFirstChild.getData);

%set sexCode as in SIESTA-Data
if(strcmp(sexData,'Male'))
    sex = 'm';
elseif(strcmp(sexData,'Female'))
    sex = 'f';
else sex = 'unknown';
end

end


function [ hypnogram ] = sn_readProfusion_hypnogram(xml,varargin)
%reads the scoring data of an compumedics profusion recording
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 13.5.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: hypnogram = sn_readAlice6_hypnogram(xml,varargin)
%
%INPUT:
%rml        Metadatafile of Compumedics Profusion. 
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
%rml = '/home/dagi/DATA/POLYSOM-DATA/GUOJI/NARCOLEPSY/A6-firstComputer/00000007-100599/00000007-100599.rml'


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

%read in data structure
xDoc = xmlread(rml);

%get elements by name
allListitems = xDoc.getElementsByTagName('UserStaging');
whos allListeitems

stages = allListitems.item(0).getElementsByTagName('Stage');
nstages = stages.getLength

%create array
stagearray = zeros(nstages,2);
for i = 0 : nstages -1
    attributes = stages.item(i).getAttributes
    nattributes = attributes.getLength
    for k = 0: nattributes-1
        if(strcmp(attributes.item(k).getName,'Start'))
            stagearray(i+1,1) = str2num(attributes.item(k).getValue)
        elseif(strcmp(attributes.item(k).getName,'Type'))
            stagetype = char(attributes.item(k).getValue);
            % whos stagetype
            switch stagetype
                case 'Wake'
                    stagearray(i+1,2) = 0;
                case 'NonREM1'
                    stagearray(i+1,2) = 1;
                case 'NonREM2'
                    stagearray(i+1,2) = 2;
                case 'NonREM3'
                    stagearray(i+1,2) = 3;
                case 'REM'
                    stagearray(i+1,2) = 5;
                case 'NotScored'
                    stagearray(i+1,2) = 6;
                otherwise
                    disp('Stage not known, setting to 6 (not scored)')
                    stagearray(i+1,2) = 6;
            end
        end
    end
end

%reduce from seconds to 30 second epochs
%to start with timepoint zero at index point 1, add one
stagearray(:,1) = stagearray(:,1)./30 + 1;
%to start with timepoint zero at index point 1, add one

%recordlength in seconds.
recordSeconds = 0;
%get total length of recording from data segment information
segments = xDoc.getElementsByTagName('Segment');
nsegments = segments.getLength

for l = 0:nsegments - 1
        duration = segments.item(l).getElementsByTagName('Duration');
        recordSeconds = recordSeconds + str2num(duration.item(0).getFirstChild.getData);
end
    
%create array for sleep stages
hypnogram = zeros(floor(recordSeconds/30),1);

% add values for all but last stage

for m = 1: nstages -1 
    hypnogram(stagearray(m,1):stagearray(m+1,1)) = stagearray(m,2);
end
%add last stage until the end of the recording
   hypnogram(stagearray(nstages,1):end) = stagearray(nstages,2);



function [ result,nsis,hypnogram] = sn_getStagesTDS(varargin)
% calculates the fraction of stable TDS for different sleep stages
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 19.2.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
% USAGE: sn_getStagesTDS('data',tsd,'hypnogram',hypnogram, varargin)
%
% INPUT:
% 'data'        tds matrix containing TDS, col: signal, row: time. Time resolution
% needs to match the resolution of the hypnogram (30 s)
% 'hypnogram'     hypnogram-array
% OR
% 'hypnogramfile'  name of hypnogramfile, format is set by hypnogramfileformat, where the default is 'edf'
%
% OPTIONAL INPUT:
% hypno_coding      struct with fields the following fields: 'Wake','REM','NREM1','NREM2','NREM3','NREM4','artefacts')
% scoring_scheme    sleep stages that are considered:
%                       Default: 'simplified' is only 4 sleep stages (DS,LS,
%                       REM, WAKE)
%                       'RK': 6 sleep stages according to Rechtschaffen and
%                       Kales
%                       'AASM': 5 sleep stages according to AASM 2007
% hypnogramfileformat   devicename, that has different hypnogram-format.
%                   Default: 'edf'
%                   Currently supported: alice6, compumedics
%
% remove_borders     flag for removing borders of sleep stages. Default 0 (off), 1 = on
% artefacts          array with epoch indices indicating artifacts
% artefactfile       logfile created by ...
%
% OUTPUT:
% result matrix containing fraction of stable delays in stages
%           col: signal1
%           row: signal2
%           third-dim: stages in the order: DS-LS-REM-W
% nsis  vector containing the number of samples in nth stage
%MODIFICATION LIST:
% 20150302 V 1.1 (dk)
% - use length of tds for indexing, rather than hypnogram
% - added hypnocoding and stage_standard as options
% 20150331 (dk)
% - added option remove_borders
% 20160923 (dk)
% - all parameters as varargin, artefact-removal from logfile or array
%------------------------------------------------------------
%% defaults
hypno_coding = struct('Awake',0,'REM',5,'NREM1',1,'NREM2',2,'NREM3',3,'NREM4',4,'artefacts',9)
scoring_scheme = 'simplified';
remove_borders = 0;
hypnogramfileformat ='edf';
hypnogramfile = '';
artefactfile = '';
debug = 0;

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %tds
        if strcmp(varargin{i},'data')
            tds = varargin{i+1};
            %hypnogram as array
        elseif strcmp(varargin{i},'hypnogram')
            hypnogram = varargin{i+1};
            %artefacts as index-array
        elseif strcmp(varargin{i},'artefacts')
            artefacts = varargin{i+1};
        elseif strcmp(varargin{i},'hypnogramfile')
            hypnogramfile = varargin{i+1};
        elseif strcmp(varargin{i},'artefactfile')
            hypnogramfile = varargin{i+1};
        elseif strcmp(varargin{i},'hypno_coding')
            hypno_coding = varargin{i+1};
        elseif strcmp(varargin{i},'scoring_scheme')
            scoring_scheme = varargin{i+1};
        elseif strcmp(varargin{i},'remove_borders')
            remove_borders = varargin{i+1};
        elseif strcmp(varargin{i},'hypnogramfileformat')
            hypnogramfileformat = varargin{i+1};
        elseif strcmp(varargin{i},'debug')
            debug = varargin{i+1};
        end
    end
end

if debug
    disp('Welcome to sn_getStagesTDS')
end

%% Check for mandatory parameters
if (~exist('tds'))
    disp('tds data is missing, please set data')
    return
end

if (~exist('hypnogram') && ~exist('hypnogramfile'))
    disp('hypnogram data is missing, please set hypnogram or hypnogramfile')
    return
end

%% Check for hypnogramfile present, in case read hypnogram

if ~isempty(hypnogramfile)
    if debug
        disp(['Reading hypnogramfile: ' hypnogramfile ' with format ' hypnogramfileformat])
    end
    %read file
    if(strcmp(hypnogramfileformat,'edf'))
        %read from edf
        [header,signalheader,signalcells]= sn_edfScan2matScan('data', hypnogramfile);
        %extract hypnogram from cell
        hypnogram = signalcells{1};
    elseif(strcmp(hypnogramfileformat,'compumedics'))
        %read from SLPSTAG.DAT
        [ hypnogram ] = sn_readSlp_hypnogram(hypnogramfile);
    elseif(strcmp(hypnogramfileformat,'alice6'))
        %read from rlm
        [ hypnogram ] = sn_readAlice6_hypnogram(hypnogramfile);
    end
end

%% reduce hypnogram to length of tds
if(length(hypnogram) > size(tds,1))
    hypnogram = hypnogram(1:size(tds,1));
end

%% artefact handling

%% Check for artefactfile
if ~isempty(artefactfile)
    if debug
        disp(['Reading artefactfile: ' artefactfile])
    end
    artefacts = sn_readArtefacts('data',artefactfile);
end

%% mark artefacts in hypnogram
if exist('artefacts')
    if debug
        disp('Artefact array found - marking artefacts in hypnogram')
    end
    
    %mark hypnograms
    hypnogram = sn_markArtefacts('hypnogram',hypnogram,'artefacts',artefacts,'artefactCode',hypno_coding.artefacts);
end


%number of sleep stages (nss)
if (strcmp(scoring_scheme,'simplified'))
    nss = 4;
    %simplify hypnogram
    if debug
        disp('merging NREM3 and NREM4')
    end
    %hypnogram(hypnogram == hypno_coding.NREM2) = hypno_coding.NREM1;
    hypnogram(hypnogram == hypno_coding.NREM4) = hypno_coding.NREM3;
elseif (strcmp(scoring_scheme,'AASM'))
    nss = 5;
elseif (strcmp(scoring_scheme,'RK'))
    nss = 6;
end

%% remove sleep stage borders
if remove_borders
    if debug
        disp('Epochs at stage transitions are set as artefact')
    end
    
    %remove the epochs at the border of the stages: assign them to 9 (artifact)
    %front border
    dhyp = diff(hypnogram);
    %back border
    dhyp2 = [ 0; dhyp ];
    %set the respective epochs to artifacts
    hypnogram(dhyp ~= 0) = hypno_coding.artefacts;
    hypnogram(dhyp2 ~= 0) = hypno_coding.artefacts;
end

%allocate buffer for results
result = zeros(size(tds,2),nss);
%number of samples in stage
nsis = zeros(nss,1);

if (strcmp(scoring_scheme,'RK'))
    for i = 0:nss-1
        %samples in stage
        sis = (hypnogram == i);
        nsis(i+1) = sum(sis);
        %fraction of stable sequences in stage
        result(:,i+1) = sum(tds(sis,:))/sum(sis);
    end
elseif (strcmp(scoring_scheme,'simplified'))
    %DS
    %samples in stage
    sis = (hypnogram == hypno_coding.NREM3);
    nsis(1) = sum(sis);
    %fraction of stable sequences in stage
    result(:,1) = sum(tds(sis,:),1)/sum(sis);
    %LS
    %samples in stage, take only S2 (S1 is inbetween LS and Awake)
    sis = (hypnogram == hypno_coding.NREM2);
    nsis(2) = sum(sis);
    %fraction of stable sequences in stage
    result(:,2) = sum(tds(sis,:),1)/sum(sis);
    %REM
    %samples in stage
    sis = (hypnogram == hypno_coding.REM);
    nsis(3) = sum(sis);
    %fraction of stable sequences in stage
    result(:,3) = sum(tds(sis,:),1)/sum(sis);
    %AWAKE
    %samples in stage
    sis = (hypnogram == hypno_coding.Awake);
    nsis(4) = sum(sis);
    %fraction of stable sequences in stage
    result(:,4) = sum(tds(sis,:),1)/sum(sis);
else
    disp('Sorry, not yet implemented')
end

%reshape result
result = reshape(result,sqrt(size(tds,2)),sqrt(size(tds,2)),nss);
end


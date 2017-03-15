function [sm_tds,methods] = sn_getsubjectMeanTDSS(tds,varargin)
%calculates statistics for 4-D-TDS array containing individual TDS
%assessments
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 1.6.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: [statistics] = sn_getsubjectMeanTDS(tds)
% INPUT:
% tds    4-D vector of size(scorr,scorr,4,nsubjects)
%
%OPTIONAL INPUT:
% nsis      (4,nsubjects) array containing the number of epochs in
%               each sleep stage. If provided, tds resulting from a stage
%               with less than 'emin' are not included
% emin          minimum number of epochs for a stage to be included into
%               the statistics when nsis is given. Default: 10
%
%OUTPUT:
% sm_tds        4-D Vector of (scorr,scorr,4,5), where the last index
%               refers to the following statistical measures
%               1: mean
%               2: stds
%               3: median
%               4: min
%               5: max
% methods       a string array containing the names of the methods
%
%MODIFICATION LIST:
%
%------------------------------------------------------------
%% Defaults
nsis = '';
emin = 10;

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %tolerance
        if strcmp(varargin{i},'nsis')
            nsis = varargin{i+1};
            %placeholder
        elseif strcmp(varargin{i},'emin')
            emin = varargin{i+1};
        end
    end
end

%% get infos and preallocate

% get sizes
[ncorr,ncorr,stages,nsubjects] = size(tds);

%preallocate array
sm_tds = zeros(ncorr,ncorr,4,5);
sm_nsis = zeros(4,1);

%% start processing

%check for nans, take the first index
%resulting in a 4xnsubjects array
testarray = squeeze(tds(1,1,:,:));
%logical array containing locations of NaNa
nan_bin = isnan(testarray);
n_nan_stage = sum(nan_bin,2);
%logical indexes what subjects excluded. At the beginnin: non :-)
n_out = false(1,nsubjects);

%debug info
disp(['Stages with NaN found :' num2str(sum(n_nan_stage))])

%if no NaN, everything is simple
% loop over stages
for i = 1:4
    %get array of tds_stages within sleep stages (38x38xnsubjects)
    sm_tds_tmp = squeeze(tds(:,:,i,:));
    %check for nan
    if (n_nan_stage(i) > 0)
        %mark regarding indexes as to delete
        n_out = n_out | nan_bin(1,:);
    end
    %check for low number of epochs
    if ~isempty(nsis)
        %index of nonsufficient nsis
        n_out = n_out | nsis(i,:) <=emin;
    end
    %delete excluded data
    sm_tds_tmp(:,:,n_out) = [];
    
    %get statistics
    sm_tds(:,:,i,1) = mean(sm_tds_tmp,3);
    sm_tds(:,:,i,2) = std(sm_tds_tmp,[],3);
    sm_tds(:,:,i,3) = median(sm_tds_tmp,3);
    sm_tds(:,:,i,4) = min(sm_tds_tmp,[],3);
    sm_tds(:,:,i,5) = max(sm_tds_tmp,[],3);
end
methods = {'Mean';'Std';'Median';'Min';'Max'};
end
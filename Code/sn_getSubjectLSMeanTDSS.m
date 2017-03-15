function [smls_tdss] = sn_getSubjectLSMeanTDSS(tdss,varargin)
%calculates statistics for 4-D-TDS array containing individual TDS
%assessments
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 1.6.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: [statistics] = sn_getsubjectMeanTDS(tds)
% INPUT:
% tdss    4-D vector of size(scorr,scorr,4,nrecords)
%
%OPTIONAL INPUT:
% mask          logical array of size(scorr,scorr).
%               Only the correlations set to true are processed
%               default: upper triangle of the array
%OUTPUT:
% smls_tds      Vector of (5,nrecords,5), 
%               where the first index refers to the sleep stages
%               1: DS, 2: LS, 3: REM, 4: Wake, 5: All together
%               where the last index
%               refers to the following statistical measures
%               1: mean
%               2: stds
%               3: median
%               4: min
%               5: max
%
%MODIFICATION LIST:
%
%------------------------------------------------------------
%% Defaults
%get size of array
[ncorrs,ncorrs,stages,nrecords] = size(tdss);
%get upper triangular matrix
mask = ~tril(ones(ncorrs,ncorrs));

emin = 10;

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %tolerance
        if strcmp(varargin{i},'mask')
            mask = varargin{i+1};
            %placeholder
        elseif strcmp(varargin{i},'emin')
            emin = varargin{i+1};
        end
    end
end

%% get infos and preallocate

%preallocate array
smls_tdss = zeros(5,nrecords,5);

%% start processing
for k = 1:nrecords
    for i = 1:4
        %extract tdss
        tdss_tmp = tdss(:,:,i,k);
        %apply mask
        tdss_tmp = tdss_tmp(mask);
        %get statistics
        smls_tdss(i,k,1) = mean(tdss_tmp);
        smls_tdss(i,k,2) = std(tdss_tmp);
        smls_tdss(i,k,3) = median(tdss_tmp);
        smls_tdss(i,k,4) = min(tdss_tmp);
        smls_tdss(i,k,5) = max(tdss_tmp);
        
    end
    %fill the last row (overall statistics without considering sleep
    %stages)
        tdss_tmp = reshape(tdss(:,:,:,k),ncorrs*ncorrs*4,1);
        %apply mask
        tdss_tmp = tdss_tmp(mask);
        %get statistics
        smls_tdss(5,k,1) = mean(tdss_tmp);
        smls_tdss(5,k,2) = std(tdss_tmp);
        smls_tdss(5,k,3) = median(tdss_tmp);
        smls_tdss(5,k,4) = min(tdss_tmp);
        smls_tdss(5,k,5) = max(tdss_tmp);

end
end
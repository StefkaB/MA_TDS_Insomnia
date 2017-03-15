function [ start_trans, stop_trans ] = sn_siestatds_hypnogram_tranistions(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% defaults
% debug
debug = 0;
filename = '';

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %sampling frequency of signal
        if strcmp(varargin{i},'data')
            filename = varargin{i+1};
            %event rate sampling frequency
        elseif strcmp(varargin{i},'debug')
            debug = varargin{i+1};
        end
    end
end

%read hypnogram
[header, signalheader,signalcell] = sn_edfScan2matScan('data',filename);

hypnogram = signalcell{1};
%reduce to 12 and 34
hypnogram(hypnogram==2) = 1;
hypnogram(hypnogram==4) = 3;

%get stage-transitions
dhyp = diff(hypnogram);
%get transitions
start_trans = find(dhyp~=0);
stop_trans = start_trans+1;

if (debug)
   disp(['Percentage of transistion epochs: ' num2str(2*length(start_trans)/length(hypnogram)*100) ' %'])
end

 


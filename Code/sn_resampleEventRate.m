function [eventrate]  = sn_getEventRate(events,varargin)
%calculates the event rate from a vector containing points of time of
%events
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 17.2.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: sn_getEventRate(events,varargin)
% INPUT: 
% events - vector containing event times
%
% OPTIONAL INPUT:
% 'sf'   sampling frequency of the original signal in Hz, default 1 Hz
% 'ersf' sampling frequency of event rate, default 1 Hz
% 'sl'   signal length of original signal in samples, default max(events)
% 'tpa'  time point assignment, time point to which the calculated
%           event-rate (period) is assigned to. 
%           'first' = first timepoint of the  two timepoints, the difference is taken from, 
%           'interp' = the timepoint in the middle of the first and second time-point. 
%           'second' = second timepoint of the two timepoints            
%           Default: 'first'  
%OUTPUT:
% eventrate  vector containing the breathing rate
%MODIFICATION LIST:
% 
%------------------------------------------------------------
%% defaults
%signal sampling frequency
sf = 1;
%event rate sampling frequency
ersf = 1;
%signal length
sl = max(events);
%time point assignment
tpa = 'first'
        

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %sampling frequency of signal
        if strcmp(varargin{i},'sf')
            sf = varargin{i+1};
        %event rate sampling frequency
        elseif strcmp(varargin{i},'ersf')
            ersf = varargin{i+1};
        %signal length
        elseif strcmp(varargin{i},'sl')
            sl = varargin{i+1};
        %time point assignment
        elseif strcmp(varargin{i},'tpa')
            tpa = varargin{i+1};
        end
    end
end

%% Get event rate

%calculate event period (ep) in seconds: diff between event times
ep = diff(events)/sf;

%time point index - time point to which the calculated period should be assigned: middle point
%between the two time points the period is calculated from
if (strcmp(tpa,'interp')
    epi = events(1:end-1)+ep/2;
elseif (strcmp(tpa,'second')    
    epi = events(2:end);
else % first = default
    epi = events(1:end-1);
end 

%interpolate breathingperiods between first and last extrem value;
br = interp1(epi,(1./ep),(floor(epi(1)):ceil(epi(end))));

%pad at both ends to fit resampled data
padstart = floor(epi(1))-1;
padend = sl-ceil(epi(end));
eventrate = [repmat(br(1),1,padstart),br,repmat(br(end),1,padend)];

%resample breatingrate to ersf
eventrate = resample(eventrate,ersf,sf);

end







function [dice,nce,ts_match] = sn_diceEvents(ts1,ts2,varargin)
%calculates dice coefficient of event detection methods between ts1 and ts2
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 6.3.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: sn_diceEvents(ts1,ts2,varargin)
% INPUT: 
% ts1    locical vector of events, length of ts1 is the length of the
% original signal
% ts1    locical vector of events, length of ts2 and ts1 must be the same
%
%OPTIONAL INPUT:
% tolerance  number of samples to both sides of an event, 
%               that would be accounted as the same event       
%
%OUTPUT:
% dice      dice coefficient
% nce       number of common events
% dce       distance of common events in samples
%
%MODIFICATION LIST:
% 
%------------------------------------------------------------
%% Defaults
tolerance = 0;

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %tolerance
        if strcmp(varargin{i},'tolerance')
            tolerance = varargin{i+1};
        %placeholder
        elseif strcmp(varargin{i},'slabels')
            slabels = varargin{i+1};
        end
    end
end

%get dilated ts1
if (tolerance > 0)
    ts1_dilated = nld_dilateTS(ts1,tolerance);
end

%get matching events
ts_match = ts1_dilated & ts2;
%number of common events
nce = sum(ts_match); 


%% check for close-by events (overlapping tolerance)
c_events = find(ts_match);

%distance of events
c_devents = diff(c_events);

c_devents_overlap = find(c_devents <= 2*tolerance+1);

%overlapping events exist
if ~isempty(c_devents_overlap)
    disp('Events in overlapping kernels found...')
    length(c_devents_overlap)
    %check if in ts1 also two signals exist within the tolerance kernel 
    %to keep overview, loop over indices and clip the respective window
    for i = 1:length(c_devents_overlap)
        %i
        %c_devents_overlap(i)
        %length(ts_match)
        %length(c_events)
        %clip respective area
        clip_ts = ts_match(c_events(c_devents_overlap(i))-min(c_devents_overlap(i),tolerance):min(length(ts_match),c_events(c_devents_overlap(i)+1)+tolerance));
        clip_ts1_dilate = ts1_dilated(c_events(c_devents_overlap(i))-min(c_devents_overlap(i),tolerance):min(length(ts_match),c_events(c_devents_overlap(i)+1)+tolerance));
        clip_ts1 = ts1(c_events(c_devents_overlap(i))-min(c_devents_overlap(i),tolerance):min(length(ts_match),c_events(c_devents_overlap(i)+1)+tolerance));
        
        %OR of clips to get the minimum of the blob and then AND to ts1 to
        %see if more than one event is remaining
        nearby_events = (clip_ts | clip_ts1_dilate) & clip_ts1;
        
        %get number of events (remaining ones)
        n_events = sum(nearby_events);
        
        %if only one event in ts1 where two in ts2, subtract one "common
        %event"
        if (n_events == 1)
            %disp('Removing one common event...')
            nce = nce -1;
        end
    end
end

dice = 2*nce/sum([ts1;ts2]);


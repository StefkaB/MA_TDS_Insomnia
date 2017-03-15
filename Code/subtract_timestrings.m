function [t, durationsecs] = subtract_timestrings(time, time2)
% calculates the elapsed time between two points of time and returns 1 if
% the elapsed time is less or equal one hour and 0 if the elapsed time is
% more than one hour
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 28.2.2017, stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
% USAGE: t = subtract_timestrings(time, time2)
%
% INPUT:
% time       point of first time as a cell in format 'hh:mm:ss'
% time2      point of second time as a cell in format 'hh:mm:ss'
%
% OUTPUT
% t          t with value 1 if elapsed time is less or equal one hour
%            and 0 otherwise
%
%% Start
    
    % convert cells into numeric values of hours, minutes and seconds
    time = cell2mat(time);
    hh_time = str2double(time(1:2));
    mm_time = str2double(time(4:5));
    ss_time = str2double(time(7:8));
    
    time2 = cell2mat(time2);
    hh_time2 = str2double(time2(1:2));
    mm_time2 = str2double(time2(4:5));
    ss_time2 = str2double(time2(7:8));
    
    % convert time and time2 into duration class variables with format
    % seconds, so that D_time and D_time2 represent the amount of elapsed
    % seconds from 00:00:00 until time and time2
    D_time = duration(hh_time, mm_time, ss_time, 'Format', 's');
    D_time2 = duration(hh_time2, mm_time2, ss_time2, 'Format', 's');
    
    % amount of seconds of one day
    daysecs = 86400;
    
    % time2 ist bigger than time (= time2 is the same day)
    if D_time <= D_time2
        % convert D_time and D_time2 into double and calculate elapsed
        % seconds
        durationsecs = seconds(D_time2-D_time);
        % check if elapsed time is not longer than one hour
        if durationsecs <= 3600
            t = 1;
        else
            t = 0;
        end
    
    % time is bigger than time2 (= time2 is the next day)
    else
        % calculate the rest of the first day from time and add the elapsed
        % time of time2
        durationsecs = seconds(daysecs - seconds(D_time));
        durationsecs = seconds(durationsecs + D_time2);
        % check if elapsed time is not longer than one hour
        if durationsecs <= 3600
            t = 1;
        else
            t = 0;
        end
    end
end
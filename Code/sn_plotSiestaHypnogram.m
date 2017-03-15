function [ signal2,figure_handle ] = sn_plotSiestaHypnogram(signal)
%plots a histogram in the order Awake - REM - LS1 - LS2 - DS1 -DS2
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 21.3.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: sn_plotSiestaHypnogram(signal,varargin)
% INPUT: 
% signal - vector containing the sleep stages in Siesta Coding:
%           0=wake,1-2=LS,3-4=DS,5=REM,6&9=artifacts
%
% OPTIONAL INPUT:
%
%OUTPUT:
% figure plotting the hypnogram
%MODIFICATION LIST:
% 
%------------------------------------------------------------
% 
%% 
% change numbers of sleep stages to ease plotting
% 0 = 0 
% 5 =  -1
% 1 = -2 etc.
%6,9 = -6
signal2 = signal;
signal2(signal==5) = -1;
signal2(signal==1) = -2;
signal2(signal==2) = -3; 
signal2(signal==3) = -4; 
signal2(signal==4) = -5; 
signal2(signal==6) = -6; 
signal2(signal==9) = -6;

%Plot hypnogram
figure_handle = figure
plot(signal2)
ylabel('Sleep Stages')
xlabel('time [x 30s]')
ylim([-5.1 1])
%set ticks
set(gca,'YTick',[-5,-4,-3,-2,-1,0])
%set labels
set(gca,'YTickLabel',{'DS2';'DS1';'LS2';'LS1';'REM';'Awake'})

end


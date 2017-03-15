function [meantds, meangroupnsis] = calculate_mean(varargin)
% calculates mean of nsis and tds result matrix
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 09.03.2017, stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: [meantds, meangroupnsis] = calculate_mean('group', 'heart');
%
%INPUT:
% group          can be 'heart', 'breath', 'sleep', 'none', default: 'all'
%                heart: all patients with arhythmical heart beat or
%                high/low blood preasure
%                breath: all patients with sleap apneas, asthma or other
%                lung diseases
%                sleep: all patients who consume sleep-inducing drugs
%                none: all patients with insomnia but none of the other
%                grooup diseases
%                all: whole insomnia dataset
%
%OUTPUT
% meangroupnsis  mean values of nsis (nsis represents the number of epochs
%                per sleep stage with 1=DS, 2=LS, 3=REM, 4=WAKE)
% meantds        mean tds matrix over all tds matrices, plotted for each
%                sleep stage
%
% Modification List
%% Defaults
group = 'all';
all_ind = 1:64;

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %outputfile
        if strcmp(varargin{i},'group')
            group = varargin{i+1};
        end
    end
end


%% load structs and find indices of groups
load('insomdata.mat')
load('insomresults.mat')
load('tds_colormap2.mat')

% find indices of group heart
heart = arrayfun(@(x) strfind(x.group, 'heart'), insomdata, 'UniformOutput', 0);
heart_ind = find(~cellfun('isempty', heart)); % faster than find(~cellfun(@isempty, insomgroupheart))
% find indices of subgroup breath
breath = arrayfun(@(x) strfind(x.group, 'breath'), insomdata, 'UniformOutput', 0);
breath_ind = find(~cellfun('isempty', breath));
% find indices of subgroup apnea
apnea = arrayfun(@(x) strfind(x.group, 'apnea'), insomdata, 'UniformOutput', 0);
apnea_ind = find(~cellfun('isempty', apnea));
% find indices of group sleep
sleep = arrayfun(@(x) strfind(x.group, 'sleep'), insomdata, 'UniformOutput', 0);
sleep_ind = find(~cellfun('isempty', sleep));
% find indices of group insom
insom = arrayfun(@(x) strfind(x.group, 'none'), insomdata, 'UniformOutput', 0);
insom_ind = find(~cellfun('isempty', insom));
% match breath and apnea subgroups into one group breath
breath_ind = [breath_ind, apnea_ind];
% delete duplicates and sort array
breath_ind = sort(unique(breath_ind));
% find indices of group young (lower 10%)
ageyoung = arrayfun(@(x) x.age <34, insomdata, 'UniformOutput', 0);
ageyoung = cell2mat(ageyoung);
young_ind = find(ageyoung>0); %ind_young: 40    51    53    54    58    62
% find indices of group old (upper 15%)
ageold = arrayfun(@(x) x.age >60, insomdata, 'UniformOutput', 0);
ageold = cell2mat(ageold);
old_ind = find(ageold>0); %ind_old: 3     4     5     8    15    20    22    29    44    52


if strcmp(group, 'heart')
    group_ind = heart_ind;
    group_name = 'heart';
elseif strcmp(group, 'breath')
    group_ind = breath_ind;
    group_name = 'breath';
elseif strcmp(group, 'sleep')
    group_ind = sleep_ind;
    group_name = 'sleep';
elseif strcmp(group, 'none')
    group_ind = insom_ind;
    group_name = 'insom';
elseif strcmp(group, 'all')
    group_ind = all_ind;
    group_name = 'all';
elseif strcmp(group, 'young')
    group_ind = young_ind;
    group_name = 'young';
elseif strcmp(group, 'old')
    group_ind = old_ind;
    group_name = 'old';
end

%% calculate mean of nsis for whole data

groupnsis = zeros(4, 1);
for i = 1:length(group_ind)
    nsis = insomresults(group_ind(i)).nsis;
    groupnsis = groupnsis + nsis;
end
meangroupnsis = groupnsis/length(insomdata);

%% calculate mean of tds for whole data
ds = zeros(28, 28, length(group_ind));
ls = zeros(28, 28, length(group_ind));
rem = zeros(28, 28, length(group_ind));
wake = zeros(28, 28, length(group_ind));
for i = 1:length(group_ind)
    result = insomresults(group_ind(i)).result;
    ds(:, :, i) = result(:, :, 1);
    ls(:, :, i) = result(:, :, 2);
    rem(:, :, i) = result(:, :, 3);
    wake(:, :, i) = result(:, :, 4);
end
meands = mean(ds, 3, 'omitnan');
meanls = mean(ls, 3, 'omitnan');
meanrem = mean(rem, 3, 'omitnan');
meanwake = mean(wake, 3, 'omitnan');
meantds = zeros(28, 28, 4);
meantds(:, :, 1) = meands;
meantds(:, :, 2) = meanls;
meantds(:, :, 3) = meanrem;
meantds(:, :, 4) = meanwake;

save(['meantds_', group_name, '.mat'], 'meantds')

%sn_plotTDSMatrixCharite(meantds, 'colormap', tds_colormap2);
sn_plotTDSMatrixChariteAll(meantds, 'multiplot', 1, 'colormap', tds_colormap2);
end



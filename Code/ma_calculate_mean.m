function [meantds, meangroupnsis] = calculate_mean(varargin)
% calculates mean of nsis and tds result matrix
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 09.03.2017
% stefanie.breuer@student.htw-berlin.de
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
%
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

% find indices of group young (n=22))
younger49f = arrayfun(@(x) x.age <49 && strcmp(x.sex, 'w'), insomdata, 'UniformOutput', 0);
younger49f = cell2mat(younger49f);
younger49f = find(younger49f>0); %(n=11)
younger49m = arrayfun(@(x) x.age <49 && strcmp(x.sex, 'm'), insomdata, 'UniformOutput', 0);
younger49m = cell2mat(younger49m);
younger49m = find(younger49m>0); %(n=11)
% find indices of group old (n=22))
older58f = arrayfun(@(x) x.age >58 && strcmp(x.sex, 'w'), insomdata, 'UniformOutput', 0);
older58f = cell2mat(older58f);
older58f = find(older58f>0); %(n=14)
older58m = arrayfun(@(x) x.age >58 && strcmp(x.sex, 'm'), insomdata, 'UniformOutput', 0);
older58m = cell2mat(older58m);
older58m = find(older58m>0); %(n=8)

allyoung = arrayfun(@(x) x.age<49, insomdata);
allyoung = all_ind(allyoung); %(n=22)
allold = arrayfun(@(x) x.age>58, insomdata);
allold = all_ind(allold); %(n=22)

all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
f_ind = all_ind(all_f); % indices of all w
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
m_ind = all_ind(all_m); % indices of all m

% set group index and name
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
    group_ind = allyoung;
    group_name = 'young';
elseif strcmp(group, 'old')
    group_ind = allold;
    group_name = 'old';
elseif strcmp(group, 'female')
    group_ind = f_ind;
    group_name = 'female';
elseif strcmp(group, 'male')
    group_ind = m_ind;
    group_name = 'male';
elseif strcmp(group, 'youngmale')
    group_ind = younger49m;
    group_name = 'youngmale';
elseif strcmp(group, 'youngfemale')
    group_ind = younger49f;
    group_name = 'youngfemale';
elseif strcmp(group, 'oldmale')
    group_ind = older58m;
    group_name = 'oldmale';
elseif strcmp(group, 'oldfemale')
    group_ind = older58f;
    group_name = 'oldfemale';
end

%% calculate mean of nsis for whole data
% allocate vector
groupnsis = zeros(4, 1);
% loop over length of group
for i = 1:length(group_ind)
    % write number of epochs in sleep stage into variable
    nsis = insomresults(group_ind(i)).nsis;
    % add
    groupnsis = groupnsis + nsis;
end

% calculate mean number of epochs per sleep stage
meangroupnsis = groupnsis/length(group_ind);

%% calculate mean of tds for whole data
% allocate matrices
ds = zeros(28, 28, length(group_ind));
ls = zeros(28, 28, length(group_ind));
rem = zeros(28, 28, length(group_ind));
wake = zeros(28, 28, length(group_ind));

% loop over group
for i = 1:length(group_ind)
    
    % extract tds matrix
    result = insomresults(group_ind(i)).result;
    
    % write data into allocated matrices
    ds(:, :, i) = result(:, :, 1);
    ls(:, :, i) = result(:, :, 2);
    rem(:, :, i) = result(:, :, 3);
    wake(:, :, i) = result(:, :, 4);
end

% calculate mean for each sleep stage with mean(sleep stage, dim, ignore nan)
meands = mean(ds, 3, 'omitnan');
meanls = mean(ls, 3, 'omitnan');
meanrem = mean(rem, 3, 'omitnan');
meanwake = mean(wake, 3, 'omitnan');

% allocate matrix for all mean sleep stages
meantds = zeros(28, 28, 4);

% write each mean sleep stage into allocates matrix
meantds(:, :, 1) = meands;
meantds(:, :, 2) = meanls;
meantds(:, :, 3) = meanrem;
meantds(:, :, 4) = meanwake;

% save data
save(['meantds_', group_name, '.mat'], 'meantds')

%sn_plotTDSMatrixCharite(meantds, 'colormap', tds_colormap2);
sn_plotTDSMatrixChariteAll(meantds, 'multiplot', 1);

end

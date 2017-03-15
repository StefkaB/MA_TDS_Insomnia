% script to load insomdata struct and extract group information

%% load insomdata struct
insomstructpath = 'C:\Users\Stefka\Documents\MATLAB\TDS_Insomnia';
% load insomdata struct
load(fullfile(insomstructpath,'insomdata.mat'));

%% find group indices

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

%% group heart

% find sex
heart_w = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata(heart_ind));
heart_w = heart_ind(heart_w); % indices of all w with heart
heart_w_leng = length(heart_w); % amount of w with heart
heart_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata(heart_ind));
heart_m = heart_ind(heart_m); % indices of all m with heart
heart_m_leng = length(heart_m); % amount of m with heart

% find age
heart_age = arrayfun(@(x) x.age, insomdata(heart_ind)); % all ages of heart
heart_meanage = mean(heart_age); % mean age of all heart
%mean([insomdata(heart_ind).age])
heart_minage = min(heart_age); % min age of all heart
heart_maxage = max(heart_age); % max age of all heart
heart_w_age = arrayfun(@(x) x.age, insomdata(heart_w)); % all ages of w heart
heart_w_meanage = mean(heart_w_age); % mean age of w heart
heart_w_minage = min(heart_w_age); % min age of w heart
heart_w_maxage = max(heart_w_age); % max age of w heart
heart_m_age = arrayfun(@(x) x.age, insomdata(heart_m)); % all ages of m heart
heart_m_meanage = mean(heart_m_age); % mean age of m heart
heart_m_minage = min(heart_m_age); % min age of m heart
heart_m_maxage = max(heart_m_age); % max age of m heart

%% group breath

% find sex
breath_w = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata(breath_ind));
breath_w = breath_ind(breath_w); % indices of all w with breath
breath_w_leng = length(breath_w); % amount of w with breath
breath_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata(breath_ind));
breath_m = breath_ind(breath_m); % indices of all m with breath
breath_m_leng = length(breath_m); % amount of m with breath

% find age
breath_age = arrayfun(@(x) x.age, insomdata(breath_ind)); % all ages of breath
breath_meanage = mean(breath_age); % mean age of all breath
breath_minage = min(breath_age); % min age of all breath
breath_maxage = max(breath_age); % max age of all breath
breath_w_age = arrayfun(@(x) x.age, insomdata(breath_w)); % all ages of w breath
breath_w_meanage = mean(breath_w_age); % mean age of w breath
breath_w_minage = min(breath_w_age); % min age of w breath
breath_w_maxage = max(breath_w_age); % max age of w breath
breath_m_age = arrayfun(@(x) x.age, insomdata(breath_m)); % all ages of m breath
breath_m_meanage = mean(breath_m_age); % mean age of m breath
breath_m_minage = min(breath_m_age); % min age of m breath
breath_m_maxage = max(breath_m_age); % max age of m breath

%% group insom

% find sex
insom_w = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata(insom_ind));
insom_w = insom_ind(insom_w); % indices of all w with insomnia
insom_w_leng = length(insom_w); % amount of w with insomnia
insom_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata(insom_ind));
insom_m = insom_ind(insom_m); % indices of all m with insomnia
insom_m_leng = length(insom_m); % amount of m with insomnia

% find age
insom_age = arrayfun(@(x) x.age, insomdata(insom_ind)); % all ages of insomnia
insom_meanage = mean(insom_age); % mean age of all insomnia
insom_minage = min(insom_age); % min age of all insomnia
insom_maxage = max(insom_age); % max age of all insomnia
insom_w_age = arrayfun(@(x) x.age, insomdata(insom_w)); % all ages of w insomnia
insom_w_meanage = mean(insom_w_age); % mean age of w insomnia
insom_w_minage = min(insom_w_age); % min age of w insomnia
insom_w_maxage = max(insom_w_age); % max age of w insomnia
insom_m_age = arrayfun(@(x) x.age, insomdata(insom_m)); % all ages of m insomnia
insom_m_meanage = mean(insom_m_age); % mean age of m insomnia
insom_m_minage = min(insom_m_age); % min age of m insomnia
insom_m_maxage = max(insom_m_age); % max age of m insomnia

%% group sleep

% find sex
sleep_w = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata(sleep_ind));
sleep_w = sleep_ind(sleep_w); % indices of all w with sleep
sleep_w_leng = length(sleep_w); % amount of w with sleep
sleep_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata(sleep_ind));
sleep_m = sleep_ind(sleep_m); % indices of all m with sleep
sleep_m_leng = length(sleep_m); % amount of m with sleep

% find age
sleep_age = arrayfun(@(x) x.age, insomdata(sleep_ind)); % all ages of sleep
sleep_meanage = mean(sleep_age); % mean age of all sleep
sleep_minage = min(sleep_age); % min age of all sleep
sleep_maxage = max(sleep_age); % max age of all sleep
sleep_w_age = arrayfun(@(x) x.age, insomdata(sleep_w)); % all ages of w sleep
sleep_w_meanage = mean(sleep_w_age); % mean age of w sleep
sleep_w_minage = min(sleep_w_age); % min age of w sleep
sleep_w_maxage = max(sleep_w_age); % max age of w sleep
sleep_m_age = arrayfun(@(x) x.age, insomdata(sleep_m)); % all ages of m sleep
sleep_m_meanage = mean(sleep_m_age); % mean age of m sleep
sleep_m_minage = min(sleep_m_age); % min age of m sleep
sleep_m_maxage = max(sleep_m_age); % max age of m sleep

%% group all

% find sex
ind_all = [1:64];
all_w = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
all_w = ind_all(all_w); % indices of all w
all_w_leng = length(all_w); % amount of w
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = ind_all(all_m); % indices of all m
all_m_leng = length(all_m); % amount of m

% find age
all_age = arrayfun(@(x) x.age, insomdata); % all ages
all_meanage = mean(all_age); % mean age
all_minage = min(all_age); % min age
all_maxage = max(all_age); % max age
all_w_age = arrayfun(@(x) x.age, insomdata(all_w)); % all ages of w
all_w_meanage = mean(all_w_age); % mean age of w
all_w_minage = min(all_w_age); % min age of w
all_w_maxage = max(all_w_age); % max age of w
all_m_age = arrayfun(@(x) x.age, insomdata(all_m)); % all ages of m
all_m_meanage = mean(all_m_age); % mean age of m
all_m_minage = min(all_m_age); % min age of m
all_m_maxage = max(all_m_age); % max age of m
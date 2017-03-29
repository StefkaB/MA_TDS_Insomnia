function nmean_age = calculate_nmean_age_matches(varargin)
% calculates nmean and creates matrix containing nmean and age for each
% match per sleep stage
% see master thesis of Stefanie Breuer for classification of matches
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 26.03.2017, stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: nmean_age = ma_calculate_nmean_age_matches('group', 'all', 'siestastruct', bothnights);
%
%INPUT:
% group         can be 'all', 'f', 'm' for whole group, female and male
%
%OUTPUT
% nmean_age     matrix containing nmean and age for each
%               patient per sleep stage
%
% Modification List

%% Defaults
group = 'all';

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
        elseif strcmp(varargin{i},'siestastruct')
            bothnights = varargin{i+1};
        end
    end
end

%% load structs and find indices of groups
% load data
load('insomresults.mat')
load('insomdata.mat')
load('matches.mat')

% find sex for whole group
ind_all = [1:64];
all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
all_f = ind_all(all_f); % indices of all w
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = ind_all(all_m); % indices of all m

% compare group input
if strcmp(group, 'all') 
    leng = length(ind_all);
    data = ind_all;
    nmean_age = zeros(leng, 2, 4);
elseif strcmp(group, 'f') 
    leng = length(all_f);
    data = all_f;
    nmean_age = zeros(leng, 2, 4);
elseif strcmp(group, 'm') 
    leng = length(all_m);
    data = all_m;
    nmean_age = zeros(leng, 2, 4);
end

% loop over group
for i = 1:leng
    % extract result matrix
    patage = insomdata(data(i)).age;
    tdsmat_siesta = bothnights(matches(data(i))).tds_stages;
    % delete frontopolar eegs from tds matrix for comparison
    tdsmat_siesta(24:28,:,:) = [];
    tdsmat_siesta(:,24:28,:) = [];
    tdsmat_siesta(9:13,:,:) = [];
    tdsmat_siesta(:,9:13,:) = [];
    % loop over sleep stages
    for s = 1:4
        tdssum = 0;
        % loop over result matrix in x and y direction
        for k = 1:length(tdsmat_siesta)
            for l = k+1:length(tdsmat_siesta)
                % sum link strengths for each sleep stage
                tdssum = tdssum+tdsmat_siesta(k, l, s);
            end
        end
        % calculate global mean link strength and age for each
        % patient and sleep stage
        nmean_age(i, 1, s) = tdssum/(((length(tdsmat_siesta)^2) - length(tdsmat_siesta))/2);
        nmean_age(i, 2, s) = patage;
    end
end

if strcmp(group, 'all')
    nmean_age_all_match = nmean_age;
elseif strcmp(group, 'f')
    nmean_age_f_match = nmean_age;
elseif strcmp(group, 'm')
    nmean_age_m_match = nmean_age;
end

% save variables
if strcmp(group, 'all')
    save('nmean_age_all_match.mat', 'nmean_age_all_match')
elseif strcmp(group, 'f')
    save('nmean_age_f_match.mat', 'nmean_age_f_match')
elseif strcmp(group, 'm')
    save('nmean_age_m_match.mat', 'nmean_age_m_match')
end

end

% script to subtract matches tds matrix from insomnia tds matrix and to
% plot the differences for each sleep stage
%
%% Metadata
% Stefanie Breuer, 26.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% load structs of insomnia and siesta data and results of gender-age-matching
% load('insomdata.mat')
% load('insomresults.mat')
% load('matches.mat')
% siestapath = 'C:\Users\Stefka\Documents\MATLAB\SomnoNetz_m-Files\test_functions\TDS';
% load(fullfile(siestapath,'siesta_all_consent_26-May-2015.mat'));
% % extract all healthy of both nights
% edf_index_healthy = arrayfun(@(x) (isstruct(x.night) & ...
%     strcmp('healthy',x.status)), siesta);
% firstnight_field = arrayfun(@(x) (~isempty(x.night(1).rrfilename)),...
%     siesta(edf_index_healthy));
% firstnight = arrayfun(@(x) x.night(1), siesta(edf_index_healthy)) ;
% secondnight_field = arrayfun(@(x) (length(x.night) == 2 & ...
%     strcmp('healthy',x.status)),siesta);
% secondnight = arrayfun(@(x) x.night(2), siesta(secondnight_field));
% bothnights = [firstnight secondnight];

% extract indices of groups
% all = [1:64]; %all
% group_ind = all;
% all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
% all_f = all(all_f); %all female
% group_ind = all_f;
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = all(all_m); %all male
group_ind = all_m;

% allocate matrices for insomnia per sleep stage
ds_insom = zeros(28, 28, length(group_ind));
ls_insom = zeros(28, 28, length(group_ind));
rem_insom = zeros(28, 28, length(group_ind));
wake_insom = zeros(28, 28, length(group_ind));

% allocate matrices for matches per sleep stage
ds_match = zeros(28, 28, length(group_ind));
ls_match = zeros(28, 28, length(group_ind));
rem_match = zeros(28, 28, length(group_ind));
wake_match = zeros(28, 28, length(group_ind));

% ---------------------------------------------------
% insomnia
% ---------------------------------------------------
% loop over insomnia group
for i = 1:length(group_ind)
    
    % extract tds matrix
    result_insom = insomresults(group_ind(i)).result;
    
    % write data into allocated matrices for each sleep stage
    ds_insom(:, :, i) = result_insom(:, :, 1);
    ls_insom(:, :, i) = result_insom(:, :, 2);
    rem_insom(:, :, i) = result_insom(:, :, 3);
    wake_insom(:, :, i) = result_insom(:, :, 4);
end

% calculate mean for each sleep stage with mean(sleep stage, dim, ignore nan)
meands_insom = mean(ds_insom, 3, 'omitnan');
meanls_insom = mean(ls_insom, 3, 'omitnan');
meanrem_insom = mean(rem_insom, 3, 'omitnan');
meanwake_insom = mean(wake_insom, 3, 'omitnan');

% allocate matrix for all mean sleep stages
meantds_insom = zeros(28, 28, 4);

% write each mean sleep stage into allocates matrix
meantds_insom(:, :, 1) = meands_insom;
meantds_insom(:, :, 2) = meanls_insom;
meantds_insom(:, :, 3) = meanrem_insom;
meantds_insom(:, :, 4) = meanwake_insom;

% ---------------------------------------------------
% matches
% ---------------------------------------------------
% loop over matches group
for i = 1:length(group_ind)
    
    % extract tds matrix
    result_match = bothnights(matches(group_ind(i))).tds_stages;
    
    % delete frontopolar eegs from tds matrix for comparison
    result_match(24:28,:,:) = [];
    result_match(:,24:28,:) = [];
    result_match(9:13,:,:) = [];
    result_match(:,9:13,:) = [];
    
    % write data into allocated matrices for each sleep stage
    ds_match(:, :, i) = result_match(:, :, 1);
    ls_match(:, :, i) = result_match(:, :, 2);
    rem_match(:, :, i) = result_match(:, :, 3);
    wake_match(:, :, i) = result_match(:, :, 4);
end

% calculate mean for each sleep stage with mean(sleep stage, dim, ignore nan)
meands_match = mean(ds_match, 3, 'omitnan');
meanls_match = mean(ls_match, 3, 'omitnan');
meanrem_match = mean(rem_match, 3, 'omitnan');
meanwake_match = mean(wake_match, 3, 'omitnan');

% allocate matrix for all mean sleep stages
meantds_match = zeros(28, 28, 4);

% write each mean sleep stage into allocates matrix
meantds_match(:, :, 1) = meands_match;
meantds_match(:, :, 2) = meanls_match;
meantds_match(:, :, 3) = meanrem_match;
meantds_match(:, :, 4) = meanwake_match;


% ---------------------------------------------------
% plot differences
% ---------------------------------------------------
% meantds_diff_insom_match_all = meantds_insom-meantds_match;
% plot_differences(meantds_diff_insom_match_all);
% save('meantds_diff_insom_match_all.mat', 'meantds_diff_insom_match_all')
% meantds_diff_insom_match_f = meantds_insom-meantds_match;
% plot_differences(meantds_diff_insom_match_f);
% save('meantds_diff_insom_match_f.mat', 'meantds_diff_insom_match_f')
meantds_diff_insom_match_m = meantds_insom-meantds_match;
ma_plot_differences(meantds_diff_insom_match_m, 'colorbartext', 'population');
save('meantds_diff_insom_match_m.mat', 'meantds_diff_insom_match_m')


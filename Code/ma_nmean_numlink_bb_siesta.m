% script to plot global mean link strength nmean and number of links for
% brain-brain subnetwork for matches from siesta data (set see master thesis 
% of Stefanie Breuer for classification of matches)
%
%% Metadata
% Stefanie Breuer, 25.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% load structs and find indices of groups
% load('insomdata.mat')
% load('insomresults.mat')
% load('matches.mat')
% siestapath = 'C:\Users\Stefka\Documents\MATLAB\SomnoNetz_m-Files\test_functions\TDS';
% load(fullfile(siestapath,'siesta_all_consent_26-May-2015.mat'));
% extract all healthy of both nights
% edf_index_healthy = arrayfun(@(x) (isstruct(x.night) & ...
%     strcmp('healthy',x.status)), siesta);
% firstnight_field = arrayfun(@(x) (~isempty(x.night(1).rrfilename)),...
%     siesta(edf_index_healthy));
% firstnight = arrayfun(@(x) x.night(1), siesta(edf_index_healthy)) ;
% secondnight_field = arrayfun(@(x) (length(x.night) == 2 & ...
%     strcmp('healthy',x.status)),siesta);
% secondnight = arrayfun(@(x) x.night(2), siesta(secondnight_field));
% bothnights = [firstnight secondnight];

all = [1:64]; %all
all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
all_f = all(all_f); %all female
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = all(all_m); %all male
all_young = arrayfun(@(x) x.age<49, insomdata);
all_young = all(all_young); %(n=22)
all_old = arrayfun(@(x) x.age>58, insomdata);
all_old = all(all_old); %(n=22)

young_f = arrayfun(@(x) x.age <49 && strcmp(x.sex, 'w'), insomdata, 'UniformOutput', 0);
young_f = cell2mat(young_f);
young_f = find(young_f>0); %young female (n=11)
young_m = arrayfun(@(x) x.age <49 && strcmp(x.sex, 'm'), insomdata, 'UniformOutput', 0);
young_m = cell2mat(young_m);
young_m = find(young_m>0); %young male (n=11)

old_f = arrayfun(@(x) x.age >58 && strcmp(x.sex, 'w'), insomdata, 'UniformOutput', 0);
old_f = cell2mat(old_f);
old_f = find(old_f>0); %old female (n=14)
old_m = arrayfun(@(x) x.age >58 && strcmp(x.sex, 'm'), insomdata, 'UniformOutput', 0);
old_m = cell2mat(old_m);
old_m = find(old_m>0); %old male (n=8)

%inds = [all, all_f, all_m, all_young, all_old, young_f, young_m, old_f, old_m];
inds = [1:9];

nmean_start = 0;
nmean_min_start = 100;
nmean_max_start = 0;
% -------------------------------------------------------
% brain subnetwork
% -------------------------------------------------------
% loop over groups and extract indices of groups
for i = 1:length(inds)
    if i == 1
        ind_data = all;
    elseif i == 2
        ind_data = all_f;
    elseif i == 3
        ind_data = all_m;
    elseif i == 4
        ind_data = all_young;
    elseif i == 5
        ind_data = all_old;
    elseif i == 6
        ind_data = young_f;
    elseif i == 7
        ind_data = old_f;
    elseif i == 8
        ind_data = young_m;
    elseif i == 9
        ind_data = old_m;
    end
    
    % allocate arrays for global link strength and number of links
    nmean_array = zeros(length(ind_data),4);
    num_array = zeros(length(ind_data), 4);
    
    % loop over group
    for j = 1:length(ind_data)
        
        % extract tds matrix
        tdsmat = bothnights(matches(j)).tds_stages;
        
        % delete frontopolar eegs
        tdsmat(24:28,:,:) = [];
        tdsmat(:,24:28,:) = [];
        tdsmat(9:13,:,:) = [];
        tdsmat(:,9:13,:) = [];
        
        % cut tdsmat to only brain-brain subnetwork
        tdsmat_bb = tdsmat(9:end,9:end,:);
        
        % loop over sleep stages
        for s = 1:4
            tdssum = 0;
            numsum = 0;
            % loop over result matrix in x and y direction
            for m = 1:length(tdsmat_bb)
                for n = m+1:length(tdsmat_bb)
                    % sum link strengths for each sleep stage
                    tdssum = tdssum+tdsmat_bb(m, n, s);
                    if tdsmat_bb(m, n, s) > 0.07
                        numsum = numsum+1;
                    end
                end
            end
            % calculate global mean link strength and number of 
            % links > 0.07 for each patient and sleep stage
            nmean = tdssum/(((length(tdsmat_bb)^2) - length(tdsmat_bb))/2);
            nmean_array(j,s) = nmean;
            num_array(j,s) = numsum;

        end
    end
    
    % write data into arrays for each sleep stage
    nmean_ds = nmean_array(:,1);
    nmean_ls = nmean_array(:,2);
    nmean_r = nmean_array(:,3);
    nmean_w = nmean_array(:,4);
    num_ds = num_array(:,1);
    num_ls = num_array(:,2);
    num_r = num_array(:,3);
    num_w = num_array(:,4);
    
    % calculate minimum, maximum, mean and standard deviation
    nmean_ds_mean = mean(nmean_ds);
    nmean_ds_min = min(nmean_ds);
    nmean_ds_max = max(nmean_ds);
    nmean_ds_std = std(nmean_ds);
    %nmean_ds_min = quantile(nmean_ds, 0.25);
    %nmean_ds_max = quantile(nmean_ds, 0.75);
    num_ds_mean = mean(num_ds);
    num_ds_min = min(num_ds);
    num_ds_max = max(num_ds);
    num_ds_std = std(num_ds);
    %num_ds_min = quantile(num_ds, 0.25);
    %num_ds_max = quantile(num_ds, 0.75);
    
    nmean_ls_mean = mean(nmean_ls);
    nmean_ls_min = min(nmean_ls);
    nmean_ls_max = max(nmean_ls);
    nmean_ls_std = std(nmean_ls);
    %nmean_ls_min = quantile(nmean_ls, 0.25);
    %nmean_ls_max = quantile(nmean_ls, 0.75);
    num_ls_mean = mean(num_ls);
    num_ls_min = min(num_ls);
    num_ls_max = max(num_ls);
    num_ls_std = std(num_ls);
    %num_ls_min = quantile(num_ls, 0.25);
    %num_ls_max = quantile(num_ls, 0.75);
    
    nmean_r_mean = mean(nmean_r);
    nmean_r_min = min(nmean_r);
    nmean_r_max = max(nmean_r);
    nmean_r_std = std(nmean_r);
    %nmean_r_min = quantile(nmean_r, 0.25);
    %nmean_r_max = quantile(nmean_r, 0.75);
    num_r_mean = mean(num_r);
    num_r_min = min(num_r);
    num_r_max = max(num_r);
    num_r_std = std(num_r);
    %num_r_min = quantile(num_r, 0.25);
    %num_r_max = quantile(num_r, 0.75);
    
    nmean_w_mean = mean(nmean_w);
    nmean_w_min = min(nmean_w);
    nmean_w_max = max(nmean_w);
    nmean_w_std = std(nmean_w);
    %nmean_w_min = quantile(nmean_w, 0.25);
    %nmean_w_max = quantile(nmean_w, 0.75);
    num_w_mean = mean(num_w);
    num_w_min = min(num_w);
    num_w_max = max(num_w);
    num_w_std = std(num_w);
    %num_w_min = quantile(num_w, 0.25);
    %num_w_max = quantile(num_w, 0.75);
    
    % define data to be plotted
    nmean = [nmean_ds_mean, nmean_ls_mean, nmean_r_mean, nmean_w_mean];
    %yneg_nmean = [nmean_ds_min, nmean_ls_min, nmean_r_min, nmean_w_min];
    %ypos_nmean = [nmean_ds_max, nmean_ls_max, nmean_r_max, nmean_w_max];
    yneg_nmean = [nmean_ds_std, nmean_ls_std, nmean_r_std, nmean_w_std];
    ypos_nmean = [nmean_ds_std, nmean_ls_std, nmean_r_std, nmean_w_std];
    num = [num_ds_mean, num_ls_mean, num_r_mean, num_w_mean];
    %yneg_num = [num_ds_min, num_ls_min, num_r_min, num_w_min];
    %ypos_num = [num_ds_max, num_ls_max, num_r_max, num_w_max];
    yneg_num = [num_ds_std, num_ls_std, num_r_std, num_w_std];
    ypos_num = [num_ds_std, num_ls_std, num_r_std, num_w_std];
    
    
    % plot
    x = [1:4];
    figure(1)
    if i == 1
        color = 'green'; %all
        linestyle = 'solid';
        spec = '-og';
    elseif i == 2
        color = 'red'; %all female
        linestyle = 'solid';
        spec = '-or';
    elseif i == 3
        color = 'blue'; %all male
        linestyle = 'solid';
        spec = '-ob';
    elseif i == 4
        color = 'green'; %all young
        linestyle = ':';
        spec = ':^g';
    elseif i == 5
        color = 'green'; %all old
        linestyle = '--';
        spec = '--vg';
    elseif i == 6
        color = 'red'; %young female
        linestyle = ':';
        spec = ':^r';
    elseif i == 7
        color = 'red'; %old female
        linestyle = '--';
        spec = '--vr';
    elseif i == 8
        color = 'blue'; %young male
        linestyle = ':';
        spec = ':^b';
    elseif i == 9
        color = 'blue'; %old male
        linestyle = '--';
        spec = '--vb';
    end
    
    % plot global link strength and number of links
    figure(1)
    errorbar(x,nmean,yneg_nmean,ypos_nmean, spec)
    hold on
    figure(2)
    errorbar(x,num,yneg_num, ypos_num, spec)
    hold on
end

% set figure property
h1 = figure(1)
set(h1, 'units', 'normalized', 'Position', [.3 .3 .3 .5])
ylabel('globale Verbindungsstärke')
set(gca, 'Xtick', [1 2 3 4], 'XtickLabel', {'TS' 'LS' 'R' 'W'})
%legend('Alle', 'alle Frauen', 'alle Männer', '<49', '>59', 'Frauen<49', ...
%    'Frauen>59','Männer<49', 'Männer>59')
ylim([0 0.5])
text(1.1,0.45,'b) G-G')
hold on

h2 = figure(2)
set(h2, 'units', 'normalized', 'Position', [.61 .3 .3 .4])
ylabel('Anzahl Verbindungen')
%legend('Alle', 'alle Frauen', 'alle Männer', '<49', '>59', 'Frauen<49', ...
%    'Frauen>59','Männer<49', 'Männer>59')
ylim([0 400])
text(1.1,350,'e) G-G')
set(gca, 'Xtick', [1 2 3 4], 'XtickLabel', {'TS' 'LS' 'R' 'W'})
hold on

%inds = [all, all_f, all_m, all_young, all_old, young_f, young_m, old_f, old_m];


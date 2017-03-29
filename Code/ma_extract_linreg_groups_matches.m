% script to extract data from matches for linear regression in R 
% (link strengths and age)
% see master thesis of Stefanie Breuer for classification of matches
% use R script ma_linreg_groups.R afterwards and plot resulting slopes and 
% p-values with matlab scripts ma_buil_matrix-linreg_groups.m and 
% ma_plot_linreg_groups.m
%
%% Metadata
% Stefanie Breuer, 28.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start
% load insomnia data structs
% load('insomdata.mat')
% load('insomresults.mat')
% load('bothnights.mat')
% load('matches.mat')

% ---------------------------------------------
% define the group of interest
% ---------------------------------------------
% extract all patients
% data = [1:length(insomdata)];
% leng = length(data);

% % extract all female patients
% ind_all = [1:length(insomdata)];
% all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
% data = ind_all(all_f); % indices of all w
% leng = length(data);

% extract all male patients
ind_all = [1:length(insomdata)];
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
data = ind_all(all_m); % indices of all w
leng = length(data);

% ---------------------------------------------
% extract tds and information
% ---------------------------------------------
% allocate matrices for all link strengths of each sleep stage and for the
% age of each match
ds_link = zeros(378,leng);
ls_link = zeros(378, leng);
r_link = zeros(378, leng);
w_link = zeros(378, leng);
pat_age = zeros(1, leng);

% loop over all matches
for i = 1:leng
    
    % extract age from insomnia patients and tds matrix from match
    patage = insomdata(data(i)).age;
    tdsmat_siesta = bothnights(matches(data(i))).tds_stages;
    
    % delete frontopolar eegs from tds matrix for comparison
    tdsmat_siesta(24:28,:,:) = [];
    tdsmat_siesta(:,24:28,:) = [];
    tdsmat_siesta(9:13,:,:) = [];
    tdsmat_siesta(:,9:13,:) = [];
    
    % write age of recent match into vector
    pat_age(i) = patage;
    
    % loop over upper right triangle of tds matrix and write link 
    % strengths into matrix
    ind = 1;
    for x = 1:28
        for y = x+1:28
            ds_link(ind,i) = tdsmat_siesta(x,y,1);
            ls_link(ind,i) = tdsmat_siesta(x,y,2);
            r_link(ind,i) = tdsmat_siesta(x,y,3);
            w_link(ind,i) = tdsmat_siesta(x,y,4);
            ind = ind+1;
        end
    end
        
    
end

% save variables
save('ds_link.mat', 'ds_link')
save('ls_link.mat', 'ls_link')
save('r_link.mat', 'r_link')
save('w_link.mat', 'w_link')
save('pat_age.mat', 'pat_age')

% for linear regression use R script (ma_linreg_groups.R) 
% and ma_build_matrix_linreg_groups.m and ma_plot_linreg_goupts.m afterwards
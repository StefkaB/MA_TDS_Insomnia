% script to extract data from insomnia patients for linear regression in R 
% (link strengths and age)
% use R script ma_linreg_groups.R afterwards and plot resulting slopes and 
% p-values with matlab scripts ma_buil_matrix-linreg_groups.m and 
% ma_plot_linreg_groups.m
%
%% Metadata
% Stefanie Breuer, 27.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start
% load insomnia data structs
% load('insomdata.mat')
% load('insomresults.mat')

% ---------------------------------------------
% define the group of interest
% ---------------------------------------------
% extract all patients
data = [1:length(insomdata)];
leng = length(data);

% % extract all female patients
% ind_all = [1:length(insomdata)];
% all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
% data = ind_all(all_f); % indices of all w
% leng = length(data);

% % extract all male patients
% ind_all = [1:length(insomdata)];
% all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
% data = ind_all(all_m); % indices of all w
% leng = length(data);

% ---------------------------------------------
% extract tds and information
% ---------------------------------------------
% allocate matrices for all link strengths of each sleep stage and for the
% age of each patient
ds_link = zeros(378,leng);
ls_link = zeros(378, leng);
r_link = zeros(378, leng);
w_link = zeros(378, leng);
pat_age = zeros(1, leng);

% loop over group
for i = 1:leng
    
    % extract patient id and tds matrix from insomnia patients
    patid = insomresults(data(i)).name;
    tdsmat = insomresults(data(i)).result;
    
    % loop over insomnia data
    for j = 1:length(insomdata)
        
        % extract edffilename with patient id and age
        patedf = insomdata(data(i)).edffile;
        patage = insomdata(data(i)).age;
        
        % check if same patient id and write age of recent patient into
        % vector
        if strcmp(patedf(1:end-20), patid)
            ind = 1;
            pat_age(i) = patage;
            
            % loop over upper right triangle of tds matrix and write link 
            % strengths into matrix
            for x = 1:28
                for y = x+1:28
                    ds_link(ind,i) = tdsmat(x,y,1);
                    ls_link(ind,i) = tdsmat(x,y,2);
                    r_link(ind,i) = tdsmat(x,y,3);
                    w_link(ind,i) = tdsmat(x,y,4);
                    ind = ind+1;
                end
            end
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
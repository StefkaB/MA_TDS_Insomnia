% script to read data of hypothesis tests that was calculated with R and to
% plot the p-values of single testing aswell as the p-values after multiple
% test correction with bonferroni correction
% see R script ma_link_population_tests.R
%
%% Metadata
% Stefanie Breuer, 26.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0
%% Start
% --------------------------------------------------
% p-values of insomnia and matches group
% --------------------------------------------------
% load p-values with single testing and multiple test correction (bonferroni)
% data comes as vectors, not as matrices
load('p_population_ds.mat')
load('p_population_ds_corrected.mat')
load('p_population_ls.mat')
load('p_population_ls_corrected.mat')
load('p_population_r.mat')
load('p_population_r_corrected.mat')
load('p_population_w.mat')
load('p_population_w_corrected.mat')

% allocate matrices for uncorrected and correced p-values
ds = zeros(28,28);
ls = zeros(28,28);
r = zeros(28,28);
w = zeros(28,28);
ds_corrected = zeros(28,28);
ls_corrected = zeros(28,28);
r_corrected = zeros(28,28);
w_corrected = zeros(28,28);

m = 1;
n = m+1;
% loop over all links
for k = 1:length(p_population_ds)
    
    % write p-values from vector into upper rights triangle of matrices 
    % for each sleep stage
    ds(m,n) = p_population_ds(k);
    ls(m,n) = p_population_ls(k);
    r(m,n) = p_population_r(k);
    w(m,n) = p_population_w(k);
    ds_corrected(m,n) = p_population_ds_corrected(k);
    ls_corrected(m,n) = p_population_ls_corrected(k);
    r_corrected(m,n) = p_population_r_corrected(k);
    w_corrected(m,n) = p_population_w_corrected(k);
    
    % step into next row if colomn index reaches end
    if n == 28
        m = m+1;
        n = m+1;
    else
        n = n+1;
    end
end

% allocate matrices for eacht sleep stage
ds_pvalues = zeros(28,28);
ls_pvalues = zeros(28,28);
r_pvalues = zeros(28,28);
w_pvalues = zeros(28,28);

% loop over all p-values
for i = 1:length(ds_corrected)
    for j = 1:length(ds_corrected)
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if ds(i,j) > 0.05
            ds_pvalues(i,j) = 6;
        elseif ds(i,j) > 0.01 && ds(i,j) <= 0.05
            ds_pvalues(i,j) = 5;
        elseif ds(i,j) > 0.001 && ds(i,j) <= 0.01
            ds_pvalues(i,j) = 4;
        elseif ds(i,j) > 0 && ds(i,j) <= 0.001
            ds_pvalues(i,j) = 3;
        end
        
        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if ds_corrected(i,j) > 0.01 && ds_corrected(i,j) <= 0.05
            ds_pvalues(i,j) = 2;
        elseif ds_corrected(i,j) > 0.001 && ds_corrected(i,j) <= 0.01
            ds_pvalues(i,j) = 1;
        elseif ds_corrected(i,j) > 0 && ds_corrected(i,j) <= 0.001
            ds_pvalues(i,j) = 0;
        end
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if ls(i,j) > 0.05
            ls_pvalues(i,j) = 6;
        elseif ls(i,j) > 0.01 && ls(i,j) <= 0.05
            ls_pvalues(i,j) = 5;
        elseif ls(i,j) > 0.001 && ls(i,j) <= 0.01
            ls_pvalues(i,j) = 4;
        elseif ls(i,j) > 0 && ls(i,j) <= 0.001
            ls_pvalues(i,j) = 3;
        end

        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if ls_corrected(i,j) > 0.01 && ls_corrected(i,j) <= 0.05
            ls_pvalues(i,j) = 2;
        elseif ls_corrected(i,j) > 0.001 && ls_corrected(i,j) <= 0.01
            ls_pvalues(i,j) = 1;
        elseif ls_corrected(i,j) > 0 && ls_corrected(i,j) <= 0.001
            ls_pvalues(i,j) = 0;
        end
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if r(i,j) > 0.05
            r_pvalues(i,j) = 6;
        elseif r(i,j) > 0.01 && r(i,j) <= 0.05
            r_pvalues(i,j) = 5;
        elseif r(i,j) > 0.001 && r(i,j) <= 0.01
            r_pvalues(i,j) = 4;
        elseif r(i,j) > 0 && r(i,j) <= 0.001
            r_pvalues(i,j) = 3;
        end
        
        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if r_corrected(i,j) > 0.01 && r_corrected(i,j) <= 0.05
            r_pvalues(i,j) = 2;
        elseif r_corrected(i,j) > 0.001 && r_corrected(i,j) <= 0.01
            r_pvalues(i,j) = 1;
        elseif r_corrected(i,j) > 0 && r_corrected(i,j) <= 0.001
            r_pvalues(i,j) = 0;
        end
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if w(i,j) > 0.05
            w_pvalues(i,j) = 6;
        elseif w(i,j) > 0.01 && w(i,j) <= 0.05
            w_pvalues(i,j) = 5;
        elseif w(i,j) > 0.001 && w(i,j) <= 0.01
            w_pvalues(i,j) = 4;
        elseif w(i,j) > 0 && w(i,j) <= 0.001
            w_pvalues(i,j) = 3;
        end

        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if w_corrected(i,j) > 0.01 && w_corrected(i,j) <= 0.05
            w_pvalues(i,j) = 2;
        elseif w_corrected(i,j) > 0.001 && w_corrected(i,j) <= 0.01
            w_pvalues(i,j) = 1;
        elseif w_corrected(i,j) > 0 && w_corrected(i,j) <= 0.001
            w_pvalues(i,j) = 0;
        end
    end
end

% allocate 3-dim matrix for all p-values of each sleep stage
p_values = zeros(28,28,4);

% write p-values of each sleep stage into matrix
p_values(:,:,1) = ds_pvalues(:,:);
p_values(:,:,2) = ls_pvalues(:,:);
p_values(:,:,3) = r_pvalues(:,:);
p_values(:,:,4) = w_pvalues(:,:);

% plot matrix contraining all p-values
ma_plot_differences(p_values, 'colorbartext', 'p-values')



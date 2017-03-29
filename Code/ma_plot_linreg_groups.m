% script to read data of linear regression that was calculated with R and to
% plot the p-values of single testing aswell as the p-values after multiple
% test correction with bonferroni correction
% see R script ma_linreg_groups.R
%
%% Metadata
% Stefanie Breuer, 27.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0
%
% required variables from script ma_build_matrix_linreg_groups:
% linreg_mat;
% p_values;
% p_corrected;

%% Start
% extract p-values from 3-dim matrix into vectors for each sleep stage
ds_p_uncorrected = p_values(:,:,1);
ls_p_uncorrected = p_values(:,:,2);
r_p_uncorrected = p_values(:,:,3);
w_p_uncorrected = p_values(:,:,4);
ds_p_corrected = p_corrected(:,:,1);
ls_p_corrected = p_corrected(:,:,2);
r_p_corrected = p_corrected(:,:,3);
w_p_corrected = p_corrected(:,:,4);

% allocate matrices for p-values of each sleep stage
ds_pvalues = zeros(28,28);
ls_pvalues = zeros(28,28);
r_pvalues = zeros(28,28);
w_pvalues = zeros(28,28);

% loop over all p-values
for i = 1:length(ds_p_uncorrected)
    for j = 1:length(ds_p_uncorrected)
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if ds_p_uncorrected(i,j) > 0.05
            ds_pvalues(i,j) = 6;
        elseif ds_p_uncorrected(i,j) > 0.01 && ds_p_uncorrected(i,j) <= 0.05
            ds_pvalues(i,j) = 5;
        elseif ds_p_uncorrected(i,j) > 0.001 && ds_p_uncorrected(i,j) <= 0.01
            ds_pvalues(i,j) = 4;
        elseif ds_p_uncorrected(i,j) > 0 && ds_p_uncorrected(i,j) <= 0.001
            ds_pvalues(i,j) = 3;
        end

        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if ds_p_corrected(i,j) > 0.01 && ds_p_corrected(i,j) <= 0.05
            ds_pvalues(i,j) = 2;
        elseif ds_p_corrected(i,j) > 0.001 && ds_p_corrected(i,j) <= 0.01
            ds_pvalues(i,j) = 1;
        elseif ds_p_corrected(i,j) > 0 && ds_p_corrected(i,j) <= 0.001
            ds_pvalues(i,j) = 0;
        end
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if ls_p_uncorrected(i,j) > 0.05
            ls_pvalues(i,j) = 6;
        elseif ls_p_uncorrected(i,j) > 0.01 && ls_p_uncorrected(i,j) <= 0.05
            ls_pvalues(i,j) = 5;
        elseif ls_p_uncorrected(i,j) > 0.001 && ls_p_uncorrected(i,j) <= 0.01
            ls_pvalues(i,j) = 4;
        elseif ls_p_uncorrected(i,j) > 0 && ls_p_uncorrected(i,j) <= 0.001
            ls_pvalues(i,j) = 3;
        end

        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if ls_p_corrected(i,j) > 0.01 && ls_p_corrected(i,j) <= 0.05
            ls_pvalues(i,j) = 2;
        elseif ls_p_corrected(i,j) > 0.001 && ls_p_corrected(i,j) <= 0.01
            ls_pvalues(i,j) = 1;
        elseif ls_p_corrected(i,j) > 0 && ls_p_corrected(i,j) <= 0.001
            ls_pvalues(i,j) = 0;
        end
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if r_p_uncorrected(i,j) > 0.05
            r_pvalues(i,j) = 6;
        elseif r_p_uncorrected(i,j) > 0.01 && r_p_uncorrected(i,j) <= 0.05
            r_pvalues(i,j) = 5;
        elseif r_p_uncorrected(i,j) > 0.001 && r_p_uncorrected(i,j) <= 0.01
            r_pvalues(i,j) = 4;
        elseif r_p_uncorrected(i,j) > 0 && r_p_uncorrected(i,j) <= 0.001
            r_pvalues(i,j) = 3;
        end

        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if r_p_corrected(i,j) > 0.01 && r_p_corrected(i,j) <= 0.05
            r_pvalues(i,j) = 2;
        elseif r_p_corrected(i,j) > 0.001 && r_p_corrected(i,j) <= 0.01
            r_pvalues(i,j) = 1;
        elseif r_p_corrected(i,j) > 0 && r_p_corrected(i,j) <= 0.001
            r_pvalues(i,j) = 0;
        end
        
        % if uncorrected p-value is not significant, set to 6
        % set significant uncorrected p-values to 5, 4 or 3 regardiging to
        % their significance levels
        if w_p_uncorrected(i,j) > 0.05
            w_pvalues(i,j) = 6;
        elseif w_p_uncorrected(i,j) > 0.01 && w_p_uncorrected(i,j) <= 0.05
            w_pvalues(i,j) = 5;
        elseif w_p_uncorrected(i,j) > 0.001 && w_p_uncorrected(i,j) <= 0.01
            w_pvalues(i,j) = 4;
        elseif w_p_uncorrected(i,j) > 0 && w_p_uncorrected(i,j) <= 0.001
            w_pvalues(i,j) = 3;
        end

        % if corrected p-value is more significant than the uncorrected
        % p-value replace it by 2, 1 or 0 regarding to the reached
        % significance levels
        if w_p_corrected(i,j) > 0.01 && w_p_corrected(i,j) <= 0.05
            w_pvalues(i,j) = 2;
        elseif w_p_corrected(i,j) > 0.001 && w_p_corrected(i,j) <= 0.01
            w_pvalues(i,j) = 1;
        elseif w_p_corrected(i,j) > 0 && w_p_corrected(i,j) <= 0.001
            w_pvalues(i,j) = 0;
        end
    end
end

% allocate 3-dim matrix for all p-values of each sleep stages
p_values = zeros(28,28,4);

% write p-values of each sleep stage into matrix
p_values(:,:,1) = ds_pvalues(:,:);
p_values(:,:,2) = ls_pvalues(:,:);
p_values(:,:,3) = r_pvalues(:,:);
p_values(:,:,4) = w_pvalues(:,:);

% plot matrix contraining all p-values
ma_plot_differences(p_values, 'colorbartext', 'p-values')

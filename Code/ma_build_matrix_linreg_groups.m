% script to load linear regression data (slopes and p-values) that was 
% produced in R (see R script ma_linreg_groups.R), to write the data from 
% vectors into matrices and to plot slopes
% use matlab script ma_plot_linreg_groups.m afterwards to plot p-values
% load linear regression data that was produced in R
% m = slope, p = p-value
%
%% Metadata
% Stefanie Breuer, 27.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% load data of slopes and p-values from linear regression that was produced
% in R
load('linreg_m_ds.mat')
load('linreg_m_ls.mat')
load('linreg_m_r.mat')
load('linreg_m_w.mat')
load('linreg_p_ds.mat')
load('linreg_p_ls.mat')
load('linreg_p_r.mat')
load('linreg_p_w.mat')
load('linreg_p_ds_corrected.mat')
load('linreg_p_ls_corrected.mat')
load('linreg_p_r_corrected.mat')
load('linreg_p_w_corrected.mat')

% allocate matrices for slopes and p-values
linreg_mat = zeros(28,28,4);
p_values = zeros(28,28,4);
p_corrected = zeros(28,28,4);

% write slope m into lower left triangle of 3-dim matrix for deep sleep
j = 1;
i = j+1;
for k = 1:length(linreg_m_ds)
    linreg_mat(i,j,1) = linreg_m_ds(k);
    if i == 28
        j = j+1;
        i = j+1;
    else
    i = i+1;
    end
end

% write slope m into lower left triangle of 3-dim matrix for light sleep
j = 1;
i = j+1;
for k = 1:length(linreg_m_ls)
    linreg_mat(i,j,2) = linreg_m_ls(k);
    if i == 28
        j = j+1;
        i = j+1;
    else
    i = i+1;
    end
end
% write slope m into lower left triangle of 3-dim matrix for rem sleep
j = 1;
i = j+1;
for k = 1:length(linreg_m_r)
    linreg_mat(i,j,3) = linreg_m_r(k);
    if i == 28
        j = j+1;
        i = j+1;
    else
    i = i+1;
    end
end
% write slope m into lower left triangle of 3-dim matrix for wake
j = 1;
i = j+1;
for k = 1:length(linreg_m_w)
    linreg_mat(i,j,4) = linreg_m_w(k);
    if i == 28
        j = j+1;
        i = j+1;
    else
    i = i+1;
    end
end

% ---------------------------------------------------------

% write p-values into upper right triangle of 3-dim matrix for deep sleep
i = 1;
j = i+1;
for k = 1:length(linreg_p_ds)
    p_values(i,j,1) = linreg_p_ds(k);
    p_corrected(i,j,1) = linreg_p_ds_corrected(k);
    if j == 28
        i = i+1;
        j = i+1;
    else
        j = j+1;
    end
end
% write p-values into upper right triangle of 3-dim matrix for ligth sleep
i = 1;
j = i+1;
for k = 1:length(linreg_p_ls)
    p_values(i,j,2) = linreg_p_ls(k);
    p_corrected(i,j,2) = linreg_p_ls_corrected(k);
    if j == 28
        i = i+1;
        j = i+1;
    else
        j = j+1;
    end
end
% write p-values into upper right triangle of 3-dim matrix for rem sleep
i = 1;
j = i+1;
for k = 1:length(linreg_p_r)
    p_values(i,j,3) = linreg_p_r(k);
    p_corrected(i,j,3) = linreg_p_r_corrected(k);
    if j == 28
        i = i+1;
        j = i+1;
    else
        j = j+1;
    end
end
% write p-values into upper right triangle of 3-dim matrix for wake
i = 1;
j = i+1;
for k = 1:length(linreg_p_w)
    p_values(i,j,4) = linreg_p_w(k);
    p_corrected(i,j,4) = linreg_p_w_corrected(k);
    if j == 28
        i = i+1;
        j = i+1;
    else
        j = j+1;
    end
end

% plot linear regression slopes for each link
% to plot p-values use script ma_plot_linreg_groups.m
ma_plot_differences(linreg_mat, 'colorbartext', 'linreg')



% linreg_mat_all = linreg_mat;
% p_values_all = p_values;
% p_corrected_all = p_corrected;
% save('linreg_mat_all.mat', 'linreg_mat_all')
% save('p_values_all.mat', 'p_values_all')
% save('p_corrected_all.mat', 'p_corrected_all')

% linreg_mat_female = linreg_mat;
% p_values_female = p_values;
% p_corrected_female = p_corrected;
% save('linreg_mat_female.mat', 'linreg_mat_female')
% save('p_values_female.mat', 'p_values_female')
% save('p_corrected_female.mat', 'p_corrected_female')

% linreg_mat_male = linreg_mat;
% p_values_male = p_values;
% p_corrected_male = p_corrected;
% save('linreg_mat_male.mat', 'linreg_mat_male')
% save('p_values_male.mat', 'p_values_male')
% save('p_corrected_male.mat', 'p_corrected_male')

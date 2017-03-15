function nmean_age = calculate_nmean_age(varargin)
% calculates nmean and creates matrix containing nmean and age for each
% patient per sleep stage
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 015.03.2017, stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: [nmean_age] = calculate_nmean_age('group', 'heart');
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
        end
    end
end


%% load structs and find indices of groups


% script to extract all tds matrices and calculate the nmean for each
% patient of the insomnia charite dataset 
%
% author: Stefanie Breuer
% date: 15.03.2017
% -------------------------------------------------------------------------

load('insomresults.mat')
load('insomdata.mat')

% find sex
ind_all = [1:64];
all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
all_f = ind_all(all_f); % indices of all w
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = ind_all(all_m); % indices of all m

if strcmp(group, 'all')
    leng = length(insomresults);
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


for i = 1:leng
    patid = insomresults(data(i)).name;
    tdsmat = insomresults(data(i)).result;
    for j = 1:length(insomdata)
        patedf = insomdata(data(i)).edffile;
        patage = insomdata(data(i)).age;
        if strcmp(patedf(1:end-20), patid)
            for s = 1:4
                tdssum = 0;
                for k = 1:length(tdsmat)
                    for l = k+1:length(tdsmat)
                        tdssum = tdssum+tdsmat(k, l, s);
                    end
                end
                nmean_age(i, 1, s) = tdssum/((length(tdsmat)^2)/2 - length(tdsmat));
                nmean_age(i, 2, s) = patage;
            end
        end
    end
end

if strcmp(group, 'f')
    nmean_age_f = nmean_age;
elseif strcmp(group, 'm')
    nmean_age_m = nmean_age;
end

if strcmp(group, 'all')
    save('nmean_age.mat', 'nmean_age')
    
    nmean_ds = nmean_age(:, 1, 1);
    age_ds = nmean_age(:, 2, 1);

    nmean_ls = nmean_age(:, 1, 2);
    age_ls = nmean_age(:, 2, 2);

    nmean_r = nmean_age(:, 1, 3);
    age_r = nmean_age(:, 2, 3);

    nmean_w = nmean_age(:, 1, 4);
    age_w = nmean_age(:, 2, 4);
elseif strcmp(group, 'f')
    save('nmean_age_f.mat', 'nmean_age_f')
elseif strcmp(group, 'm')
    save('nmean_age_m.mat', 'nmean_age_m')
end








function nmean_age = calculate_nmean_age(varargin)
% calculates nmean and creates matrix containing nmean and age for each
% patient per sleep stage
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 15.03.2017
% stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: nmean_age = ma_calculate_nmean_age('group', 'all');
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
% load data
load('insomresults.mat')
load('insomdata.mat')

% find sex for whole group
ind_all = [1:64];
all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
all_f = ind_all(all_f); % indices of all w
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = ind_all(all_m); % indices of all m
% find sex for insomnia group
% find indices of group insom
insom = arrayfun(@(x) strfind(x.group, 'none'), insomdata, 'UniformOutput', 0);
ind_insom = find(~cellfun('isempty', insom));
insom_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata(ind_insom));
insom_f = ind_insom(insom_f); % indices of all w with insomnia
insom_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata(ind_insom));
insom_m = ind_insom(insom_m); % indices of all m with insomnia

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
elseif strcmp(group, 'insom')
    leng = length(ind_insom);
    data = ind_insom;
    nmean_age = zeros(leng, 2, 4);
elseif strcmp(group, 'insom-female')
    leng = length(insom_f);
    data = insom_f;
    nmean_age = zeros(leng, 2, 4);
elseif strcmp(group, 'insom-male')
    leng = length(insom_m);
    data = insom_m;
    nmean_age = zeros(leng, 2, 4);
end

% loop over group
for i = 1:leng
    % extract patient id and result matrix
    patid = insomresults(data(i)).name;
    tdsmat = insomresults(data(i)).result;
    for j = 1:length(insomdata)
        % extract edffilename with patient id and age
        patedf = insomdata(j).edffile;
        patage = insomdata(j).age;
        % check if same patient id
        if strcmp(patedf(1:end-20), patid)
            % loop over sleep stages
            for s = 1:4
                tdssum = 0;
                % loop over result matrix in x and y direction
                for k = 1:length(tdsmat)
                    for l = k+1:length(tdsmat)
                        % sum link strengths for each sleep stage
                        tdssum = tdssum+tdsmat(k, l, s);
                    end
                end
                % calculate global mean link strength and age for each
                % patient and sleep stage
                nmean_age(i, 1, s) = tdssum/(((length(tdsmat)^2) - length(tdsmat))/2);
                nmean_age(i, 2, s) = patage;
            end
        end
    end
end

if strcmp(group, 'f')
    nmean_age_f = nmean_age;
elseif strcmp(group, 'm')
    nmean_age_m = nmean_age;
elseif strcmp(group, 'insom')
    nmean_age_insom = nmean_age;
elseif strcmp(group, 'insom-female')
    nmean_age_insom_f = nmean_age;
elseif strcmp(group, 'insom-male')
    nmean_age_insom_m = nmean_age;
end

% save variables
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
elseif strcmp(group, 'insom')
    save('nmean_age_insom.mat', 'nmean_age_insom')
elseif strcmp(group, 'insom-female')
    save('nmean_age_insom_f.mat', 'nmean_age_insom_f')
elseif strcmp(group, 'insom-male')
    save('nmean_age_insom_m.mat', 'nmean_age_insom_m')
end

end

function [linkmat_insom, linkmat_match] = ma_calculate_links_insom_siesta(varargin)
% % function to extract tds matrices of insomnia and matches data for
% testing in R with script ma_link_populations_test.R
% in R t-tests are performed if data has normal distribution and same variance
% Welch-tests are performed if data has normal distribution and different variance
% Wilcoxon rank sum test (u-test) is performed if no normal distribution

%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 25.03.2017
% stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: [linkmat_insom, linkmat_match] = ma_calculate_links_insom_siesta('group', 'all',...
%            'insomdata', insomdata, 'insomstruct', insomresults, 'matches', matches, ...
%            'siestastruct', bothnights);
%
%INPUT:
% group         can be 'all', 'f', 'm' for whole group, female or male
%
%OPTIONAL INPUT:
% insomdata     insomdata struct
% insomstruct   insomresults struct
% matches       matches array
% siestastruct  siestaresults of bothnights
%
%OUTPUT
% linkmat_insom    
% and             matrix containing smean for each patient of insomnia and
% linkmat_match   matched control group per sleep stage
% 
%               
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
        if strcmp(varargin{i},'group')
            group = varargin{i+1};
        elseif strcmp(varargin{i},'insomdata')
            insomdata = varargin{i+1};
        elseif strcmp(varargin{i},'insomstruct')
            insomresults = varargin{i+1};
        elseif strcmp(varargin{i},'matches')
            matches = varargin{i+1};
        elseif strcmp(varargin{i},'siestastruct')
            bothnights = varargin{i+1};
        end
    end
end

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
all = [1:64]; %all
all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
all_f = all(all_f); %all female
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
all_m = all(all_m); %all male

% compare group input
if strcmp(group, 'all')
    leng = length(all);
    data = all;
    linkmat_insom = zeros(leng, 378, 4);
    linkmat_match = zeros(leng, 378, 4);
elseif strcmp(group, 'female')
    leng = length(all_f);
    data = all_f;
    linkmat_insom = zeros(leng, 378, 4);
    linkmat_match = zeros(leng, 378, 4);
elseif strcmp(group, 'male')
    leng = length(all_m);
    data = all_m;
    linkmat_insom = zeros(leng, 378, 4);
    linkmat_match = zeros(leng, 378, 4);
end

% loop over group
for i = 1:leng
    
    % extract name
    pat_id = insomdata(data(i)).edffile;
    
    % loop over insomresults
    for j = 1:length(insomresults)
        
        % extract name
        pat_id_results = insomresults(j).name;
        
        % check if same insomnia patient
        if strcmp(pat_id(1:end-20), pat_id_results)
            
            % extract tds matrices from insomnia patients and matched controls
            tds_insom = insomresults(data(i)).result;
            tds_siesta = bothnights(matches(data((i)))).tds_stages;
            
            % delete frontopolar eegs from matches tds matrix for comparison
            tds_siesta(24:28,:,:) = [];
            tds_siesta(:,24:28,:) = [];
            tds_siesta(9:13,:,:) = [];
            tds_siesta(:,9:13,:) = [];
            
            % loop over tds matrix
            k = 1;
            for m = 1:length(tds_insom)
                for n = m+1:length(tds_insom)
                    
                    % writa data into allocated matrices
                    linkmat_insom(i,k,:) = tds_insom(m,n,:);
                    linkmat_match(i,k,:) = tds_siesta(m,n,:);
                    k = k+1;
                end
            end
        end
    end
    
    % extract sleep stages for easy handling in R
    link_insom_ds = linkmat_insom(:,:,1);
    link_insom_ls = linkmat_insom(:,:,2);
    link_insom_r = linkmat_insom(:,:,3);
    link_insom_w = linkmat_insom(:,:,4);
    link_match_ds = linkmat_match(:,:,1);
    link_match_ls = linkmat_match(:,:,2);
    link_match_r = linkmat_match(:,:,3);
    link_match_w = linkmat_match(:,:,4);
    
    % save variables for loading in R
    save('link_insom_ds.mat', 'link_insom_ds')
    save('link_insom_ls.mat', 'link_insom_ls')
    save('link_insom_r.mat', 'link_insom_r')
    save('link_insom_w.mat', 'link_insom_w')
    save('link_match_ds.mat', 'link_match_ds')
    save('link_match_ls.mat', 'link_match_ls')
    save('link_match_r.mat', 'link_match_r')
    save('link_match_w.mat', 'link_match_w')
    
end

end


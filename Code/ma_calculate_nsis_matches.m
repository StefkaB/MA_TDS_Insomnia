function meannsis = ma_calculate_nsis_matches(varargin)
% calculates mean of nsis (number of epochs per sleep stage) for matches
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 27.03.2017
% stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: meannsis = ma_calculate_nsis_matches('group', 'all', ...
%            'siestastruct', bothnights, 'matches', matches);
%
%INPUT:
% group          can be 'all', 'female' or 'male'  
% siestastruct   bothnights struct containing healthy control
% matches        vector containing als bothnights indices of matches
%
%OUTPUT
% meannsis       mean values of nsis (nsis represents the number of epochs
%                per sleep stage with 1=DS, 2=LS, 3=REM, 4=WAKE)
%
% Modification List

%% Defaults
group = 'all';
all_ind = 1:64;

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
        elseif strcmp(varargin{i},'siestastruct')
            bothnights = varargin{i+1};
        elseif strcmp(varargin{i},'matches')
            matches = varargin{i+1};
        end
    end
end


%% load structs and find indices of groups
load('insomdata.mat')
load('insomresults.mat')

all_f = arrayfun(@(x) strcmp(x.sex, 'w'), insomdata);
f_ind = all_ind(all_f); % indices of all w
all_m = arrayfun(@(x) strcmp(x.sex, 'm'), insomdata);
m_ind = all_ind(all_m); % indices of all m

% check group input
if strcmp(group, 'all')
    group_ind = all_ind;
elseif strcmp(group, 'female')
    group_ind = f_ind;
elseif strcmp(group, 'male')
    group_ind = m_ind;
end

%% calculate mean of nsis for whole data
% allocate vector
groupnsis = zeros(4, 1);

% loop over group
for i = 1:length(group_ind)
    
    % extract nsis from struct
    nsis = bothnights(matches(group_ind(i))).nsis;
    
    % add nsis
    groupnsis = groupnsis + nsis;
end
% calculate mean number of epochs per sleep stage
meannsis = groupnsis/length(group_ind);


end

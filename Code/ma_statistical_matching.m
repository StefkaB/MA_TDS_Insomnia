% script for age and gender matching between insomnia data and healthy
% controls from siesta study
%
%% Metadata
% Stefanie Breuer, 25.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0

%% Start

% load structs of insomnia and siesta dta
% load('insomdata.mat')
% load('insomresults.mat')
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

% define array for bothnights indices of matches
leng_insom = length(insomdata);
leng_bothnights = length(bothnights);
leng_siesta = length(siesta);
controls = ones(1,leng_bothnights);
matches = zeros(1,leng_insom);

n = 1;
step = 1;
% loop over all insomnia patients and extract gender and age
for i = 1:leng_insom
    gender_insom = insomdata(i).sex;
    age_insom = insomdata(i).age;
    % convert german 'w' into english 'f'
    if strcmp(gender_insom, 'w')
        gender_insom = 'f';
    end
    % loop over remaining siesta patients and extract patient id
    for j = n:leng_bothnights
        patid_siesta_bothnights = bothnights(j).edffilename;
        % loop over siesta struct and extract patient id
        for k = 1:length(siesta)
            patid_siesta = siesta(k).name;
            % check if same patient id
            if strcmp(patid_siesta_bothnights(1:end-6), patid_siesta)
                % extract gender and age of siesta
                age_siesta = siesta(k).age;
                gender_siesta = siesta(k).sex;
                % check for match of gender and age +-1
                if controls(j) ~= 0 && age_siesta>age_insom-2 && ...
                    age_siesta<age_insom+2 && strcmp(gender_siesta,gender_insom)
                    % check if controls is still available and no match yet
                    if controls(j) == 1 && matches(i) == 0
                        matches(i) = j;
                        % delete bothnights index of match from controls
                        controls(j) = 0;
                        % check for other psg of this control patient
                        for l = 1:leng_bothnights
                            pat2delete = bothnights(l).edffilename;
                            % delete all psgs from this control patient
                            if strcmp(pat2delete(1:end-6), patid_siesta_bothnights(1:end-6))
                                controls(l) = 0;
                            end
                        end
                        % increase index n to prevent matches from only first sleep labs
                        n = j+1;
                        break;
                    end
                end
            end
        end
        % reinitialize n if it is bigger than bothnights to loop again
        if j == leng_bothnights
            n = step+1;
            % increase starting point of bothnights loop for every new loop
            step = step+1;
        end
    end
    
end




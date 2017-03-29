%% analyse both nights of healthy subjects together
%% read siesta struct
% pathes
siestapath = 'C:\Users\Stefka\Documents\MATLAB\SomnoNetz_m-Files\test_functions\TDS';
%resultpath
resultpath = 'RESULTS';

%% load data
load(fullfile(siestapath,'siesta_all_consent_26-May-2015.mat'));

%% get all nights from healthy subject 
%(these are anyhow currently the only ones)

edf_index_healthy = arrayfun(@(x) (isstruct(x.night) & strcmp('healthy',x.status)), siesta);


%all first nights
%all first nights with valid data
firstnight_field = arrayfun(@(x) (~isempty(x.night(1).rrfilename)),...
                                        siesta(edf_index_healthy));
firstnight = arrayfun(@(x) x.night(1), siesta(edf_index_healthy)) ;

%all second nights
secondnight_field = arrayfun(@(x) (length(x.night) == 2 & strcmp('healthy',x.status)),...
                                        siesta);
secondnight = arrayfun(@(x) x.night(2), siesta(secondnight_field));

% 

% 
%concat first and second night
bothnights = [firstnight secondnight];
% 
%loop over firstnight
% for i = 1:length(bothnights)
%     %check if array is filled
%     disp(bothnights(i).edffilename)
% end
% 
% % normalize values
% bn_tds_stages = bn_tds_stages./repmat(reshape(bn_nsis,1,1,4),38,38,1);

%% plot results

% load('tds_colormap2.mat')
% outfilebase = fullfile(siestapath,resultpath,'siesta_healthy');
% sn_plotTDSMatrixSiestaAll(bn_tds_stages,'subject','Healthy','outfilebase',outfilebase,'colormap',tds_colormap2)

%% save results

% save(fullfile(siestapath,resultpath,'meanTDS_stages_healthy_bn.mat'),...
%     'bn_tdss_stages_mean','bn_tdss_stages_median','bn_tdss_stages_std',...
%     'bn_tdss_stages_min','bn_tdss_stages_max',...
%     'bn_tds_stages','bothnights','bn_tdss_stages','-v7.3')
% 
% %% plot with threshold
% 
%  outfilebase = fullfile(siestapath,resultpath,'siesta_healthy_tdss_mean_bn_bin_0.07');
%  sn_plotTDSMatrixSiestaAll(bn_tdss_stages_mean,'subject','Healthy TDSS mean, Threshold = 7 %','outfilebase',outfilebase,'fth',0.07)
% 
%  outfilebase = fullfile(siestapath,resultpath,'siesta_healthy_bn_bin_0.07');
%  sn_plotTDSMatrixSiestaAll(bn_tds_stages,'subject','Healthy, Threshold = 7 %','outfilebase',outfilebase,'fth',0.07)
% 
%  outfilebase = fullfile(siestapath,resultpath,'siesta_healthy_tdss_median_1stnight_bin_0.07');
%  sn_plotTDSMatrixSiestaAll(fn_tdss_stages_median,'subject','Healthy 1st night TDSS median, Threshold = 7 %','outfilebase',outfilebase,'fth',0.07)
%  
%  outfilebase = fullfile(siestapath,resultpath,'siesta_healthy_tdss_median_2ndnight_bin_0.07');
%  sn_plotTDSMatrixSiestaAll(fn2_tdss_stages_median,'subject','Healthy 2nd night TDSS median, Threshold = 7 %','outfilebase',outfilebase,'fth',0.07)
% 

function [tdss,nsis,siesta_ids] = sn_getSiestaDataTDSS(siesta,siesta_b,varargin)
%gets the tds and nsis of all valid data, gets rid of empty first nights and
%not existing second nights 
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 2.6.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: [tds,nsis] = sn_getSiestaData(siesta,varargin)
% INPUT:
% siesta      siesta-struct    
% siesta_b    logical array of siesta-structs of interest, length of
% siesta-subjects
%
%OPTIONAL INPUT:
% 
%
%OUTPUT:
% tdss        4-D Vector of (scorr,scorr,4,nrecords), where the last index
%            refers to the number of valid records found in both nights
% nsis       referring nsis-data
% siesta_ids array containing the referring indices of siesta subjects
%
%MODIFICATION LIST:
%
%------------------------------------------------------------
%% Defaults

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %tolerance
        if strcmp(varargin{i},'nsis')
            nsis = varargin{i+1};
            %placeholder
        elseif strcmp(varargin{i},'emin')
            emin = varargin{i+1};
        end
    end
end

%check for existing struct "night"
%get indexes of matching data
siesta_idx = find(siesta_b);
%you get a logical array of length matching data
night_struct = arrayfun(@(x) isstruct(x.night), siesta(siesta_b));
%get rid of non-existing night subject
siesta_idx = siesta_idx(night_struct);

%check if first night exists
fn_exists = arrayfun(@(x) ~isempty(x.night(1).tds), siesta(siesta_idx));
%get indices for first-nights
fn_siesta_idx = siesta_idx(fn_exists);
%get the first nights, make it in two steps probably
%get struct
fn_night = arrayfun(@(x) x.night(1), siesta(fn_siesta_idx));
% whos fn_night
% cat the tds_stages
fn_tdss = cat(4,fn_night(:).tds_stages);
%cat nsis    
fn_nsis = cat(2,fn_night(:).nsis);

%check if second night exists
sn_exists = arrayfun(@(x) length(x.night) == 2, siesta(siesta_idx));
%get indices for first-nights
sn_siesta_idx = siesta_idx(sn_exists);
%get struct of second nights
sn_night = arrayfun(@(x) x.night(2), siesta(sn_siesta_idx));
% whos fn_night
% cat the tds_stages
sn_tdss = cat(4,sn_night(:).tds_stages);
%cat nsis    
sn_nsis = cat(2,sn_night(:).nsis);


%concat data 
tdss = cat(4,fn_tdss,sn_tdss);
nsis = cat(2,fn_nsis,sn_nsis);
siesta_ids = cat(2,fn_siesta_idx,sn_siesta_idx); 


function sn_plotTDSMatrixSiestaAll(tds_stages,varargin)
%plots result of tds-analysis as four matrices for charite data
%based on sn_plotTDSMatrixSiestaAll.m and revised to make it valid for charite
%data
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 08.03.2017, stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: sn_plotTDSMatrixSiestaAll(TDS-matrix,varargin)
% INPUT:
% tds    matrix of intersignal stability, dims: (38x38x4)
%
%OPTIONAL INPUT:
% slabels    vector containing the labels of the signals
% fth        fraction threshold for significant stability, default: 0.07
% outfilebase filebase for print, default:no printing)
% colormap  colormap to be used
%OUTPUT:
% none

%MODIFICATION LIST:
%
%------------------------------------------------------------
%%defaults

subject = '';

rlabels = {'Tiefschlaf';'Leichtschlaf';'REM-Schlaf';'Wachzustand'};
tdslabels = {'HR';'BR_{air}';'BR_c';'BR_a';'Chin';'Leg';...
    'Eye_1';'Eye_2';...
    '\delta C3';'\theta C3';'\alpha C3';'\sigma C3';'\beta C3';...
    '\delta O1';'\theta O1';'\alpha O1';'\sigma O1';'\beta O1';...
    '\delta C4';'\theta C4';'\alpha C4';'\sigma C4';'\beta C4';...
    '\delta O2';'\theta O2';'\alpha O2';'\sigma O2';'\beta O2'};

eeglabels = {'C3';'O1';'C4';'O2'};
ticks = [0.5,4.5,8.5,13.5,18.5,23.5,28.5];
borders = [0,39];

%outfilebase
outfilebase = '';
cmap = 'default';
% flag for thresholding
binflag = 0;

whos labels
%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %samplingfrequency
        if strcmp(varargin{i},'subject')
            subject = varargin{i+1};
            %labels
        elseif strcmp(varargin{i},'outfilebase')
            outfilebase = varargin{i+1};
        elseif strcmp(varargin{i},'colormap')
            cmap = varargin{i+1};
       elseif strcmp(varargin{i},'fth')
            fth = varargin{i+1};
            binflag = 1; 
        end
    end
end

%Awake
for stage = 4:-1:1
    figure(stage)
    if binflag
        imagesc(tds_stages(:,:,stage) >= fth)
    else
        imagesc(tds_stages(:,:,stage))
    end
    title([subject ' ' rlabels{stage}])
    pbaspect([1 1 1])
    colormap(cmap)
    colorbar
    
    for k = 1:length(tdslabels)
        text(-4,k,tdslabels{k})
    end
    for m = 1:length(eeglabels)
        text(ticks(m+2)+2,30,eeglabels{m})
    end
    set(gca,'XColor','r', 'YColor','r')
    set(gca,'ytick',[0.5,4.5,8.5,13.5,18.5,23.5,28.5]);
    set(gca,'yticklabel','    ');
    set(gca,'xtick',[0.5,4.5,8.5,13.5,18.5,23.5,28.5]);
    set(gca,'xticklabel','');
    %set(gca,'ytick',[1:length(C)],'yticklabel',labelvector);
    set(gca,'GridLineStyle','-');
    grid on
    
    hold on
    for i = 2:length(ticks)
        plot(borders,[ticks(i),ticks(i)],'r')
        plot([ticks(i),ticks(i)],borders,'r')
        
    end
    hold off
    
    %%print
    if ~isempty(outfilebase)
        imagepng = [outfilebase '_' rlabels{stage} '_tds_matrix_val.png'];
        print('-dpng',[ imagepng])
    end
    
end




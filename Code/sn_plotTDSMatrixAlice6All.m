function sn_plotTDSMatrixAlice6All(tds_stages,varargin)
%plots result of tds-analysis as four matrices
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 16.4.2015, dagmar.krefting@htw-berlin.de
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
% debug       verbose output, default: 0
%OUTPUT:
%none

%MODIFICATION LIST:
%
%------------------------------------------------------------
%%defaults
debug = 0;
subject = '';

rlabels = {'DS';'LS';'REM';'Awake'};
tdslabels = {'HR';'Airfl.';'Chest';'Abd.';'Airfl.';'Chin';'Leg';'Leg2';...
    'Eye1';'Eye2';...
    '\delta Fp1';'\theta Fp1';'\alpha Fp1';'\sigma Fp1';'\beta Fp1';...
    '\delta C3';'\theta C3';'\alpha C3';'\sigma C3';'\beta C3';...
    '\delta O1';'\theta O1';'\alpha O1';'\sigma O1';'\beta O1';...
    '\delta Fp2';'\theta Fp2';'\alpha Fp2';'\sigma Fp2';'\beta Fp2';...
    '\delta C4';'\theta C4';'\alpha C4';'\sigma C4';'\beta C4';...
    '\delta O2';'\theta O2';'\alpha O2';'\sigma O2';'\beta O2'};

eeglabels = {'Fp1';'C3';'O1';'Fp2';'C4';'O2'};
ticks = [0.5,5.5,8.5,10.5,15.5,20.5,25.5,30.5,35.5,40.5];
borders = [0,41];

%outfilebase
outfilebase = '';
filelabel = '';
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
            disp('outfilebase found')
            outfilebase = varargin{i+1};
            disp(['outfilebase: ' outfilebase])
        elseif strcmp(varargin{i},'colormap')
            cmap = varargin{i+1};
       elseif strcmp(varargin{i},'fth')
            fth = varargin{i+1};
            binflag = 1; 
        end
    end
end

%check for additional airflow signal, delete
if (size(tds_stages,1) == 41)
    disp('Dimension is 41, removing additional Airflow signal...')
    tds_stages(5,:,:) = [];
    tds_stages(:,5,:) = [];
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
        text(ticks(m+2)+2,size(tds_stages,1),eeglabels{m})
    end
    set(gca,'XColor','r', 'YColor','r')
    set(gca,'ytick',ticks);
    set(gca,'yticklabel','    ');
    set(gca,'xtick',ticks);
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
    if debug
        disp('Checking for outfilebase...')
    end
    if ~isempty(outfilebase)
        imagepng = [outfilebase '_' rlabels{stage} '_tds_matrix_val.png'];
     if debug
        disp(['Print: ' imagepng])
    end
       
        print('-dpng',[ imagepng])
    end
    
end




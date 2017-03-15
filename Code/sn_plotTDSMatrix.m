function sn_plotTDSMatrix(tds,varargin)
%plots result of tds-analysis as four matrices
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 28.5.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: sn_plotTDSMatrix(TDS-matrix,varargin)
% INPUT:
% tds    matrix of intersignal stability, dims: (10x10x4)
%
%OPTIONAL INPUT:
% slabels    vector containing the labels of the signals
% fth        fraction threshold for significant stability, default: 0.07
% outfilebase filebase for print, default:no printing)
%
%OUTPUT:
%none

%MODIFICATION LIST:
%
%------------------------------------------------------------
%% Defaults
fth = 0.07;
rlabels = {'DS';'LS';'REM';'Awake'};
tdslabels = {'HR';'Resp';'Chin';'Leg';'Eye';...
    '\delta';'\theta';'\alpha';'\sigma';'\beta'};

%number of stages
nst = size(tds,3);
%number of signals
%ns = sqrt(size(tds,2));

%outfilebase
outfilebase = '';
filelabel = '';

whos labels
%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %samplingfrequency
        if strcmp(varargin{i},'fth')
            sf = varargin{i+1};
            %labels
        elseif strcmp(varargin{i},'tdslabels')
            tdslabels = varargin{i+1};
        elseif strcmp(varargin{i},'rlabels')
            rlabels = varargin{i+1};
        elseif strcmp(varargin{i},'rowdim')
            rowdim = varargin{i+1};
        elseif strcmp(varargin{i},'outfilebase')
            outfilebase = varargin{i+1};
       end
    end
end

if ~isempty(outfilebase)
    [pathstr,filelabel,ext] = fileparts(outfilebase);
    filelabel = upper(filelabel);
end

%tdssm = reshape(tds,nst,ns,ns);

%plot tds
figure(34)

for i = 1:nst
    %Awake
    subplot(4,1,5-i)
    
    imagesc(squeeze(tds(:,:,i))>fth)
    pbaspect([1 1 1])
    colormap('default')
    colormap(flipud(colormap))
    %title
    title([filelabel ' ' rlabels{i}])
    %title('test')
    %Individual Labels to mix greek and latin
    for k = 1:10
        text(-2,k,tdslabels{k})
    end
    %remove automatic labels
    set(gca,'ytick',(0.5:9.5));
    set(gca,'yticklabel','    ');
    set(gca,'xtick',(0.5:9.5));
    set(gca,'xticklabel','');
    %set(gca,'ytick',[1:length(C)],'yticklabel',labelvector);
    set(gca,'GridLineStyle','-');
    grid on
    %Stage labels
    %if strcmp(rowdim,'stages')
    %   set(gca,'xtick',[1:size(tds,1)],'xticklabel',rlabels);
    %   xlabel('Sleep Stages')
    %else
    %    xlabel('t[30s]')
    %end
end

if ~isempty(outfilebase)
set(gcf,'PaperUnits','normalized', 'PaperPosition',[0 0 0.5 1])
imagepng = '_tds_matrix_bin.png';
print('-dpng',[ outfilebase imagepng ])
end 

%plot tds
figure(35)

for i = 1:nst
    %Awake
    subplot(4,1,5-i)
    
    imagesc(squeeze(tds(:,:,i)))
    pbaspect([1 1 1])
    set(gca,'clim',[0,0.5])
    colorbar
    %title
   title([filelabel ' ' rlabels{i}])
    %title('test')
    %Individual Labels to mix greek and latin
    for k = 1:10
        text(-2,k,tdslabels{k})
    end
    %remove automatic labels
    set(gca,'ytick',(0.5:9.5));
    set(gca,'yticklabel','    ');
    set(gca,'xtick',(0.5:9.5));
    set(gca,'xticklabel','');
    %set(gca,'ytick',[1:length(C)],'yticklabel',labelvector);
    set(gca,'GridLineStyle','-');
    grid on
    %Stage labels
    %if strcmp(rowdim,'stages')
    %   set(gca,'xtick',[1:size(tds,1)],'xticklabel',rlabels);
    %   xlabel('Sleep Stages')
    %else
    %    xlabel('t[30s]')
    %end
end
if ~isempty(outfilebase)
set(gcf,'PaperUnits','normalized', 'PaperPosition',[0 0 0.5 1])
imagepng = '_tds_matrix_val.png';
print('-dpng',[ outfilebase imagepng])
end 

%end function
end






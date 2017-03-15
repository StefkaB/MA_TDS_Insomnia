function sn_plotTDSMatrixChariteAll(tds_stages,varargin)
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
% cbaxis2   vector for a second ticks on colormap, default: empty
% cblabel   string label for colormap, default: empty
% cblabel2  string label for second colormap axes: default: empty
% cbtlabels2 string cell with labels for ticks
% multiplot  if set to 1, all matrices are plotted in one plot.
% cbaxisreverse if set to 1 put, default axis at the left side
% debug      if set, print information, default = false
%OUTPUT:
%none

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
filelabel = '';
cmap = 'default';
% flag for thresholding
binflag = 0;

% colorbar settings

cb2file = false;
cbaxis2 = '';
cblabel = 'Mean link strength (l_{tds})';
cblabel2 = '';
cbtlabels2 = '';
% colorbaraxishandle
cb2h = '';
cbaxisreverse = false;
cbaxislocation = 'out';

%multiplot
mplot = false
%positionvectors [left, bottom, width, height]

w = 0.45;
ll = 0.01;
lr = 0.4;
bt = 0.52;
bb = 0.03;
pvector =  [ll bt w w;...
    lr bt w w;...
    ll bb w w;...
    lr bb w w];

%colorbarposition in multiplot
cbpos = [0.8 0.07 0.02 0.86];

%colorbarposition if second label in single plots
cbpos1 = [0.9 0.11 0.02 0.815];

debug = false;

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
        elseif strcmp(varargin{i},'cb2file')
            cb2file = varargin{i+1};
        elseif strcmp(varargin{i},'cblabel')
            cblabel = varargin{i+1};
        elseif strcmp(varargin{i},'cbaxisreverse')
            cbaxisreverse = varargin{i+1};
        elseif strcmp(varargin{i},'cbaxis2')
            cbaxis2 = varargin{i+1};
        elseif strcmp(varargin{i},'cblabel2')
            cblabel2 = varargin{i+1};
        elseif strcmp(varargin{i},'cbtlabels2')
            cbtlabels2 = varargin{i+1};
        elseif strcmp(varargin{i},'multiplot')
            mplot = varargin{i+1};
        elseif strcmp(varargin{i},'debug')
            debug = varargin{i+1};
        elseif strcmp(varargin{i},'fth')
            fth = varargin{i+1};
            binflag = 1;
        end
    end
end

%get maximal and minimal values for all images, to get clim (consistent
%color coding

cmax = max(max(max(tds_stages)));
cmin = min(min(min(tds_stages)));

clims = [cmin,cmax];



%% Loop over stages
%create multiplot figure
if (mplot)
    fh = figure(21)
    clf(fh)
    fh.Units = 'normalized';
    %Position [left bottom width height]
    fh.Position = [0.1 0.1 0.7 0.8];
end

% plot matrices with selected colorbar
for stage = 1:4
    
    % Multiplot
    if (mplot)
        % Create axes of upper left graph
        axes_1 = axes('Position',pvector(stage,:),'Parent',21,...
            'xticklabel','','yticklabel','','box','on');
    else
        fh = figure(stage)
        clf(fh);
        set(fh,'PaperPosition',[0.1 2.5 8.0 6.5]);  
        axis_1 = axes('Position',[0.01,0.05,0.9,0.9],'Parent',fh);
    end
    
    % Binary image of links
    if binflag
        ih = imagesc(tds_stages(:,:,stage) >= fth);
    else
        ih = imagesc(tds_stages(:,:,stage),clims);
    end
    
    %title#
    text(0,-1,[subject ' ' rlabels{stage}],'FontWeight','bold');
    %make image quadratic
    pbaspect([1 1 1])
    %colormap
    colormap(cmap)
    
    % add text and a grid for orientation
    for k = 1:length(tdslabels)
        t_s = text(-4,k,tdslabels{k});
        if (mplot)
            set(t_s,'Fontsize',5)
        end
    end
    for m = 1:length(eeglabels)
        t_lb = text(ticks(m+2)+2,29,eeglabels{m});
        if (mplot)
            set(t_lb,'Fontsize',5)
        end
        
    end
    iha = gca;
    set(iha,'XColor','r', 'YColor','r')
    set(iha,'ytick',[0.5,4.5,8.5,13.5,18.5,23.5,28.5]);
    set(iha,'yticklabel','    ');
    set(iha,'xtick',[0.5,4.5,8.5,13.5,18.5,23.5,28.5]);
    set(iha,'xticklabel','');
    %set(gca,'ytick',[1:length(C)],'yticklabel',labelvector);
    set(iha,'GridLineStyle','-');
    grid(iha,'on');
    
    hold on
    for i = 2:length(ticks)
        plot(borders,[ticks(i),ticks(i)],'r')
        plot([ticks(i),ticks(i)],borders,'r')
        
    end
    hold off
    
    %%colorbar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %// Create colorbar for every plot, if not multiplot
    if (~mplot)
        if cbaxisreverse
            cbh = colorbar('Position',cbpos1,'AxisLocation','in');
        elseif cblabel2
            cbh = colorbar('Position',cbpos1);
        else
            cbh = colorbar;
        end
        %
        % %// Set its ylabel property
        ylabel(cbh,cblabel);
        
        % add second axis
        if (~isempty(cblabel2))
            disp('trying to add second axis')
            % %// Get its position
            BarPos = cbh.Position
            %set Fontsize
            %cbh.FontSize = 7;
            %get fontsize
            cbfs = cbh.FontSize;
            
            %replicate original axis, if not set explicitely
            if(isempty(cbaxis2))
                cbaxis2 = cbh.YTick;
                cbtlabels2 = cbh.YTickLabel;
                cbylim = cbh.YLim
            else
                cbylim = [cbaxis2(1) cbaxis2(end)];
            end
            
            if (cbaxisreverse)
                % %// Create an axes at the same position
                cb2h = axes('position',BarPos,'color','none',...
                    'YTick',cbaxis2,...
                    'YLim',cbylim,...
                    'YTickLabel',cbtlabels2,...
                    'YAxisLocation','right',...
                    'XTick',[],'FontSize',cbfs);
                %
                % %// Set its ylabel property
                ylabel(cb2h,cblabel2,'FontSize',cbfs)
            else
                % %// Create an axes at the same position
                cb2h = axes('position',BarPos,'color','none',...
                    'YTick',cbaxis2,...
                    'YLim',cbylim,...
                    'YTickLabel',cbtlabels2,...
                    'XTick',[],'FontSize',cbfs);
                %
                % %// Set its ylabel property
                ylabel(cb2h,cblabel2,'FontSize',cbfs)
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        %% print Result to file
        if ~isempty(outfilebase) && ~mplot
            imagepng = [outfilebase '_' rlabels{stage} '_tds_matrix_val.png'];
            print('-dpng',[ imagepng])
        end
        
        %%colorbar and print for multiplot
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     %// Create colorbar for every plot, if not multiplot
    end
end
    if (mplot)
        if cbaxisreverse
            cbh = colorbar('Position',cbpos,'AxisLocation','in');
        else
            cbh = colorbar('Position',cbpos);
        end
        %
        % %// Set its ylabel property
        ylabel(cbh,cblabel);
        
        % add second axis
        if (~isempty(cblabel2))
            disp('trying to add second axis')
            % %// Get its position
            BarPos = cbh.Position
            %set Fontsize
            cbh.FontSize = 7;
            %get fontsize
            cbfs = cbh.FontSize;
            
            %replicate original axis, if not set explicitely
            if(isempty(cbaxis2))
                cbaxis2 = cbh.YTick;
                cbtlabels2 = cbh.YTickLabel;
                cbylim = cbh.YLim
            else
                cbylim = [cbaxis2(1) cbaxis2(end)];
            end
            
            if (cbaxisreverse)
                % %// Create an axes at the same position
                cb2h = axes('position',BarPos,'color','none',...
                    'YTick',cbaxis2,...
                    'YLim',cbylim,...
                    'YTickLabel',cbtlabels2,...
                    'YAxisLocation','right',...
                    'XTick',[],'FontSize',cbfs);
                %
                % %// Set its ylabel property
                ylabel(cb2h,cblabel2,'FontSize',cbfs)
            else
                % %// Create an axes at the same position
                cb2h = axes('position',BarPos,'color','none',...
                    'YTick',cbaxis2,...
                    'YLim',cbylim,...
                    'YTickLabel',cbtlabels2,...
                    'XTick',[],'FontSize',cbfs);
                %
                % %// Set its ylabel property
                ylabel(cb2h,cblabel2,'FontSize',cbfs)
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        
        if ~isempty(outfilebase)
            imagepng = [outfilebase '_tds_matrix_val.png'];
            print('-dpng',[ imagepng])
        end
        
    end
    
    
    
    
    
    
    

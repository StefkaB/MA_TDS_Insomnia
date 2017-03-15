function plot_differences_diagonal(tds_stages,varargin)
%plots a 4-dim tds matrix into two plots with
%1. (left) plot: lower left triangle = REM; upper right triangle = DS and
%2. (right) plot: lower left triangle = WAKE; upper right triangle = LS
%% Metadata-----------------------------------------------------------
% Stefanie Breuer, 11.03.2017, stefanie.breuer@student.htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: plot_differences_diagonal(tds_stages,varargin)
%INPUT:
% tds_stages    matrix of intersignal stability, dims: (28x28x4)
%
%OPTIONAL INPUT:
% group
% colormap
%
%%defaults
subject = '';
cmap = '';

rlabels = {'REM-Schlaf/Tiefschlaf';'Wachzustand/Leichtschlaf'};
%rlabels = {'Tiefschlaf';'Leichtschlaf'};
tdslabels = {'HR';'BR_{air}';'BR_c';'BR_a';'Chin';'Leg';...
    'Eye_1';'Eye_2';...
    '\delta C3';'\theta C3';'\alpha C3';'\sigma C3';'\beta C3';...
    '\delta O1';'\theta O1';'\alpha O1';'\sigma O1';'\beta O1';...
    '\delta C4';'\theta C4';'\alpha C4';'\sigma C4';'\beta C4';...
    '\delta O2';'\theta O2';'\alpha O2';'\sigma O2';'\beta O2'};

eeglabels = {'C3';'O1';'C4';'O2'};
ticks = [0.5,4.5,8.5,13.5,18.5,23.5,28.5];
borders = [0,39];

%positionvectors [left, bottom, width, height]

% w = 0.45;
% ll = 0.01;
% lr = 0.4;
% bt = 0.52;
w = 0.6;
ll = 0.01;
lr = 0.4;
bt = 0.2;
pvector =  [ll bt w w; lr bt w w];

%colorbarposition in multiplot
%cbpos = [0.8 0.07 0.02 0.86];
cbpos = [0.9 0.2 0.02 0.6];

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
        elseif strcmp(varargin{i}, 'group')
            group = varargin{i+1};
        elseif strcmp(varargin{i}, 'colormap')
            cmap = varargin{i+1};
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

fh = figure(22)
clf(fh)
fh.Units = 'normalized';
%Position [left bottom width height]
fh.Position = [0.1 0.4 0.6 0.5];

%1. dimension: lower left triangle = REM; upper right triangle = DS
col = 0;
tds_stages_diagonal = zeros(28, 28, 2);
tds_stages_diagonal(:,:,1) = tds_stages(:,:,1);
for i = 1:length(tds_stages_diagonal)
    col = col+1;
    for j = 1:col
        tds_stages_diagonal(i, j, 1) = tds_stages(i, j, 3);
        
    end
end
%2. dimension: lower left triangle = WAKE; upper right triangle = LS
col = 0;
tds_stages_diagonal(:,:,2) = tds_stages(:,:,2);
for i = 1:length(tds_stages_diagonal)
    col = col+1;
    for j = 1:col
        tds_stages_diagonal(i, j, 2) = tds_stages(i, j, 4);
        
    end
end

% plot matrices with selected colorbar
for stage = 1:2
    
    % Create axes of upper left graph
    axes_1 = axes('Position',pvector(stage,:),'Parent',22,...
        'xticklabel','','yticklabel','','box','on');
    
    ih = imagesc(tds_stages_diagonal(:,:,stage),clims);
    
    
    %title#
    text(0,-1,[subject ' ' rlabels{stage}],'FontWeight','bold');
    %make image quadratic
    pbaspect([1 1 1])
    
    % add text and a grid for orientation
    for k = 1:length(tdslabels)
        t_s = text(-4,k,tdslabels{k});
        set(t_s,'Fontsize',5)
    end
    for m = 1:length(eeglabels)
        t_lb = text(ticks(m+2)+2,29,eeglabels{m});
        set(t_lb,'Fontsize',5)
        
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
    
    if ~isempty(cmap)
        colormap(cmap)
    end
    cbh = colorbar('Position',cbpos);
    %Set its ylabel property
    %ylabel(cbh,cblabel);
end
   
if strcmp(group, 'all-none')
    group_name = 'Gruppe Alle - Insomnie';
elseif strcmp(group, 'all-heart')
    group_name = 'Gruppe Alle - Herz';
elseif strcmp(group, 'all-breath')
    group_name = 'Gruppe Alle - Atmung';
elseif strcmp(group, 'all-sleep')
    group_name = 'Gruppe Alle - Schlafmittel';
elseif strcmp(group, 'siesta-all')
    group_name = 'SIESTA - Gruppe Alle';
elseif strcmp(group, 'siesta-insom')
    group_name = 'SIESTA - Gruppe Insomnie';
elseif strcmp(group, 'heart')
    group_name = 'Gruppe Herz';
elseif strcmp(group, 'breath')
    group_name = 'Gruppe Atmung';
elseif strcmp(group, 'sleep')
    group_name = 'Gruppe Schlafmittel';
elseif strcmp(group, 'insom')
    group_name = 'Gruppe Insomnie';
elseif strcmp(group, 'all')
    group_name = 'Gruppe Alle';
elseif strcmp(group, 'siesta')
    group_name = 'Gruppe SIESTA';
elseif strcmp(group, 'young-old')
    group_name = 'Gruppe jung - Gruppe alt';
end
set(gcf, 'name', group_name)
    
    
    
    
    
    
    

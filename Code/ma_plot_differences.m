function ma_plot_differences(tds_stages,varargin)
% Function to plot all sleep stages of 3-dim tds matrix
%% Metadata
% Stefanie Breuer, 12.03.2017
% stefanie.breuer@student.htw-berlin.de
% version 1.0
%
% USAGE: ma_plot_differences(tds_stages, 'colorbartext', 'p-values');
%
% INPUT
% tds_stages    3-dim matrix containing link strengths of all sleep stages
%
% OPTIONAL INPUT
% colorbartext  sort of plot, choose 'p-values' for colorbar with text on
%               the right side containing specified significance levels,
%               choose 'linreg' for linear regression slopes and colorbar 
%               with text on the left side, choose 'population' for
%               differences between insomnia and matches, leave empty for
%               no colorbar text
% group         set group to define figure title 
%               'none': insomnia group (without other diseases)
%               'breath': patients with sleep apneas, asthma...
%               'heart': patients with heart diseases
%               'sleep': patients who consume sleep drugs
%               'siesta-all': differences of siesta group and whole
%               insomnia dataset
%               'siesta-insom': differences of siesta group and insomnia
%               group (without other diseases)
%               
%------------------------------------------------------------
%% Defaults
subject = '';
cbtext = '';

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
cbpos = [0.86 0.07 0.02 0.86];

%% Check for input variables
% size of varargin
m = size(varargin,2);

% if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %samplingfrequency
        if strcmp(varargin{i},'subject')
            subject = varargin{i+1};
        elseif strcmp(varargin{i}, 'group')
            group = varargin{i+1};
        elseif strcmp(varargin{i}, 'colorbartext')
            cbtext = varargin{i+1};
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

fh = figure(21)
clf(fh)
fh.Units = 'normalized';
%Position [left bottom width height]
fh.Position = [0.1 0.1 0.7 0.8];


% plot matrices with selected colorbar
for stage = 1:4
    
    % Create axes of upper left graph
    axes_1 = axes('Position',pvector(stage,:),'Parent',21,...
        'xticklabel','','yticklabel','','box','on');
    
    ih = imagesc(tds_stages(:,:,stage),clims);
    
    
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
    if ~isempty(cbtext)
        if strcmp(cbtext, 'p-values')
            % set property for plot of p-values
            colormap('default'); 
            colormap(flipud(colormap)); 
            cbh = colorbar('Position',cbpos); 
            ylabel(cbh,'oben: Signifikanzlevel');
            set(cbh, 'Direction', 'reverse', ...
                'TickLabels', {'\leq0.001\_{b}','\leq0.01\_{b}','\leq0.05\_{b}','\leq0.001','\leq0.01','\leq0.05','>0.05'});
        elseif strcmp(cbtext, 'linreg')
            % set property for plot of linear regression slopes
            cbh = colorbar('Position',cbpos);
            ylabel(cbh, 'unten: Anstieg der Regressionsgeraden m')
            set(cbh, 'AxisLocation', 'in' );
        elseif strcmp(cbtext, 'population')
            % set property for plot of differences in mean tds
            cbh = colorbar('Position',cbpos);
            ylabel(cbh,'unten: Verbindungsstärken Insomnie - Matches');
            set(cbh, 'AxisLocation', 'in' );
        end
    else
        colorbar('Position',cbpos);
    end
    
end
   
if strcmp(group, 'none')
    group_name = 'Gruppe Alle - Insomnie';
elseif strcmp(group, 'heart')
    group_name = 'Gruppe Alle - Herz';
elseif strcmp(group, 'breath')
    group_name = 'Gruppe Alle - Atmung';
elseif strcmp(group, 'sleep')
    group_name = 'Gruppe Alle - Schlafmittel';
elseif strcmp(group, 'siesta-all')
    group_name = 'SIESTA - Gruppe Alle';
elseif strcmp(group, 'siesta-insom')
    group_name = 'SIESTA - Gruppe Insomnie';
end
set(gcf, 'name', group_name)
    
    
    
    
    
    
    

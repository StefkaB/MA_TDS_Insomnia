function plot_differences(tds_stages,varargin)

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

fh = figure(20)
clf(fh)
fh.Units = 'normalized';
%Position [left bottom width height]
fh.Position = [0.1 0.1 0.7 0.8];


% plot matrices with selected colorbar
for stage = 1:4
    
    % Create axes of upper left graph
    axes_1 = axes('Position',pvector(stage,:),'Parent',20,...
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
    %colorbar('Position',cbpos);
    cbh = colorbar('Position',cbpos);
    %Set its ylabel property
    %ylabel(cbh,cblabel);
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
    
    
    
    
    
    
    

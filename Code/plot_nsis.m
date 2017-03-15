percDS = meannsis_ds;
percLS = meannsis_ls;
percREM = meannsis_r;
percAWAKE = meannsis_w;
percDSsiesta = 13.48;
percLSsiesta = 49.36;
percREMsiesta = 17.15;
percAWAKEsiesta = 20.01;
zf = 52;
figure;
x = [1 2 4 5 7 8 10 11 12];
y = [percDS, percDSsiesta, percLS, percLSsiesta, percREM,...
    percREMsiesta, percAWAKE, percAWAKEsiesta, 52];

h = bar(x, y, 0.5) 

for i = 1:numel(y)
    text(x(i),y(i),num2str(y(i), '%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom')
end
xlabels = {'TS-Insomnie', 'TS-SIESTA', 'LS-Insomnie', 'LS-SIESTA', ...
    'R-Insomnie', 'R-SIESTA', 'W-Insomnie', 'W-SIESTA'};
ax = gca;
ax.XTickLabel = xlabels;
ax.XTickLabelRotation = 45;
%set(gca, 'YLim', [0 100]);
ylabel('%')
%title('Percentage of Epochs per Sleep Stage')


figure;
x = [1 2 4 5 7 8 10 11 12];
y1 = [percDS 0 percLS 0 percREM 0 percAWAKE 0 zf];
y2 = [0 percDSsiesta 0 percLSsiesta 0 percREMsiesta 0 percAWAKEsiesta 0];
bar(x, y1, 'g');
hold on
bar(x, y2, 'b');
for i=1:2:numel(y1)
    text(x(i), y1(i), num2str(y1(i), '%0.2f'),...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom')
end
for i=2:2:numel(y2)
    text(x(i), y2(i), num2str(y2(i), '%0.2f'),...
        'HorizontalAlignment','center', 'VerticalAlignment','bottom')
end
legend('Insomnie', 'gesunde Probanden')
hold off

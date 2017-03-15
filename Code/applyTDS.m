% script to apply sn_TDS.m on the charite data set
edf_path = 'C:\Users\Stefka\Desktop\Masterarbeit\INSOMNIA\';
edf_listing = dir(edf_path); %including . and ..
hypno_path = 'C:\Users\Stefka\Desktop\Masterarbeit\Hypnograms\';
hypno_listing = dir(hypno_path); %including . and ..
result_path = 'C:\Users\Stefka\Desktop\Masterarbeit\TDS-Results\';
result_listing = dir(result_path);

for i = 3:length(edf_listing)
    edffile = edf_listing(i).name;
    edfname = edffile(1:end-20);
    edf = [edf_path, edffile];
    
    for j = 3:length(hypno_listing)
        hypnofile = hypno_listing(j).name;
        hypnoname = hypnofile(11:end-4);
        hypno = [hypno_path, hypnofile];
        
        if strcmp(edfname, hypnoname)
            % apply TDS stability analysis
            [tds,xcc,xcl,biosignals_tds,fpb,sbmat,header,signalheader,signalcells] ...
                = sn_TDS_Charite(edf,'ch_all', 'charite', 'hypno_flag', 1, ...
                'hypno_filename', hypno, 'debug', 0);
            % save results tds, xcc, xcl and biosignals_tds
            save([result_path, edfname, '_', 'tds.mat'], 'tds')
            save([result_path, edfname, '_', 'xcc.mat'], 'xcc')
            save([result_path, edfname, '_', 'xcl.mat'], 'xcl')
            save([result_path, edfname, '_', 'biosignals_tds.mat'], 'biosignals_tds')
            close('all')
            
            % apply extracting of sleep stages
            %tds = [result_path, edfname, '_tds.mat'];
            %load(tds)
            % read hypnogram
            T = dlmread(hypno);
            % create hypnogram array
            hypnogram = T(2:end);
            % apply TDS Analysis
            [result,nsis,hypnogram] = sn_getStagesTDS('data', tds, 'hypnogram', hypnogram);
            % save results result, nsis and hypnogram
            save([result_path, edfname, '_', 'result.mat'], 'result')
            save([result_path, edfname, '_', 'nsis.mat'], 'nsis')
            save([result_path, edfname, '_', 'hypnogram.mat'], 'hypnogram')
            close('all')
            
            % plot results
%             sn_plotTDSMatrixCharite(result, 'colormap', tds_colormap2);
        end
    end
end






% for i = 3:length(edf_listing)
%     edffile = edf_listing(i).name;
%     edfname = edffile(1:end-20);
%     edf = [edf_path, edffile];
%     
%     for j = 3:length(hypno_listing)
%         hypnofile = hypno_listing(j).name;
%         hypnoname = hypnofile(11:end-4);
%         hypno = [hypno_path, hypnofile];
%         
%         if strcmp(edfname, hypnoname)
%             tds = [result_path, edfname, '_tds.mat'];
%             load(tds)
%             % read hypnogram
%             T = dlmread(hypno);
%             hypnogram = T(2:end);
%             % apply TDS Analysis
%             [result,nsis,hypnogram] = sn_getStagesTDS('data', tds, 'hypnogram', hypnogram);
%             % save results tds, xcc, xcl and biosignals_tds
%             save([result_path, edfname, '_', 'result.mat'], 'result')
%             save([result_path, edfname, '_', 'nsis.mat'], 'nsis')
%             save([result_path, edfname, '_', 'hypnogram.mat'], 'hypnogram')
%             close('all')
%         end
%     end
% end





% % 1. Pfade definieren
% % 2. Schleife über EDFs
% % 2a Vektor aus Hypnogramm erstellen
% % 3. sn_TDS_Charite.m anwenden mit Hypnogramm Array
% %     [tds,xcc,xcl,biosignals_tds,fpb,sbmat,header,signalheader,signalcells] ...
% %         = sn_TDS_Charite(edffile,'ch_all', 'charite', 'hypno_flag', 1, ...
% %         'hypno_filename', hypnofile, 'debug', 0);
% % 4. Ergebnisse speichern -> tds, xcc, xcl, biosignals_tds in struct
% % 5. Schlafstadien extrahieren mit sn_getStagesTDS.m
% % 6. Ergebnisse speichern in gleiches struct oder als .mat-Dateien
% % 7. TDS plotten mit sn_plotTDSMatrixCharite.m
% % 8. Ergebnisse speichern

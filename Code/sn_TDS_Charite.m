function [tds,xcc,xcl,biosignals_tds,fpb,sbmat,header,signalheader,signalcells] = sn_TDS(filename,varargin)
%reads PSGs (in EDF format) and performs TDS method
%based on Bashan et al. Nat. com. 2012 DOI: 10.1038/ncomms1705
%% Metadata-----------------------------------------------------------
% Dagmar Krefting, 15.2.2015, dagmar.krefting@htw-berlin.de
% Version: 1.0
%-----------------------------------------------------------
%
%USAGE: tds = sn_TDS(PSG-EDF,varargin)
%
%INPUT:
%filename       full filename of the edf, including path.
%               !! if ch_all is set to "Alice6", the edf-data is read-in
%               with a specific function, accounting for data chunks.
%
%OPTIONAL INPUT:
% wl_sfe    windowlength of signal feature extraction, default 2 secs
% ws_sfe    windowshift of signal feature extraction, default 1 secs
% ch_eeg    channelnumber of EEG signal, default 1
% ch_eog channelnumber of EOG signal, default 8;
% ch_emgchin channelnumber of chin (submental) EMG signal, default 10;
% ch_emgleg channelnumber of leg EMG signal, default 11;
% ch_ecg channelnumber of ECG signal, default 12;
% rr_filename name of external RR-file, default none;
% rr_filetype type external RR-file: 'rr','rr200', default 'rr';
% airflow_filename name of external breathing-file, default none;
% chest_filename name of external breathing-file, default none;
% abdomen_filename name of external breathing-file, default none;
% ch_airflow channelnumbers of airflow, default 13;
% ch_all: processes all channels regarding the channel structure, default
% '' (empty string
%    "siesta", all channels are processed regarding the siesta channel order
%    "compumedics", all channels are processed regarding the compumedics
%    channel order
%   "Alice6" all channels are processed regarding the Alice6 channel-labels.
%   Furthermore, the EDF-data is read with a specific routine to account
%   for
% hypno_flag: set true for charite data, default 0
% hypno_filename: path of numeric hypnogram file in .txt format with first
% row=amount of difference between startimes of edf and scoring in seconds
% and following rows=hypnogram numbers
% wl_xcc windowlength of crosscorrelation in seconds, default 60;
% ws_xcc windowshift of crosscorrelation in seconds, default 30;
% wl_tds windowlength of stability analysis in seconds, default 5;
% ws_tds windowshift of stability analysis in seconds, default 1;
% mld_tds maximum lag difference in window to be accounted as stable sequence, default 2;
% mlf_tds minimum lag fraction in window that need to fulfill mld_tds, default: 0.8;
% debug     if set to 1 debug information is provided, default '0'
%
% OUTPUT
% tds   matrix containing stability matrix of size(timespan,nsignals^2)
%       the time resolution is determined by ws_xcc. The order of the
%       signal2signal is first all combinations with first signal, all
%       combinations with second signal,....,all combinations with nth
%       signal, for three signals e.g. 11-12-13-21-22-23-31-32-33
%
% Modification List
% 20150302 V 1.0.1 (dk):
% - debug option added
% - debug information implemented
% - default EEG channel to channel 2 (C3-M2)
% 20150309 V 1.0.2 (dk)
% - option rr_filetype added ('rr')
% - option breath_filetype added
% - using sn_BlockEdfRead instead of BlocEdfRead to account for invalid
% num_data_records
% 20150331 V 1.0.3 (dk)
% - option ch_all added
% 20150408 V 1.0.4 (dk)
% - options for external chest and abdomen files added
% - renamed resp_file/resp_flag to airflow_file/airflow_flag
% 20170306 V 1.0.5 (sb)
% - whole function extended to make it valid for charite data
%% defaults Test


%% Defaults feature extraction

%windowlength of signal feature extraction
wl_sfe = 2;
%windowshift of signal feature extraction
ws_sfe = 1;

%channelnumber of EEG signal (C3-M2)
ch_eeg = 2;

%channelnumber of EOG signal(POS8-M1 = eog1)
ch_eog = 8;

%channelnumbers of EMG signals
ch_emgchin = 10;
ch_emgleg = 11;

%channelnumber of ECG signal
ch_ecg = 12;
%external RR-file flag
rr_flag = 0;
%external RR-filename
rr_filename = '';
%rr_filetype
rr_filetype = 'rr';

%channelnumbers of airflow
ch_airflow = 13;
%external breathing-filenames
airflow_filename = '';
chest_filename = '';
abdomen_filename = '';
%external resp-file flag
airflow_flag = 0;
chest_flag = 0;
abdomen_flag = 0;

ch_all = '';

%hypnogram file if function is used for charite data
hypno_flag = 0;
hypno_filename = '';

%% Defaults crosscorrelation

%window length in seconds
wl_xcc = 60;
%window shift in seconds
ws_xcc = 30;

%% Defaults time delay stability

%windowlength of stability analysis in seconds
wl_tds = 5;
%windowshift of stability analysis in seconds
ws_tds = 1;
%maximum lag difference in window to be accounted as stable sequence
mld_tds = 2;
%minimum lag fraction in window fulfilling mld_tds to account for stable
%sequence
mlf_tds = 0.8;

%% Defaults debug
debug = 0;

%% Check for input vars
%size of varargin
m = size(varargin,2);

%if varargin present, check for keywords and get parameter
if m > 0
    %disp(varargin);
    for i = 1:2:m-1
        %outputfile
        if strcmp(varargin{i},'datapath')
            datapath = varargin{i+1};
            %outputfile
        elseif strcmp(varargin{i},'night')
            night = varargin{i+1};
        elseif strcmp(varargin{i},'wl_sfe')
            wl_sfe = varargin{i+1};
        elseif strcmp(varargin{i},'ws_sfe')
            ws_sfe = varargin{i+1};
        elseif strcmp(varargin{i},'ch_eeg')
            ch_eeg = varargin{i+1};
        elseif strcmp(varargin{i},'ch_eog1')
            ch_eog1 = varargin{i+1};
        elseif strcmp(varargin{i},'ch_eog2')
            ch_eog2 = varargin{i+1};
        elseif strcmp(varargin{i},'ch_emgchin')
            ch_emgchin = varargin{i+1};
        elseif strcmp(varargin{i},'ch_emgleg')
            ch_emgleg = varargin{i+1};
        elseif strcmp(varargin{i},'ch_ecg')
            ch_ecg = varargin{i+1};
        elseif strcmp(varargin{i},'rr_filename')
            rr_filename = varargin{i+1};
            rr_flag = 1;
        elseif strcmp(varargin{i},'rr_filetype')
            rr_filetype = varargin{i+1};
        elseif strcmp(varargin{i},'ch_airflow')
            ch_airflow = varargin{i+1};
        elseif strcmp(varargin{i},'airflow_filename')
            airflow_filename = varargin{i+1};
            airflow_flag = 1;
        elseif strcmp(varargin{i},'chest_filename')
            chest_filename = varargin{i+1};
            chest_flag = 1;
        elseif strcmp(varargin{i},'abdomen_filename')
            abdomen_filename = varargin{i+1};
            abdomen_flag = 1;
        elseif strcmp(varargin{i},'ch_all')
            ch_all = varargin{i+1};
        elseif strcmp(varargin{i},'wl_xcc')
            wl_xcc = varargin{i+1};
        elseif strcmp(varargin{i},'ws_xcc')
            ws_xcc = varargin{i+1};
        elseif strcmp(varargin{i},'wl_tds')
            wl_tds = varargin{i+1};
        elseif strcmp(varargin{i},'ws_tds')
            ws_tds = varargin{i+1};
        elseif strcmp(varargin{i},'tol_tds')
            tol_tds = varargin{i+1};
        elseif strcmp(varargin{i},'hypno_filename')
            hypno_filename = varargin{i+1};
            hypno_flag = 1;
        elseif strcmp(varargin{i},'outputfilebase')
            outputfilebase = varargin{i+1};
            outputbaseflag=1;
        elseif strcmp(varargin{i},'debug')
            debug = varargin{i+1};
        end
    end
end


%% read edf

%% read edf from chunks for Alice6
if(strcmp(ch_all,'alice6'))
    [header,signalheader,signalcells]= sn_readEdfAlice6(filename);
else
    %read edf-Header
    [header,signalheader,signalcells]= sn_edfScan2matScan('data',filename);
end

%% get headerinfos
%data_record_duration in seconds
drd = header.data_record_duration;
%sampling frequencies of channels
sfch = [signalheader(:).samples_in_record]/drd;

%if ch_all is set, define channel order, overwrites possible channel
%settings, but not external files
if(strcmp(ch_all,'siesta'))
    disp('all channels following SIESTA standard are processed')
    %channelnumber of EEG signal (C3-M2)
    ch_eeg = 1;
    ch_eeg2 = 2;
    ch_eeg3 = 3;
    ch_eeg4 = 4;
    ch_eeg5 = 5;
    ch_eeg6 = 6;
    
    %channelnumber of EOG signal(POS8-M1 = eog1)
    ch_eog = 8;
    ch_eog2 = 9;
    
    %channelnumbers of EMG signals
    ch_emgchin = 10;
    ch_emgleg = 11;
    
    %channelnumber of ECG signal
    ch_ecg = 12;
    
    %channelnumbers of airflow
    ch_airflow = 13;
    ch_chest = 14;
    ch_abdomen = 15;
    %ch_sao2 = 16;
    %ch_pulse = 17;
elseif(strcmp(ch_all,'alice6'))
    disp('all channels following Alice6 standard are processed')
    
    %check all labels and assign channel_identifier
    for l = 1:header.num_signals
            if debug
                char(signalheader(l).signal_labels)
            end

        switch char(signalheader(l).signal_labels)
            case 'EEG F3-A2'
                ch_eeg = l;
            case 'EEG C3-A2'
                ch_eeg2 = l;
            case 'EEG O1-A2'
                ch_eeg3 = l;
            case 'EEG F4-A1'
                ch_eeg4 = l;
            case 'EEG C4-A1'
                ch_eeg5 = l;
            case 'EEG O2-A1'
                ch_eeg6 = l;
            case 'EOG LOC-A2'
                ch_eog = l;
            case 'EOG ROC-A2'
                ch_eog2 = l;
            case 'EMG Chin'
                ch_emgchin = l;
            case 'Leg 1'
                ch_emgleg = l;
            case 'Leg 2'
                ch_emgleg2 = l;
            case 'ECG II'
                ch_ecg = l;
            case 'Flow Patient'
                if strcmp('Thermistor',signalheader(l).transducer_type)
                    ch_airflow = l;
                elseif strcmp('Pressure',signalheader(l).transducer_type)
                    ch_airflow2 = l;
                elseif strcmp('RI_Therapy_Device 0x03',signalheader(l).transducer_type)
                    ch_airflow3 = l;
                end
            case 'Effort THO'
                ch_chest = l;
            case 'Effort ABD'
                ch_abdomen = l;
            otherwise disp(['This signal will not be processed: ', signalheader(l).signal_labels])
        end
    end 
elseif(strcmp(ch_all,'charite'))
    disp('all channels following Charite standard are processed')
    % hypnogram file exists
    if hypno_flag
        % read hypnogram
        T = dlmread(hypno_filename);
        %starttime difference in seconds
        durationseconds = T(1); 
        %starttime difference in samples for each signal
        durationsamples = [signalheader(:).samples_in_record]/...
            header.data_record_duration * durationseconds;
        %hypnogram duration in samples for each signal
        hypnogramduration = length(T(2:end))*30*sfch; 
        %lengths of all signals
        signallengths = cellfun('length',signalcells);
        %boolean array - 1 if hypnogram+starttime difference is smaller
        %than signal length 
        lengthflag = (durationsamples(:)+1+hypnogramduration(:) <= signallengths(:));
    else
        disp('Hypnogram file is missing, please select hypnogram text file.')
        return;
    end
    %channelnumbers of EEG signals
    ch_eeg = 2; %EEG C4-A1
    ch_eeg2 = 3; %EEG O2-A1
    ch_eeg3 = 5; %EEG C3-A2
    ch_eeg4 = 6; %EEG O1-A2
    
    %channelnumber of EOG signal(POS8-M1 = eog1)
    ch_eog = 7;
    ch_eog2 = 8;
    
    %channelnumbers of EMG signals
    ch_emgchin = 9;
    ch_emgleg = 10;
    
    %channelnumber of ECG signal
    ch_ecg = 12;
    
    %channelnumbers of airflow
    ch_airflow = 13;
    ch_chest = 14;
    ch_abdomen = 15;
end




%% get RR

%if RR is a separate file, load file
if rr_flag
    rrdata = load(rr_filename);
    if (strcmp(rr_filetype,'rr200'))
        %files are 'rr200, always in 200 Hz samples, so adjust to actual sampling
        %frequency of ecg
        rrdata = rrdata/200*sfch(ch_ecg);
    else
        %files are 'rr', first column in seconds
        if debug
            disp(['rrdata = rrdata(:,1)*' num2str(sfch(ch_ecg)) ';'])
        end
        rrdata = rrdata(:,1)*sfch(ch_ecg);
    end
else
    % Helena's CQRS-algorithm or other
    if debug
        ch_ecg
    end
    if strcmp(ch_all, 'charite')
        if lengthflag(ch_ecg)
            rrdata = sn_CQRS(signalcells{ch_ecg}(durationsamples(ch_ecg)...
                +1:durationsamples(ch_ecg)+hypnogramduration(ch_ecg)), sfch(ch_ecg));
        else
            rrdata = sn_CQRS(signalcells{ch_ecg}(durationsamples(ch_ecg)...
                +1:end), sfch(ch_ecg));
        end
    else
        rrdata = sn_CQRS(signalcells{ch_ecg},sfch(ch_ecg));
    end
end

if debug
    disp(['heartrate = sn_getEventRate(rrdata,''sf'',' num2str(sfch(ch_ecg))...
        ',''ersf'',' num2str(ws_sfe) ',''sl'',' num2str(length(signalcells{ch_ecg})) ');'])
end

if strcmp(ch_all, 'charite')
    if lengthflag(ch_ecg)
        heartrate = sn_getEventRate(rrdata,'sf',sfch(ch_ecg),'ersf',ws_sfe,'sl',...
            length(signalcells{ch_ecg}(durationsamples(ch_ecg)+1:durationsamples(ch_ecg)+hypnogramduration(ch_ecg))));
        disp('first condition')
    else
        heartrate = sn_getEventRate(rrdata,'sf',sfch(ch_ecg),'ersf',ws_sfe,'sl',...
            length(signalcells{ch_ecg}(durationsamples(ch_ecg)+1:end)));
    end
else
    heartrate = sn_getEventRate(rrdata,'sf',sfch(ch_ecg),'ersf',ws_sfe,'sl',length(signalcells{ch_ecg}));
end
%apply moving median to get rid of spikes
heartrate = nld_movingMedian(heartrate,5);

if debug
    whos heartrate
end

%% get breathing rate
if debug
    disp(['airflowflag = ' num2str(airflow_flag)])
end

%if external resp_file is given, load file
if (airflow_flag && ~isempty(airflow_filename))
    airflow_data = load(airflow_filename);
    respdata = airflow_data(:,1);
    %calculate eventrates
    if debug
        disp(['breathingrate = sn_getEventRate(respdata,''sf'',1,''ersf'',' num2str(ws_sfe) ',''sl'',' num2str(floor(length(signalcells{ch_airflow})./sfch(ch_airflow))) ',qv,airflow_data(:,1),ql,50);'])
    end
    breathingrate = sn_getEventRate(respdata,'sf',1,'ersf',ws_sfe,'sl',floor(length(signalcells{ch_airflow})./sfch(ch_airflow)),'qv',airflow_data(:,1),'ql',50);
else %use channel to calculate breathingrate
    if debug
        disp(['breathingrate = sn_getBreathingRate(signalcells{' num2str(ch_airflow) '},''sf'',' num2str(sfch(ch_airflow)) ',''brsf'',' num2str(ws_sfe) ');'])
    end
    if strcmp(ch_all, 'charite')
        if lengthflag(ch_airflow)
            breathingrate = sn_getBreathingRate(signalcells{ch_airflow}(durationsamples(ch_airflow)...
                +1:durationsamples(ch_airflow)+hypnogramduration(ch_airflow)),'sf',sfch(ch_airflow),'brsf',ws_sfe);
        else
            breathingrate = sn_getBreathingRate(signalcells{ch_airflow}(durationsamples(ch_airflow)...
                +1:end),'sf',sfch(ch_airflow),'brsf',ws_sfe);
        end
    else
        breathingrate = sn_getBreathingRate(signalcells{ch_airflow},'sf',sfch(ch_airflow),'brsf',ws_sfe);
    end
    %transpose
    breathingrate = breathingrate';
end

%display breathingrate
if debug
    whos breathingrate
end

if (strcmp(ch_all,'siesta') | strcmp(ch_all, 'charite'))
    disp('SIESTA or Charite: getting breathing rate from chest and abdomen')
    
    %extend breathingrate to three cols
    breathingrate = [breathingrate,zeros(length(breathingrate),2)];
    whos breathingrate
    %chest
    if (chest_flag && ~isempty(chest_filename))
        chest_data = load(chest_filename);
        respdata = chest_data(:,1);
        %calculate eventrates
        if debug
            disp(['breathingrate(:,2) = sn_getEventRate(respdata,''sf'',1,''ersf'',' num2str(ws_sfe) ',''sl'',' num2str(floor(length(signalcells{ch_chest})./sfch(ch_chest))) ',qv,chest_data(:,1),ql,50);'])
        end
        breathingrate(:,2) = sn_getEventRate(respdata,'sf',1,'ersf',ws_sfe,'sl',floor(length(signalcells{ch_chest})./sfch(ch_chest)),'qv',chest_data(:,1),'ql',50);
    else %use channel to calculate breathingrate
        if debug
            disp(['breathingrate(:,2) = sn_getBreathingRate(signalcells{' num2str(ch_chest) '},''sf'',' num2str(sfch(ch_chest)) ',''brsf'',' num2str(ws_sfe) ');'])
        end
        if strcmp(ch_all, 'charite')
            if lengthflag(ch_chest)
                breathingrate(:,2) = sn_getBreathingRate(signalcells{ch_chest}(durationsamples(ch_chest)...
                    +1:durationsamples(ch_chest)+hypnogramduration(ch_chest)),'sf',sfch(ch_chest),'brsf',ws_sfe);
            else
                breathingrate(:,2) = sn_getBreathingRate(signalcells{ch_chest}(durationsamples(ch_chest)...
                    +1:end),'sf',sfch(ch_chest),'brsf',ws_sfe);
            end
        else
            breathingrate(:,2) = sn_getBreathingRate(signalcells{ch_chest},'sf',sfch(ch_chest),'brsf',ws_sfe);
        end
    end
    %abdomen
    if (abdomen_flag && ~isempty(abdomen_filename))
        abdomen_data = load(abdomen_filename);
        respdata = abdomen_data(:,1);
        %calculate eventrates
        if debug
            disp(['breathingrate(:,3) = sn_getEventRate(respdata,''sf'',1,''ersf'',' num2str(ws_sfe) ',''sl'',' num2str(floor(length(signalcells{ch_abdomen})./sfch(ch_airflow)))  ',qv,abdomen_data(:,1),ql,50);'])
        end
        breathingrate(:,3) = sn_getEventRate(respdata,'sf',1,'ersf',ws_sfe,'sl',floor(length(signalcells{ch_abdomen})./sfch(ch_abdomen)),'qv',abdomen_data(:,1),'ql',50);
    else %use channel to calculate breathingrate
        if debug
            disp(['breathingrate(:,3) = sn_getBreathingRate(signalcells{' num2str(ch_abdomen) '},''sf'',' num2str(sfch(ch_abdomen)) ',''brsf'',' num2str(ws_sfe) ');'])
        end
        if strcmp(ch_all, 'charite')
            if lengthflag(ch_abdomen)
            breathingrate(:,3) = sn_getBreathingRate(signalcells{ch_abdomen}(durationsamples(ch_abdomen)...
                +1:durationsamples(ch_abdomen)+hypnogramduration(ch_abdomen)),'sf',sfch(ch_abdomen),'brsf',ws_sfe);    
            else
                breathingrate(:,3) = sn_getBreathingRate(signalcells{ch_abdomen}(durationsamples(ch_abdomen)...
                    +1:end),'sf',sfch(ch_abdomen),'brsf',ws_sfe);
            end
        else
            breathingrate(:,3) = sn_getBreathingRate(signalcells{ch_abdomen},'sf',sfch(ch_abdomen),'brsf',ws_sfe);
        end
    end
elseif (strcmp(ch_all,'alice6'))
    disp('Alice6: getting breathing rate from chest and abdomen')
    
    %extend breathingrate dynamically to further channels
    %resp_addcolumns = 0;
    exist ch_chest var
    if (exist('ch_chest','var'))
        %extend breathing-rate
        whos breathingrate
        breathingrate = [ breathingrate zeros(length(breathingrate),1)];
        %calculate breathing rate
        breathingrate(:,end) = sn_getBreathingRate(signalcells{ch_chest},'sf',sfch(ch_chest),'brsf',ws_sfe);
    end
    if (exist('ch_abdomen','var'))
        %extend breathing-rate
        breathingrate = [ breathingrate zeros(length(breathingrate),1)];
        %calculate breathing rate
        breathingrate(:,end) = sn_getBreathingRate(signalcells{ch_abdomen},'sf',sfch(ch_chest),'brsf',ws_sfe);
    end
    if (exist('ch_airflow2','var'))
        %extend breathing-rate
        breathingrate = [ breathingrate zeros(length(breathingrate),1)];
        %calculate breathing rate
        breathingrate(:,end) = sn_getBreathingRate(signalcells{ch_airflow2},'sf',sfch(ch_chest),'brsf',ws_sfe);
    end
    if (exist('ch_airflow3','var'))
        %extend breathing-rate
        breathingrate = [ breathingrate zeros(length(breathingrate),1)];
        %calculate breathing rate
        breathingrate(:,end) = sn_getBreathingRate(signalcells{ch_chest},'sf',sfch(ch_chest),'brsf',ws_sfe);
    end
end

%% get variance of EOGs and EMGs
if debug
    disp(['var_emgchin = sn_getVariance(signalcells{' num2str(ch_emgchin) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(ch_emgchin)) ');'])
    disp(['var_emgleg = sn_getVariance(signalcells{' num2str(ch_emgleg) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(ch_emgleg)) ');'])
    disp(['var_eog = sn_getVariance(signalcells{' num2str(ch_eog) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(ch_eog)) ');'])
end

if strcmp(ch_all, 'charite')
    if lengthflag(ch_emgchin)
        var_emgchin = sn_getVariance(signalcells{ch_emgchin}(durationsamples(ch_emgchin)+1:durationsamples(ch_emgchin)...
            +hypnogramduration(ch_emgchin)), 'wl', wl_sfe, 'ws', ws_sfe,...
            'sf',sfch(ch_emgchin));
    else
        var_emgchin = sn_getVariance(signalcells{ch_emgchin}(durationsamples(ch_emgchin)...
            +1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_emgchin));
    end
    if lengthflag(ch_emgleg)
        var_emgleg = sn_getVariance(signalcells{ch_emgleg}(durationsamples(ch_emgleg)...
            +1:durationsamples(ch_emgleg)+hypnogramduration(ch_emgleg)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_emgleg));
    else
        var_emgleg = sn_getVariance(signalcells{ch_emgleg}(durationsamples(ch_emgleg)+1:end)...
            ,'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_emgleg));
    end
    if lengthflag(ch_eog)
        var_eog = sn_getVariance(signalcells{ch_eog}(durationsamples(ch_eog)+1:durationsamples...
            (ch_eog)+hypnogramduration(ch_eog)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eog));
    else
        var_eog = sn_getVariance(signalcells{ch_eog}(durationsamples(ch_eog)+1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eog));
    end
else
    var_emgchin = sn_getVariance(signalcells{ch_emgchin}, 'wl', wl_sfe,'ws',ws_sfe,'sf',sfch(ch_emgchin));
    var_emgleg = sn_getVariance(signalcells{ch_emgleg},'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_emgleg));
    var_eog = sn_getVariance(signalcells{ch_eog},'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eog));
end

if (strcmp(ch_all,'siesta') || strcmp(ch_all,'alice6') || strcmp(ch_all,'charite'))
    disp('SIESTA, Charite and Alice6: getting second EOG at channel 9')
    %extend var_eog for two channels
    var_eog = [ var_eog, zeros(length(var_eog),1)];
    if debug
        disp(['var_eog(:,2) = sn_getVariance(signalcells{' num2str(ch_eog2) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(ch_eog2)) ');'])
    end
    
    if strcmp(ch_all, 'charite')
        if lengthflag(ch_eog2)
            var_eog(:,2) = sn_getVariance(signalcells{ch_eog2}(durationsamples(ch_eog2)...
                +1:durationsamples(ch_eog2)+hypnogramduration(ch_eog2)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eog2));
        else
            var_eog(:,2) = sn_getVariance(signalcells{ch_eog2}(durationsamples(ch_eog2)...
                +1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eog2));
        end
    else
        var_eog(:,2) = sn_getVariance(signalcells{ch_eog2},'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eog2));
    end
end

if (strcmp(ch_all,'alice6'))
    disp('Alice6: check for second leg channel')
    %extend var_leg for two channels
    if (exist('ch_emgleg2','var'))
        var_leg = [ var_emgleg, zeros(length(var_emgleg),1)];
        if debug
            disp(['var_emgleg(:,2) = sn_getVariance(signalcells{' num2str(ch_emgleg2) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(ch_emgleg2)) ');'])
        end
        var_emgleg(:,2) = sn_getVariance(signalcells{ch_emgleg2},'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_emgleg2));
    end
end
    
if debug
    whos var_eog
    whos var_emgleg
    whos var_emgchin
end


%% extract frequency-powerbands
%get matrix with powerbands
if debug
    disp(['fpb = sn_getEEGBandPower(signalcells{' num2str(ch_eeg) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(ch_eeg)) ');'])
end

if strcmp(ch_all, 'charite')
    if lengthflag(ch_eeg)
        [fpb,sbmat] = sn_getEEGBandPower(signalcells{ch_eeg}(durationsamples(ch_eeg)...
            +1:durationsamples(ch_eeg)+hypnogramduration(ch_eeg)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg));
    else
        [fpb,sbmat] = sn_getEEGBandPower(signalcells{ch_eeg}(durationsamples(ch_eeg)...
            +1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg));
    end
else
    [fpb,sbmat] = sn_getEEGBandPower(signalcells{ch_eeg},'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg));
end

if (strcmp(ch_all,'siesta') | strcmp(ch_all,'alice6'))
    disp('SIESTA and Alice6: getting all six EEGs')
    fpb = repmat(fpb,[1 5]);
    whos fpb
    %loop over channels, here channelnumber as explicitely used, as they
    %are anyhow fixed for Siesta
    for i =2:6
        if debug
            disp(['fpb(:,(i-1)*5+1:i*5) = sn_getEEGBandPower(signalcells{' num2str(i) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(i)) ');'])
        end
        fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{i},'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(i));
    end
    if debug
        whos fpb
    end
elseif(strcmp(ch_all, 'charite'))
    disp('Charite: getting all four EEGs')
    fpb = repmat(fpb,[1 4]);
    whos fpb
    %loop over channels, here channelnumber as explicitely used at
    %Charite
    for i =2:4
        if debug
            disp(['fpb(:,(i-1)*5+1:i*5) = sn_getEEGBandPower(signalcells{' num2str(i) '},''wl'',' num2str(wl_sfe) ',''ws'',' num2str(ws_sfe) ',''sf'',' num2str(sfch(i)) ');'])
        end
        if lengthflag(ch_eeg2)
            if i == 2
                fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{ch_eeg2}(durationsamples(ch_eeg2)...
                    +1:durationsamples(ch_eeg2)+hypnogramduration(ch_eeg2)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg2));
            elseif i == 3
                fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{ch_eeg3}(durationsamples(ch_eeg3)...
                    +1:durationsamples(ch_eeg3)+hypnogramduration(ch_eeg3)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg3));
            elseif i == 4
                fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{ch_eeg4}(durationsamples(ch_eeg4)...
                    +1:durationsamples(ch_eeg4)+hypnogramduration(ch_eeg4)),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg4));
            end
        else
            if i == 2
                fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{ch_eeg2}(durationsamples(ch_eeg2)+1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg2));
            elseif i == 3
                fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{ch_eeg3}(durationsamples(ch_eeg3)+1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg3));
            elseif i == 4
                fpb(:,(i-1)*5+1:i*5) =  sn_getEEGBandPower(signalcells{ch_eeg4}(durationsamples(ch_eeg4)+1:end),'wl',wl_sfe,'ws',ws_sfe,'sf',sfch(ch_eeg4));
            end
        end
    end
    if debug
        whos fpb
    end
end
% use mean band amplitude rather than power
fpb = sqrt(fpb);


%% TDS
%concat the signals, columns = signal, row = time
if debug
    disp('biosignals_tds = [ heartrate breathingrate var_emgchin var_emgleg var_eog fpb ];')
end

biosignals_tds = [ heartrate breathingrate var_emgchin var_emgleg var_eog fpb ];
if debug
    whos biosignals_tds
end

%get crosscorrelation of signals, samplingfrequency equals windowshift of
%feature extraction
%xcc: maximum correlationcoefficient
%xcl: correlation lag of xcc
if debug
    disp(['[xcc,xcl] = sn_getCrossCorrelation(biosignals_tds,''wl'',' num2str(wl_xcc) ',''ws'',' num2str(ws_xcc) ',''sf'',' num2str(ws_sfe) ');'])
end
[xcc,xcl] = sn_getCrossCorrelation(biosignals_tds,'wl',wl_xcc,'ws',ws_xcc,'sf',ws_sfe);
if debug
    whos xcc
end
%stability analysis
if debug
    disp(['[tds] = sn_getStability(xcl,''wl'',' num2str(wl_tds) ',''ws'',' num2str(ws_tds) ',''mld'',' num2str(mld_tds) ',''mlf'',' num2str(mlf_tds) ',''sf'',' num2str(ws_sfe) ');'])
end
[tds] = sn_getStability(xcl,'wl',wl_tds,'ws',ws_tds,'mld',mld_tds,'mlf',mlf_tds,'sf',ws_sfe);
if debug
    whos tds
end
end


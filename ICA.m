% EEGLAB history file generated on the 19-Apr-2019
% change PP no.x to current participant no.
% change no. + group name based on current no. & group
%% Set up data for all participants; open eeglab


subject_list = { %'PP3', 'PP4','PP10','PP11','PP12','PP18', ...
    %'PP27','PP31','PP36','PP37', ...
    'PP41','PP42','PP47','PP50','PP59','PP62', ... % TM
    'PP38','PP39','PP45','PP46','PP51','PP54','PP55','PP57',...
    'PP60','PP63','PP65','PP66','PP69', ... % TNM
    'PP13','PP16','PP17','PP19','PP20','PP22','PP26', ...
    'PP34','PP35','PP40','PP48','PP49','PP56','PP61','PP64', ... % NTM
    'PP7','PP15','PP21','PP23','PP24','PP25','PP28','PP29', ...
    'PP32','PP33','PP43','PP44','PP53','PP58','PP67', ... % NTNM
    'PP8','PP30','PP52','PP70' % Exclude
    };

numsubjects  = length(subject_list); % number of subjects

parentfolder = 'D:\New\';  

%% ------------------------------------------------

for s=1:numsubjects
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    subject = subject_list{s};

    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    EEG = pop_loadset('filename',[subject '_filt.set'],'filepath', parentfolder);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );  
    
    % automatic channel rejection ( and save current dataset )
    EEG = eeg_checkset( EEG );
    EEG = pop_rejchan(EEG, 'elec',[1:32] ,'threshold',5,'norm','on','measure','kurt');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[subject ' resampled auto rej'],...
        'savenew',[parentfolder 'temp' subject '_autorej.set'],'gui','off'); 

    % interpolate based on loaded set
    EEG = eeg_checkset( EEG );
    EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 

    % run ICA
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_saveset( EEG, 'filename',[subject '_ICA.set'],'filepath', 'D:\\ICA\\');
    
    EEG = eeg_checkset( EEG );
    pop_topoplot(EEG,0, [1:34] ,[subject ' IC'],[6 6] ,0,'electrodes','on');
    print('-dpng', [subject '_ICA.png'])
    
%     % rereference to average
%     EEG = eeg_checkset( EEG );
%     EEG = pop_reref( EEG, [],'exclude',[33 34] );
%     % create eventlist
%     EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); % GUI: 19-Apr-2019 20:47:05
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
%     % assign bins
%     EEG  = pop_binlister( EEG , 'BDF', 'C:\Users\Annette\Desktop\Dataset\binlister.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 19-Apr-2019 20:47:27
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     % extract epochs
%     EEG = pop_epochbin( EEG , [-300.0  2000.0],  'pre'); % GUI: 19-Apr-2019 20:49:00
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
%     % low pass filter 20 Hz
%     EEG = eeg_checkset( EEG );
%     EEG = pop_eegfiltnew(EEG, [],20,338,0,[],0);
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
%     % save epoched set
%     EEG = pop_saveset( EEG, 'filename',[subject '_epoch.set'],'filepath','C:\\Users\\Annette\\Desktop\\Dataset\\New3');
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     %% moving window artifact detection (CHANGE CHANNEL NUMBERS / voltage 100 or 75)
%     EEG  = pop_artmwppth( EEG , 'Channel',  1:34, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -300.8 1998], 'Windowsize',  200, 'Windowstep',  100 ); % GUI: 19-Apr-2019 20:50:06
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
%     EEG = eeg_checkset( EEG );
%     %% steplike artifact detection (CHANGE CHANNEL NUMBERS / voltage 100 or 75)
%     EEG  = pop_artstep( EEG , 'Channel',  1:34, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -300.8 1998], 'Windowsize',  200, 'Windowstep',  50 ); % GUI: 19-Apr-2019 20:56:33
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew',['C:\\Users\\Annette\\Desktop\\Dataset\\New3\\' subject '_flagged.set'],'gui','off'); 
%     %% save flagged ERP set
%     EEG = pop_saveset( EEG, 'filename',[subject '_flagged.set'],'filepath','C:\\Users\\Annette\\Desktop\\Dataset\\New3');
%     ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  4, 'ExcludeBoundary', 'on', 'SEM', 'on' );
%     ERP = pop_savemyerp(ERP, 'erpname', subject, 'filename', [subject '.erp'], 'filepath', ...
%         'C:\Users\Annette\Desktop\Dataset\NTM_New3', 'Warning', 'on');
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     % save artifact rejection summary
%     EEG = pop_summary_AR_eeg_detection(EEG, ['C:\Users\Annette\Desktop\Dataset\NTM_New3\AR_summary_' subject '.txt']);
end
% EEGLAB history file generated on the 19-Apr-2019
% change PP no.x to current participant no.
% change no. + group name based on current no. & group
%% Set up data for nontonal musicians

subject_list = {'PP13','PP16','PP17','PP19','PP20','PP22','PP26',...
    'PP34','PP35','PP40','PP48','PP49','PP56','PP61','PP64'};

numsubjects  = length(subject_list); % number of subjects

parentfolder = 'C:\Users\Annette\Desktop\Data\Annette\NontonalMusician\';  

%% ------------------------------------------------

for s=1:numsubjects
    
    subject = subject_list{s};

    subjectfolder = [parentfolder subject '.bdf'];

    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_biosig(subjectfolder, 'channels',[1:34] );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',subject,'gui','off'); 
    % downsample to 512Hz
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 512);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew',['C:\\Users\\Annette\\Desktop\\Dataset\\New\\' subject '_res.set'],'overwrite','on','gui','off'); 

    % look up channel locations
    EEG=pop_chanedit(EEG, 'lookup',...
        'C:\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    % filter
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, [],50,136,0,[],0);
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, [],0.5,3380,1,[],0);
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, [],30,226,0,[],0);
    
    % automatic channel rejection ( and save current dataset )
    EEG = eeg_checkset( EEG );
    EEG = pop_rejchan(EEG, 'elec',[1:32] ,'threshold',5,'norm','on','measure','kurt');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[subject ' resampled auto rej'],'saveold',['C:\\Users\\Annette\\Desktop\\Dataset\\New\\' subject '_filt.set'],'gui','off'); 
%   [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',['C:\\Users\\Annette\\Desktop\\Dataset\\New\\' subject '_cha.set'],'saveold',['C:\\Users\\Annette\\Desktop\\Dataset\\' subject '_res.set'],'gui','off'); 
%   [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname', subject,'saveold',['C:\\Users\\Annette\\Desktop\\Dataset\\New\\' subject '_res.set'], 'overwrite','off','gui','off'); 
%   [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite', 'on', 'gui','off'); 
    

    % interpolate based on loaded set
    EEG = eeg_checkset( EEG );
    EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
    
    % eeglab redraw
    % rereference to average
    EEG = eeg_checkset( EEG );
    EEG = pop_reref( EEG, [],'exclude',[33 34] );
    
%     % low pass filter 20 Hz
%     EEG = eeg_checkset( EEG );
%     EEG = pop_eegfiltnew(EEG, [],20,338,0,[],0);
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname','PP13 refiltered','saveold','C:\\Users\\Annette\\Desktop\\Dataset\\New\\PP13NM_reref.set','gui','off'); 


    % create eventlist
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); % GUI: 19-Apr-2019 20:47:05
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    % assign bins
    EEG  = pop_binlister( EEG , 'BDF', 'C:\Users\Annette\Desktop\Dataset\binlister.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 19-Apr-2019 20:47:27
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    % save epoched dataset
    EEG = pop_epochbin( EEG , [-300.0  2000.0],  'pre'); % GUI: 19-Apr-2019 20:49:00
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
    EEG = pop_saveset( EEG, 'filename',[subject '_epoch.set'],'filepath','C:\\Users\\Annette\\Desktop\\Dataset\\New');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    % update GUI
%     eeglab redraw;

    %% moving window artifact detection (CHANGE CHANNEL NUMBERS / voltage 100 or 75)
    EEG  = pop_artmwppth( EEG , 'Channel',  1:34, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -300.8 1998], 'Windowsize',  200, 'Windowstep',  100 ); % GUI: 19-Apr-2019 20:50:06
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    EEG = eeg_checkset( EEG );
    %% steplike artifact detection (CHANGE CHANNEL NUMBERS / voltage 100 or 75)
    EEG  = pop_artstep( EEG , 'Channel',  1:34, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -300.8 1998], 'Windowsize',  200, 'Windowstep',  50 ); % GUI: 19-Apr-2019 20:56:33
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew',['C:\\Users\\Annette\\Desktop\\Dataset\\New\\' subject '_flagged.set'],'gui','off'); 
    %% save flagged ERP set
    EEG = pop_saveset( EEG, 'filename',[subject '_flagged.set'],'filepath','C:\\Users\\Annette\\Desktop\\Dataset\\New');
    ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  4, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', subject, 'filename', [subject '.erp'], 'filepath', ...
        'C:\Users\Annette\Desktop\Dataset\NTM_New', 'Warning', 'on');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    % save artifact rejection summary
    EEG = pop_summary_AR_eeg_detection(EEG, ['C:\Users\Annette\Desktop\Dataset\NTM_New\AR_summary_' subject '.txt']);
    % update GUI
%   % eeglab redraw;

end

eeglab redraw
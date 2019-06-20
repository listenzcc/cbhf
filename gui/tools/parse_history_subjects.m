function parse_history_subjects(handles)

global gvar

dirs = dir(fullfile(gvar.runtime_path, 'subjects'));
dirs(1:2) = '';

if isempty(dirs)
    return
end

set(handles.popupmenu_subject_selector, 'String', {'--'});

history_names = {};
history_gvars = {};

for d = dirs'
    subject_id_path = fullfile(d.folder, d.name);
    if ~exist(fullfile(subject_id_path, 'gvar_saved.mat'), 'file')
        continue
    end
    for j = 1 : 4
        if exist(fullfile(subject_id_path, sprintf('_____preprocessed_%d', j)), 'dir')
            load(fullfile(subject_id_path, 'gvar_saved.mat'), 'gvar_saved');
            
            info = sprintf('%s, %s, %s',...
                gvar_saved.subject_info_.PatientName,...
                gvar_saved.subject_info_.SeriesDescription,...
                gvar_saved.subject_info_.AcquisitionDate);
            
            history_names{length(history_names)+1, 1} = info;
            
            %  console_report(handles, sprintf('History find: %s.', info))
            
            history_gvars{length(history_gvars)+1, 1} = gvar_saved;
            continue
        end
    end
end

if isempty(history_names)
    return
end

set(handles.popupmenu_subject_selector ,'String', history_names);

gvar.history_gvars = history_gvars;

end


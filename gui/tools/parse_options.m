function parse_options(handles)
global gvar

%% parse band filter
% str2double
bandpass_low = str2double(handles.edit_bandpass_low.String);
bandpass_high = str2double(handles.edit_bandpass_high.String);

% dummy correction
if isnan(bandpass_low) || (bandpass_low < 0)
    handles.edit_bandpass_low.String = '0.01';
    bandpass_low = 0.01;
    warndlg('Wrong input!')
end

if isnan(bandpass_high) || (bandpass_high < 0)
    handles.edit_bandpass_high.String = '0.08';
    bandpass_high = 0.08;
    warndlg('Wrong input!')
end

if bandpass_low >= bandpass_high
    handles.edit_bandpass_low.String = '0.01';
    bandpass_low = 0.01;
    handles.edit_bandpass_high.String = '0.08';
    bandpass_high = 0.08;
    warndlg('Wrong input!')
end

% save data
gvar.bandpass_filter = [bandpass_low, bandpass_high];

console_report(handles,...
    sprintf('Filter %.4f ~ %.4f', gvar.bandpass_filter))

%% parse head motion removal option
gvar.remove_head_motion = handles.radiobutton_head_motion.Value;
console_report(handles,...
    sprintf('Remove head motion: %d', gvar.remove_head_motion))

%% parse global removal option
gvar.remove_global = handles.radiobutton_global.Value;
console_report(handles,...
    sprintf('Remove global: %d', gvar.remove_global))

end
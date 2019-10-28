function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 28-Oct-2019 16:10:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

reset_preprocess(handles)
reset_hippocampus(handles)
reset_parietal(handles)

global gvar
gvar = varargin{1};

parse_history_subjects(handles)


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_loadnewsubject.
function pushbutton_loadnewsubject_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadnewsubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

console_report(handles, '', 'clear')
console_report(handles, repmat('#', 1, 80))
try
    console_report(handles, sprintf('    %s', datetime))
catch
end

try
    set(handles.popupmenu_subject_selector, 'Enable', 'off')
    set(handles.edit_TRms, 'Enable', 'off')
    [dir_path, subject_info, string] = gui_select_folder;
    reset_preprocess(handles)
    reset_hippocampus(handles)
    reset_parietal(handles)
    set(handles.text_subject_info, 'String', '[Subject information]')
catch
    parse_history_subjects(handles)
    set(handles.popupmenu_subject_selector, 'Enable', 'on')
    print('something is wrong')
    return
end

handles.text_subject_info.String = string;
handles.edit_TRms.String = sprintf('%.0f', 2000); % subject_info.RepetitionTime);

clear gvar
global gvar

gvar = struct;
gvar.runtime_path = fullfile(fileparts(which('start_TMSHF')));
gvar.resources_path = fullfile(gvar.runtime_path, 'resources');

gvar.subject_info_ = subject_info;

console_report(handles, sprintf('New session: %s', subject_info.inner_id))

% global inner_id
% inner_id = subject_info.inner_id;

gvar.subject_rawfile_path = dir_path;

gvar.subject_id_path = fullfile(gvar.runtime_path, 'subjects', subject_info.inner_id);
[a, b, c] = mkdir(gvar.subject_id_path);

gvar_saved = gvar;
save(fullfile(gvar.subject_id_path, 'gvar_saved.mat'), 'gvar_saved');

parse_history_subjects(handles)
set(handles.popupmenu_subject_selector, 'Enable', 'on')
set(handles.edit_TRms, 'Enable', 'on')
set(handles.pushbutton_preprocess, 'Enable', 'on')


% --- Executes on button press in pushbutton_preprocess.
function pushbutton_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_preprocess(handles)
reset_hippocampus(handles)
reset_parietal(handles)

global gvar
console_report(handles, repmat('-', 1, 20))
console_report(handles, 'Preprocessing ...')
console_report(handles, sprintf('Working path: %s', gvar.subject_id_path));

console_report(handles, 'DICOM import ...');
fun_preprocess_1
console_report(handles, 'DICOM import done');

parse_history_subjects(handles)

console_report(handles, 'Realign ...');
fun_preprocess_2
console_report(handles, 'Realign done');

console_report(handles, 'Normalize ...');
fun_preprocess_3
console_report(handles, 'Normalize done');

console_report(handles, 'Smooth ...');
fun_preprocess_4
console_report(handles, 'Smooth done');

console_report(handles, 'Preprocess done');
console_report(handles, repmat('-', 1, 20))

report_artificial(handles)
set(handles.edit_crop_from, 'Enable', 'off')
set(handles.edit_crop_to, 'Enable', 'off')

load_data_for_analysis(handles)

set(handles.pushbutton_preprocess, 'Enable', 'on')
set(handles.pushbutton_redraw_hippo, 'Enable', 'on')
set(handles.edit_crop_from, 'Enable', 'on')
set(handles.edit_crop_to, 'Enable', 'on')


% --- Executes on button press in pushbutton_redraw_hippo.
function pushbutton_redraw_hippo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_redraw_hippo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset_hippocampus(handles)
reset_parietal(handles)

redraw_hippocampus(handles)


% --- Executes on selection change in listbox_console_report.
function listbox_console_report_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_console_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_console_report contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_console_report


% --- Executes during object creation, after setting all properties.
function listbox_console_report_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_console_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes_head_motion_123_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_head_motion_123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_head_motion_123
set(hObject, 'XTick', [])
set(hObject, 'YTick', [])
set(hObject, 'Box', 'off')


% --- Executes during object creation, after setting all properties.
function axes_head_motion_456_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_head_motion_456 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_head_motion_456
set(hObject, 'XTick', [])
set(hObject, 'YTick', [])
set(hObject, 'Box', 'off')


% --- Executes during object creation, after setting all properties.
function axes_hippo_ts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_hippo_ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_hippo_ts
set(hObject, 'XTick', [])
set(hObject, 'YTick', [])
set(hObject, 'Box', 'off')


function edit_coor_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_coor_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_coor_x as text
%        str2double(get(hObject,'String')) returns contents of edit_coor_x as a double
redraw_hippocampus(handles)


% --- Executes during object creation, after setting all properties.
function edit_coor_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_coor_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_coor_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_coor_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_coor_y as text
%        str2double(get(hObject,'String')) returns contents of edit_coor_y as a double
redraw_hippocampus(handles)


% --- Executes during object creation, after setting all properties.
function edit_coor_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_coor_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_coor_z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_coor_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_coor_z as text
%        str2double(get(hObject,'String')) returns contents of edit_coor_z as a double
redraw_hippocampus(handles)


% --- Executes during object creation, after setting all properties.
function edit_coor_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_coor_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_selector.
function popupmenu_selector_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_selector

cells = strsplit(hObject.String{hObject.Value}, ',');
parietal_mm = [str2double(cells{2}), str2double(cells{3}), str2double(cells{4})];
plot_parietal(handles, parietal_mm, hObject.Value)

% --- Executes during object creation, after setting all properties.
function popupmenu_selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_data_holder.
function pushbutton_data_holder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_data_holder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gvar
gvar


% --- Executes on button press in radiobutton_head_motion.
function radiobutton_head_motion_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_head_motion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_head_motion
redraw_hippocampus(handles)


% --- Executes on button press in radiobutton_global.
function radiobutton_global_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_global (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_global
redraw_hippocampus(handles)


function edit_bandpass_low_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bandpass_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bandpass_low as text
%        str2double(get(hObject,'String')) returns contents of edit_bandpass_low as a double
redraw_hippocampus(handles)


% --- Executes during object creation, after setting all properties.
function edit_bandpass_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bandpass_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_bandpass_high_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bandpass_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bandpass_high as text
%        str2double(get(hObject,'String')) returns contents of edit_bandpass_high as a double
redraw_hippocampus(handles)


% --- Executes during object creation, after setting all properties.
function edit_bandpass_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bandpass_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text7.
function text7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.edit_bandpass_low, 'Enable'), 'on')
    global gvar
    fs = 1000 / gvar.subject_info_.RepetitionTime;
    % f = gcf;
    f = figure;
    try
        bandpass(gvar.ts_hippo_before_bp, gvar.bandpass_filter, fs);
    catch
        disp('No bandpass function found, consider using a newer matlab')
        close(f)
    end
    % figure(f);
end


% --- Executes on button press in pushbutton_analysis_fc.
function pushbutton_analysis_fc_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analysis_fc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset_parietal(handles)
redraw_parietal(handles)

set(handles.popupmenu_selector, 'Value', 1);
cells = strsplit(handles.popupmenu_selector.String{1}, ',');
parietal_mm = [str2double(cells{2}), str2double(cells{3}), str2double(cells{4})];
plot_parietal(handles, parietal_mm, 1)


% --- Executes on button press in pushbutton_emperical.
function pushbutton_emperical_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_emperical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gvar

strings = get(handles.popupmenu_selector, 'String');
for j = 1 : length(strings)
    if strfind(strings{j}, sprintf('%d, %d, %d', gvar.parietal_mm_emperical))
        set(handles.popupmenu_selector, 'Value', j)
        plot_parietal(handles, gvar.parietal_mm_emperical, j)
        break
    end
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear all
disp('Bye Bye.')


% --- Executes on selection change in popupmenu_subject_selector.
function popupmenu_subject_selector_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_subject_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_subject_selector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_subject_selector

reset_preprocess(handles)
reset_hippocampus(handles)
reset_parietal(handles)

global gvar

idx = get(hObject, 'Value');
s = get(hObject, 'String');
if strcmp(s{idx}, '--')
    return
end

h = gvar.history_gvars;

gvar = gvar.history_gvars{idx};
gvar.history_gvars = h;

subject_info = gvar.subject_info_;
string = {
    sprintf('PatientName:       %s', subject_info.PatientName);
    sprintf('PatientSex:        %s', subject_info.PatientSex);
    sprintf('PatientAge:        %s', subject_info.PatientAge);
    sprintf('AcquisitionDate:   %s', subject_info.AcquisitionDate);
    sprintf('AcquisitionTime:   %s', subject_info.AcquisitionTime);
    sprintf('SeriesDescription: %s', subject_info.SeriesDescription);
    };
handles.text_subject_info.String = string;
handles.edit_TRms.String = sprintf('%.0f', 2000);  % subject_info.RepetitionTime);

console_report(handles, '', 'clear')
console_report(handles, repmat('#', 1, 80))
try
    console_report(handles, sprintf('    %s', datetime))
catch
end
console_report(handles, sprintf('New session: %s', subject_info.inner_id))

set(handles.pushbutton_preprocess, 'Enable', 'on')
set(handles.edit_TRms, 'Enable', 'on')


% --- Executes during object creation, after setting all properties.
function popupmenu_subject_selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_subject_selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TRms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TRms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TRms as text
%        str2double(get(hObject,'String')) returns contents of edit_TRms as a double
if isnan(str2double(get(hObject, 'String')))
    warndlg(sprintf('"%s" is not a legal TR, using "2000" as default',...
        get(hObject, 'String')))
    set(hObject, 'String', '2000')
end
console_report(handles, sprintf('TR is set to %s ms', get(hObject, 'String')))
reset_preprocess(handles)
reset_hippocampus(handles)
reset_parietal(handles)
set(handles.pushbutton_preprocess, 'Enable', 'on')


% --- Executes during object creation, after setting all properties.
function edit_TRms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TRms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_crop_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_crop_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_crop_from as text
%        str2double(get(hObject,'String')) returns contents of edit_crop_from as a double
global gvar

from = str2double(get(handles.edit_crop_from, 'String'));
to = str2double(get(handles.edit_crop_to, 'String'));

if isnan(from+to) || (to-from) < 20 || from < gvar.crop_from_limit || to > gvar.crop_to_limit
    disp('Wrong cropping parameters, using default.')
    
    set(handles.edit_crop_from, 'String', sprintf('%.0f', gvar.crop_from_limit))
    set(handles.edit_crop_to, 'String', sprintf('%.0f', gvar.crop_to_limit))
end

set(handles.edit_crop_from, 'Enable', 'off')
set(handles.edit_crop_to, 'Enable', 'off')
reset_hippocampus(handles)
reset_parietal(handles)
plot_artificial(handles)
load_data_for_analysis(handles)
set(handles.pushbutton_redraw_hippo, 'Enable', 'on')
set(handles.edit_crop_from, 'Enable', 'on')
set(handles.edit_crop_to, 'Enable', 'on')


% --- Executes during object creation, after setting all properties.
function edit_crop_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_crop_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_crop_to_Callback(hObject, eventdata, handles)
% hObject    handle to edit_crop_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_crop_to as text
%        str2double(get(hObject,'String')) returns contents of edit_crop_to as a double
global gvar

from = str2double(get(handles.edit_crop_from, 'String'));
to = str2double(get(handles.edit_crop_to, 'String'));

if isnan(from+to) || (to-from) < 20 || from < gvar.crop_from_limit || to > gvar.crop_to_limit
    disp('Wrong cropping parameters, using default.')
    
    set(handles.edit_crop_from, 'String', sprintf('%.0f', gvar.crop_from_limit))
    set(handles.edit_crop_to, 'String', sprintf('%.0f', gvar.crop_to_limit))
end

set(handles.edit_crop_from, 'Enable', 'off')
set(handles.edit_crop_to, 'Enable', 'off')
reset_hippocampus(handles)
reset_parietal(handles)
plot_artificial(handles)
load_data_for_analysis(handles)
set(handles.pushbutton_redraw_hippo, 'Enable', 'on')
set(handles.edit_crop_from, 'Enable', 'on')
set(handles.edit_crop_to, 'Enable', 'on')


% --- Executes during object creation, after setting all properties.
function edit_crop_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_crop_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_next_large.
function pushbutton_next_large_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next_large (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gvar

j = get(handles.popupmenu_selector, 'Value');

if (j+1) <= length(handles.popupmenu_selector.String)
    set(handles.popupmenu_selector, 'Value', j+1);
    cells = strsplit(handles.popupmenu_selector.String{j+1}, ',');
    parietal_mm = [str2double(cells{2}), str2double(cells{3}), str2double(cells{4})];
    plot_parietal(handles, parietal_mm, j+1)
end



% --- Executes on button press in pushbutton_back_largest.
function pushbutton_back_largest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_back_largest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gvar

set(handles.popupmenu_selector, 'Value', 1);
cells = strsplit(handles.popupmenu_selector.String{1}, ',');
parietal_mm = [str2double(cells{2}), str2double(cells{3}), str2double(cells{4})];
plot_parietal(handles, parietal_mm, 1)



% --- Executes on button press in pushbutton_3D.
function pushbutton_3D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gvar

gvar

fpath = fullfile(gvar.resources_path, 'SurfTemplate', 'BrainMesh_ICBM152_smoothed.nv');

mms = [
    str2double(get(handles.edit_coor_x, 'String'));...
    str2double(get(handles.edit_coor_y, 'String'));...
    str2double(get(handles.edit_coor_z, 'String'))];

for j = 1 : get(handles.popupmenu_selector, 'Value')
    cells = strsplit(handles.popupmenu_selector.String{j}, ',');
    mm_p = [str2double(cells{2}); str2double(cells{3}); str2double(cells{4})];
    mms = [mms, mm_p];
end
% mms =[mms,[
%     str2double(get(handles.text_coor_x, 'String'));...
%     str2double(get(handles.text_coor_y, 'String'));...
%     str2double(get(handles.text_coor_z, 'String'))]];

fun_plot_3D_surface(fpath, mms)



% --- Executes on button press in radiobutton_left_only.
function radiobutton_left_only_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_left_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_left_only
reset_parietal(handles)
global gvar
gvar.left_only = handles.radiobutton_left_only.Value;
redraw_parietal(handles)


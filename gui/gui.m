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

% Last Modified by GUIDE v2.5 11-Jun-2019 21:53:27

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

pnt_welcome

[dir_path, subject_info] = gui_select_folder

string = {
    sprintf('PatientName:       %s', subject_info.PatientName);
    sprintf('PatientSex:        %s', subject_info.PatientSex);
    sprintf('PatientAge:        %s', subject_info.PatientAge);
    sprintf('AcquisitionDate:   %s', subject_info.AcquisitionDate);
    sprintf('AcquisitionTime:   %s', subject_info.AcquisitionTime);
    sprintf('SeriesDescription: %s', subject_info.SeriesDescription);
    };
handles.text_subject_info.String = string;

global inner_id
inner_id = subject_info.inner_id;

global subject_rawfile_path
subject_rawfile_path = dir_path;

global runtime_path
global subject_id_path
subject_id_path = fullfile(runtime_path, 'subjects', inner_id);
[a, b, c] = mkdir(subject_id_path);


function listbox_preprocess_info_add(handles, string)
    handles.listbox_preprocess_info.String{...
    length(handles.listbox_preprocess_info.String)+1, 1} =...
    string;
    pause(1)


% --- Executes on button press in pushbutton_preprocess.
function pushbutton_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global subject_id_path

handles.listbox_preprocess_info.Value = 1;
handles.listbox_preprocess_info.String = {};
listbox_preprocess_info_add(handles,...
    sprintf('Working on: %s', subject_id_path));

listbox_preprocess_info_add(handles, 'DICOM import ...');
fun_preprocess_1
listbox_preprocess_info_add(handles, 'DICOM import done');

listbox_preprocess_info_add(handles, 'Realign ...');
fun_preprocess_2
listbox_preprocess_info_add(handles, 'Realign done');

listbox_preprocess_info_add(handles, 'Normalize ...');
fun_preprocess_3
listbox_preprocess_info_add(handles, 'Normalize done');

listbox_preprocess_info_add(handles, 'Smooth ...');
fun_preprocess_4
listbox_preprocess_info_add(handles, 'Smooth done');



% --- Executes on selection change in listbox_preprocess_info.
function listbox_preprocess_info_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_preprocess_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_preprocess_info contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_preprocess_info


% --- Executes during object creation, after setting all properties.
function listbox_preprocess_info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_preprocess_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

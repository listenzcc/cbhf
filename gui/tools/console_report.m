function console_report(handles, string, opt)
if nargin > 2
    if strcmp(opt, 'clear')
        handles.listbox_console_report.Value = 1;
        handles.listbox_console_report.String = {};
        return
    end
end

disp(string)

handles.listbox_console_report.String{...
    length(handles.listbox_console_report.String)+1, 1} = string;

handles.listbox_console_report.Value =...
    length(handles.listbox_console_report.String);

pause(0.2)
end

function [info, string] = get_subject_info(file_path)
rawinfo = dicominfo(file_path);

info = rawinfo;
try
    info.PatientName = sprintf('%s %s',...
        rawinfo.PatientName.FamilyName, rawinfo.PatientName.GivenName);
catch
    info.PatientName = rawinfo.PatientName.FamilyName;
end
info.inner_id = md5(file_path);

string = {
    sprintf('PatientName:       %s', info.PatientName);
    sprintf('PatientSex:        %s', info.PatientSex);
    sprintf('PatientAge:        %s', info.PatientAge);
    sprintf('AcquisitionDate:   %s', info.AcquisitionDate);
    sprintf('AcquisitionTime:   %s', info.AcquisitionTime);
    sprintf('SeriesDescription: %s', info.SeriesDescription);
    };
end
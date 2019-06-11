function info = get_subject_info(file_path)
rawinfo = dicominfo(file_path);

info = struct;
info.AcquisitionDate = rawinfo.AcquisitionDate;
info.AcquisitionTime = rawinfo.AcquisitionTime;
info.SeriesDescription = rawinfo.SeriesDescription;
info.PatientName = sprintf('%s %s', rawinfo.PatientName.FamilyName, rawinfo.PatientName.GivenName);
info.PatientSex = rawinfo.PatientSex;
info.PatientAge = rawinfo.PatientAge;
end
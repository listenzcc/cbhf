function info = get_subject_info(file_path)
rawinfo = dicominfo(file_path);

info = rawinfo;
info.PatientName = sprintf('%s %s',...
    rawinfo.PatientName.FamilyName, rawinfo.PatientName.GivenName);
info.inner_id = md5(file_path);
end
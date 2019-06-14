function [detrend_ts, befor_bandpass_ts, final_ts] = process_ts(raw_ts, ts_hm, ts_global)
global gvar

% Detrend
ts = spm_detrend(squeeze(raw_ts), 1);
detrend_ts = ts;

% Remove head motion
if gvar.remove_head_motion == 1
    for s = ts_hm
        ts = fun_regout(ts, s);
    end
end

% Remove global
if gvar.remove_head_motion == 1
    ts = fun_regout(ts, ts_global);
end

% Band pass filter
fs = 1000 / gvar.subject_info_.RepetitionTime;
befor_bandpass_ts = ts;
ts = bandpass(ts, gvar.bandpass_filter, fs);

final_ts = ts;

end
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
fs = 1 / gvar.tr;
befor_bandpass_ts = ts;
try
    ts = bandpass(ts, gvar.bandpass_filter, fs);
catch
    disp('No bandpass function found, consider using a newer matlab')
    disp('Using fft for bandpass.')
    ts = fft_bandpass(ts, gvar.bandpass_filter, fs);
end

final_ts = ts;

end

function new_ts = fft_bandpass(ts, bdf, fs)

freqs = linspace(0, fs, length(ts));
freqs(freqs<bdf(1)) = 0;
freqs(freqs>bdf(2)) = 0;
freqs = freqs + freqs(end:-1:1);

f = fft(ts);
f(freqs==0) = 0;
new_ts = real(ifft(f));

end
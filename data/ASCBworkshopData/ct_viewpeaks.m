%CT_VIEWPEAKS
%   Creates a plot to examine peaks as identified and described via
%   ct_pulseanalysis.
%
%   Usage: ct_viewpeaks(D, Z);
%
%Inputs:
%   D - Data, as a numeric vector. 
%   Z - The output structure from running ct_pulseanalysis on data D.

function [] = ct_viewpeaks(d,z)

%Create figure and plot data
figure; plot(d, 'Color', [0, 0.8, 0.6]); hold on;

np = numel(z.pkpos);

%Indicate peaks
ax = axis;  yr = diff(ax(3:4));
plot(z.pkpos, d(z.pkpos) + yr*0.025,'kv');

%Draw peak features
for s = 1:np
    %Show peak amplitudes (as a line from peak to base)
    plot(z.mpos([s,s]), z.mean(s)-[0,z.amp_peak(s)], 'b-');
    %Show peak durations (as horizontal line at half-height)
    plot(z.mpos(s)+z.dur(s).*[-0.5,0.5], ...
        z.mean([s,s]) - z.amp_mean(s)./10, 'b-');
    %Show rise and fall regions
    rts = z.mpos(s) - 0.5*z.dur(s) +[-z.rise(s), 0];  %Rise time points
    fts = z.mpos(s) + 0.5*z.dur(s) +[0, z.fall(s)];   %Fall time points
    plot(rts, d(ceil(rts)), 'r:');  plot(fts, d(floor(fts)), 'r:'); 
end




end
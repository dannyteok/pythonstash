%ASCB2015_DEMO
%   Demonstration procedure for the ASCB 2015 workshop

%% Visualize data
%Load data 
%John??

%% Evaluate and remove noise

%Load data with outliers. Using GMNN from the EKAR/GMNN set here.
load('data1.mat');
%View data 
ct_trackvis('triple', rfp, 'missing', 'zero', 'cmap', 'orange');
%Exclude outliers and view 
rfp_o = ct_outlier(rfp, [200, Inf], 10, 247);
ct_trackvis('triple', rfp_o, 'missing', 'zero', 'cmap', 'orange');

%To reduce high-frequency noise, low-pass filter data and view
rfp_f = ct_filter(rfp_o, 'low', 5, 0);
ct_trackvis('triple', rfp_f, 'missing', 'zero', 'cmap', 'orange');
%Close figures for next example
close all;

%View data with drift
%   First, fix some outliers for convenience
fret_o = ct_outlier(fret, [0.3, Inf]);
ct_trackvis('triple', fret_o, 'missing', 'zero', 'cmap', 'orange');
%Filter mean value, with a high-pass filter and view
fret_h = ct_filter(fret_o, 'high', 200, 0);
ct_trackvis('triple', fret_h, 'missing', 'zero', 'cmap', 'orange');
%   Demonstrate that track is now centered about its mean
figure; plot(fret_o(1,:));  hold on;  plot(fret_h(1,:), 'r:');
%   Filter to remove the baseline and compare
fret_b = ct_filter(fret_o, 'base', 50, 0);
plot(fret_b(1,:), 'k-');
ct_trackvis('triple', fret_b, 'missing', 'zero', 'cmap', 'orange');
%Close figures
close all; 

%Show example of noise in ratios??
load('data2.mat');
ct_trackvis('ensemble', rfpNuc(50,:), 'missing', 'zero', 'cmap', 'red');
ct_trackvis('ensemble', rfpCyt(50,:), 'missing', 'zero', 'cmap', 'red');
ct_trackvis('ensemble', rfpNuc(50,:)./rfpCyt(50,:), 'missing', 'zero', 'cmap', 'red');



%% Extract features
%Mean level
mean_val = nanmean(fret, 2);       %Takes the mean over time, for each cell
%   Display in some fashion??

%Evaluating derivatives, as for rate analysis
%   First filter data heavily, for a smooth local derivative
%   To smooth data heavily, use a higher cutoff with ct_filter 
rfp_f = ct_filter(rfp_o, 'low', 50, 0);
ct_trackvis('triple', rfp_f, 'missing', 'zero', 'cmap', 'orange');
drfp_f = diff(rfp_f,1,2);
ct_trackvis('triple', drfp_f, 'missing', 'zero', 'cmap', 'orange');

%Evaluating oscillations
osc = rfpNuc(24,:)./rfpCyt(24,:);  %An oscillatory sample
flat = rfpNuc(1,:)./rfpCyt(1,:);   %A flat sample
%   View samples
figure; plot(osc); hold on; plot(flat, 'r-');
%   Display power spectra per sample
figure; subplot(2,1,1); pwelch(osc(~isnan(osc)));   
set(gca, 'XScale', 'log'); axis tight;
subplot(2,1,2); pwelch(flat(~isnan(flat))); 
set(gca, 'XScale', 'log');axis tight;

%   Add a non-oscillatory sample
load('data1.mat');  
nosc = ct_filter(fret(12,:), 'base', 50, 0);
flat = ct_filter(fret(2,:), 'base', 50, 0);
figure; plot(nosc); hold on; plot(flat, 'r-');
%   The power spectra with pulses, but not oscillations
figure; subplot(2,1,1); pwelch(nosc(~isnan(nosc)));   
set(gca, 'XScale', 'log'); axis tight;
subplot(2,1,2); pwelch(flat(~isnan(flat))); 
set(gca, 'XScale', 'log');axis tight;
%Close figures for next example
close all;

%Peak finding
[pk, vy] = ct_getpeaks(nosc, 25);
%   View peaks
figure; plot(nosc); hold on; plot(pk(:,1), nosc(pk(:,1)), 'rv');
%   Smooth data prior to peak finding
nosc = ct_filter(nosc, 'low', 5);
[pk, vy] = ct_getpeaks(nosc, 25);
figure; plot(nosc); hold on; plot(pk(:,1), nosc(pk(:,1)), 'rv');
%   Filter by height of rise
[pk, vy] = ct_getpeaks(nosc, 25, 'min_rise', 0.04);
figure; plot(nosc); hold on; plot(pk(:,1), nosc(pk(:,1)), 'rv');
%Close figures for next example
close all;

%Peak characterization
nosc = ct_filter(nosc, 'low', 3);
z = ct_pulseanalysis(nosc, 'min_rise', 0.04, 'maxw', 30);
ct_viewpeaks(nosc,z);



%% Assess trends and statistics
%Features over time, by windowing
load('data1.mat');
sig = fret(48,:);
%   Clean up signal and get pulse features
sig = ct_filter(sig, 'base', 50, 0);
z = ct_pulseanalysis(sig, 'narm', 20, 'smooth', 3, 'maxw', 30);
ct_viewpeaks(sig,z);
%   Define windows over time to segregate features
nt = length(sig);  wsz = 100;  nt = floor(nt/wsz)*wsz;
twin = [(1:wsz:nt)',(wsz:wsz:nt)'];  nw = size(twin,1); np_win = zeros(1,nw);
for s = 1:nw;
    np_win(s) = nnz(z.mpos > twin(s,1) & z.mpos < twin(s,2));
end
figure; plot(np_win);
%   Use a moving window for better resolution
fvec = zeros(1,length(sig));  fvec(floor(z.mpos)) = 1;
wsz_vec = [1:2:wsz,wsz*ones(1,length(sig)-wsz),wsz:-2:1];
np_win = smooth(fvec,wsz)'.*wsz_vec;  
figure; plot(np_win);

%   Windowed mean over all traces
fret_b = ct_filter(fret,'base',50,0);
%Mean
figure; plot(smooth(nanmean(fret_b,1), wsz, 'moving'));


z = ct_pulseanalysis(fret_b, 'narm', 20, 'smooth', 3, 'maxw', 30);

%Number of pulses per track, within window
[nC, nT] = size(fret); d = zeros(nC, nT);  d(isnan(fret_b)) = nan;
for s = 1:nC;  d(s, floor(z(s).mpos)) = 1; end
dwin = nanmean(d,1); dwin = smooth(dwin, wsz, 'moving').*wsz_vec'; 
figure; plot(dwin);
%Include +/- standard error of the mean
nvt = mean(~isnan(fret_b),1);   %Number of valid tracks per time
swin = nanvar(d,[],1)./nvt;  swin = sqrt( smooth(swin, wsz, 'moving') );
hold on; plot(dwin-swin, 'r--'); plot(dwin+swin, 'r--');

%Mean amplitude, within window
d = nan(nC, nT);
for s = 1:nC; d(s, floor(z(s).mpos)) = z(s).amp_mean; end
%Take means over valid peaks, plot
dwin = nanmean(d,1); dwin = smooth(dwin, wsz, 'moving'); figure; plot(dwin);

%Close figures and clear data for next example
close all; clear;


%Comparisons with scalar data, e.g. experiment condition, endpoint measurement
%   Binning/clustering and hypothesis testing
%       Bin based on GMNN presence/absense, test for difference in EKAR
%   Statistical modeling, i.e. General Linear Models
%       GLMFIT for Pulse features to Time of S phase entry, maybe?

%Comparisons with dynamic data
%   Correlation
%       AMPKAR to FOXO?  EKAR to FOXO?
load('data2.mat');  [nC, nT] = size(CYratioCyt);
foxo = rfpCyt./rfpNuc;
nnd = ~isnan(CYratioCyt) & ~isnan(foxo);
c = zeros(1,nC); p = c;
for s = 1:nC; if ~any(nnd(s,:)); continue; end
    [c(s), p(s)] = corr(CYratioCyt(s, nnd(s,:))', foxo(s, nnd(s,:))');
end
nbins = ceil( range(c) ./ ( 3.5.*nanstd(c) ./ (nC.^(1/3)) ) );
figure; hist(c);

%   Cross-correlation
%       XCorr EKAR TO FOXO?  (No examples with shifted xcorr)
load('data3.mat');  [nC, nT] = size(CYratioCyt);
foxo = rfpCyt./rfpNuc;
nnd = ~isnan(CYratioCyt) & ~isnan(foxo);

c = cell(nC,1); lag = c; mx_lag = zeros(nC,1);
for s = 1:nC; if ~any(nnd(s,:)); continue; end
    [c{s}, lag{s}] = xcorr(CYratioCyt(s, nnd(s,:))', ...
        foxo(s, nnd(s,:))', 'coeff');
    [~,mxi] =  max(c{s});    mx_lag(s) = lag{s}(mxi);
end

figure; plot(lag{1}, c{1});
figure; hist(mx_lag);


%% Generate quality figures


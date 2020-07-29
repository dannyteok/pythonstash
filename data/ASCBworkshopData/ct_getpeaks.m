%CT_GETPEAKS
%   Identifies peaks (and associated valleys) in a vector, based on a
%   provided scale parameter.  Sets two local cutoff values, based on
%   maximum and minimum values of the data in a local time window.  Both
%   cutoff values must be crossed by any rise/fall to define a new
%   peak/valley.  
%
%Usage: 
%   [PKS, VLS] = ct_getpeaks(D, NARM, 'PARAM1', VALUE1, ...)
%       returns indices of the peaks (pks) and valleys (vls) of the vector
%       d, each with 2 columns.  pks reports the first and last high point
%       in each peak.  vls reports the low points immediately before and
%       after the peak.
%
%Inputs:
%   D - Data, as a numeric vector. 
%   NARM - an optional scale parameter defining the number of points
%       before and after each data point to consider in defining local
%       scale and cutoff values for identifying peaks.  Defaults to
%       floor(length(d)/10). 
%
%Parameters:
%   SMOOTH - For smoothing prior to peak finding, indicate the size of
%       features (in number of time points) to be removed via filtering.
%   MIN_VY - A minimum value to be used for the valley cutoff threshold; a
%       valley must drop below this value to be considered valid.
%   MIN_RISE - A minimum value for the rise above the local valley
%       threshold for a peak to be considered valid.


%   In the returned indices, each peak indicates that a rise from below the
%   cutoff just occurred.  Each valley indicates a fall from above cutoff,
%   so peak-to-valley pairs bound 'pulses', and may be used to direct
%   individual pulse analyses.


function [pks,vls] = ct_getpeaks(d, narm, varargin)
%Default settings
p.min_vy = 0;  p.min_rise = 0;  p.smooth = 0;

%Input option pair parsing:
nin = length(varargin);     %Check for even number of add'l inputs
if rem(nin,2) ~= 0; warning(['Additional inputs must be provided as ',...
        'option, value pairs']);  end
%Splits pairs to a structure
for s = 1:2:nin;   p.(lower(varargin{s})) = varargin{s+1};   end

%Get data statistics and ensure uniform data vector
d = d(:);  nd = length(d);

%Smooth data, if requested
if p.smooth > 1;  d = ct_filter(d', 'noise', max(2.5,p.smooth), 0)';  end

%Local mean window half size defaults to 1/10th of data
if ~exist('narm','var') || isempty(narm);   narm = floor(nd/10); end

%Get extrema of data, yielding every peak, valley
dd = diff(d);
ddd = diff(sign(dd)); pks = find(ddd < 0) + 1; vls = find(ddd > 0) + 1;


%% Define local cut-off values
%   Determines which rises/falls cross a sufficient region to be considered
%   valid, using a local minimum as a baseline and an estimate of noise to
%   define thresholds.
%   Noise estimate can be made by the distribution of derivatives,
%   suggesing that rises crossing the thresholds must be particularly large
%   or continue over multiple points (i.e. not random)

%Define locality for filtering
nnd = ~isnan(d);  %Index to avoid NaNs
nlm = 2*narm+1;  lflt = ones(1, min(floor(nnz(nnd)/3)-1, nlm))./nlm;
%Generate local minimum trace (filtered for smoothness)
str = strel('line', nlm, 90);  mnv = nan(size(d));  mxv = mnv;  %Initialize
mnv(nnd) = imerode(d(nnd), str);    %Erode to get local minimum
mnv(nnd) = filtfilt( lflt, 1, mnv(nnd));
%And local maximum trace
mxv(nnd) = imdilate(d(nnd), str);   %Dilate to get local maximum
mxv(nnd) = filtfilt( lflt, 1, mxv(nnd));

%Define maximum valley cutoff and minimum rise cutoff
vly_thresh  = max(p.min_vy, 0.66*mnv + 0.34*mxv);
min_rise    = vly_thresh + 0.25*nanmean(mxv - mnv);


%% Get peaks/valleys
%Remove valleys above lower cutoff, peaks below higher cutoff
vls(d(vls) > vly_thresh(vls)) = [];  pks(d(pks) < min_rise(pks)) = [];
%   IF no valleys are found here, return as empty
if isempty(vls); pks = []; return; end
%   First/last feature may not be a peak
pks(pks < vls(1) | pks > vls(end)) = [];
%   IF no peaks remain, return as empty
if isempty(pks); vls = []; return; end
%Remove peaks failing to meet minimum rise (amplitude)
pks( d(pks) - interp1([1;vls;nd],d(vls([1,1:end,end])),pks) ...
        < p.min_rise ) = [];

%Get list of peaks and valleys together, with index for peaks
pv = sort([pks; vls*1i]);  isp = real(pv) > 0; 
%Remove peak/valley within one time point of both nearest valleys/peaks
%   Too undersampled to be reliable, if not noise
rmi = [false; abs( real(pv(2:end)) - imag(pv(1:end-1)) ) == 1];
pv(rmi(1:end-1) & rmi(2:end)) = [];

%   Retain only peaks following kept valley, above higher cutoff
isgp = isp;     isgp(isp) = ~isp([isp(2:end); false]);
%   Remove invalid peaks (to allow for valley assessment)
rmi = isp & ~isgp;
%   Valid valleys must be immediately following a valid peak
isgv = [~isp;false]; isgv([~rmi;true]) = [false;isgp(~rmi)]; isgv(end) = [];
%Assign valid peaks and valleys, and their preceding features
pks = [real(pv(isgp)), real(pv([isgv(2:end);false]))];
vls = [imag(pv([isgp(2:end);false])), imag(pv(isgv))];


% %Diagnostic plotting (retained for debugging / future development)
% figure; hold on;   plot(d,'b-'); 
% plot(pks(:,1), d(pks(:,1)), 'r^');  plot(vls(:,1), d(vls(:,1)), 'ks'); 
% plot([vly_thresh, min_rise], 'g--');  %plot(fd, 'k--');   
% plot(pks(:,2), d(pks(:,2)), 'kd');  plot(vls(:,2), d(vls(:,2)), 'ro');
end


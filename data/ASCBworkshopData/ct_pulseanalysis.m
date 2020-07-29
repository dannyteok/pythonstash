%CT_PULSEANALYSIS
%   Analysis routine to identify peaks and extract characteristics of
%   pulsatile behavior in cell track data.
%
%Usage:  
%   Z = ct_pulseanalysis(D, 'PARAM1', VALUE1, 'PARAM2', VALUE2, ...) 
%       returns Z, a structure containing the positions and parameters
%       associated with peaks found in data D.  Parameter reported for each
%       peak include:  'pkpos', position the highest value; 'mpos',mean
%       position; 'rise' and 'fall', rise and fall times; 'dur', duration;
%       'peak' and 'mean', highest value and mean value; 'amp_peak' and
%       'amp_mean', amplitude (over nearby baseline) of the peak and the
%       mean peak. 
%
%Inputs:
%   D - Data, as a 2-D matrix (nCells x nTime) or a cell array of data
%       vectors. 
%
%Parameters:
%   TSAMP - Sampling period (time/sample), used to report rise and fall
%       times if absolute units are desired.
%   TRANGE - nCells x 2 matrix of time ranges to evaluate, [Start, End] for
%       each cell track.
%   MAXW - The maximum number of time points near a peak to consider for
%       finding rise and fall times.
%   Additionally, this function uses ct_getpeaks to find peak locations.
%       Any parameters relevant to ct_getpeaks may be provided in the same
%       format.

function [z] = ct_pulseanalysis(d, varargin)
%Operation parameter defaults
p.tsamp = 1;      %Default timing is unity.
p.trange = [];    %Default time range is empty
p.narm = [];      %Default locality is blank
p.min_vy = 0;   p.min_rise = 0;   %Defaults for peak finding
p.maxw = 10;      %Default maximum window size for near peak regions

%Input option pair parsing:
nin = length(varargin);     %Check for even number of add'l inputs
if rem(nin,2) ~= 0; warning(['Additional inputs must be provided as ',...
        'option, value pairs']);  end
%Splits pairs to a structure
for s = 1:2:nin;   p.(lower(varargin{s})) = varargin{s+1};   end
%Assemble name/value sequence for passing parameters forward
ppass = [fieldnames(p),struct2cell(p)]';

%Input expected to be cell array of traces, pack matrix appropriately
if isnumeric(d); d = num2cell(d,2); end;  nct = numel(d);

%Check track timing, and set narm parameter as needed
if isempty(p.trange); p.trange = [ones(nct,1), cellfun('length',d(:))]; end

%% Process cell trace for peaks
%Pre-allocate common items
xfp = {'last','first'}; %Set up to loop for pre- and post- peak regions
z = struct('tracktimes', [], 'pkpos', cell(nct,1), 'mpos',[], 'rise',[], ...
    'fall',[], 'dur',[], 'peak',[], 'mean',[], 'amp_peak',[], 'amp_mean',[]);
for q = 1:nct  %FOR each cell trace
    dt = d{q}(:);
    
    %Identify pulses (peak points)
    [pks, vls] = ct_getpeaks(dt, p.narm, ppass{:});
    np = min(size(pks,1), numel(pks));  %Ensures empty matrix is skipped
    
    %Pre-calculate derivatives for region identification
    dd = [0;diff(dt)];   ad = abs(dd);  mad = nanmedian(ad);
    
    %Prepare outputs, and run operation per pulse
    hv = nan(np,1); lv = zeros(np,2);
    z(q) = struct('tracktimes', p.trange(q,:), 'pkpos', hv, 'mpos', ...
        hv, 'rise',hv, 'fall',hv, 'dur',hv, 'peak',hv, 'mean', ...
        hv, 'amp_peak',hv, 'amp_mean',hv);
    for s = 1:np  %FOR each pulse
        %High value is mean over peak area (excluding min 2 values)
        if pks(s,2) - pks(s,1) < 1; hv(s) = dt(pks(s,1)); %If 1 pnt, use it
        else    hp = sort(dt(pks(s,1)-1 : pks(s,2)+1));  
                hv(s) = median( hp(3:end) );
        end
        %Low values are means over regions preceding/following peak
        %   Select windows before peaks and after valleys
        if s == 1; v1 = 1;  else v1 = vls(s-1,2) - 1; end
        if s == np; v2 = numel(dt);  else v2 = vls(s+1,1) + 1; end
        pw{1} = max(v1, pks(s,1) - p.maxw) : pks(s,1);  
        pw{2} = pks(s,2) : min(v2, pks(s,2) + p.maxw);
        if any(cellfun('isempty',pw)); continue; end %Skip if failed region
        %Identify 'low points' within the pre/post windows
        for sf = 1:2;   %1 is for peaks (pre), 2 is for valleys (post)
            w_mean = ( max(dt(pw{sf})) + min(dt(pw{sf})) )/2;
            lp = ad(pw{sf}) < mad & dt(pw{sf}) < w_mean; %Want flattening
            if ~any(lp); w_min = [diff(sign(dd(pw{sf}))) > 0; false]; 
                lp = w_min & dt(pw{sf}) < w_mean; %Try minima instead
            end
            if ~any(lp); lp = find(w_min, 1, xfp{sf}); end %Get any minimum
            lv(s,sf) = median( dt(pw{sf}(lp)) );
        end
        
        %Get Rise bounding time points
        ths = (hv(s)-lv(s,1))*[0.1, 0.9] + lv(s,1); %Define thresholds
        r_st = pw{1}(find(dt(pw{1}) < ths(1), 1, 'last'));  %Start
        pw{1}(pw{1} < [r_st,-Inf(isempty(r_st))]) = [];  %Ensure End after Start
        r_nd = pw{1}(find(dt(pw{1}) > ths(2), 1, 'first'));      %End
        if isempty(r_nd)  %If end not found, check left half of peak
            pw{1} = [pw{1}, pks(s,1)+1 : floor(mean(pks(s,:)))];
            r_nd = pw{1}(find(dt(pw{1}) > ths(2), 1, 'first')); 
        end
        %Get Fall bounding time points
        ths = (hv(s)-lv(s,2))*[0.1, 0.9] + lv(s,2); %Define thresholds
        f_nd = pw{2}(find(dt(pw{2}) < ths(1), 1, 'first'));      %End
        pw{2}(pw{2} > [f_nd,Inf(isempty(f_nd))]) = [];  %Ensure Start after End
        f_st = pw{2}(find(dt(pw{2}) > ths(2), 1, 'last'));%Start
        if isempty(f_st)  %If start not found, check right half of peak
            pw{2} = [ceil(mean(pks(s,:))) : pks(s,2)-1, pw{2}];
            f_st = pw{2}(find(dt(pw{2}) > ths(2), 1, 'last'));
        end
        
        
        %Check for failed recognition
        %   Skip to next pulse if failure detected (leaves NaNs)
        if length([r_st,r_nd,f_st,f_nd]) ~= 4 || (r_nd > f_st) || ...
            (r_st > r_nd) || (f_st > f_nd); continue; end
        
        %Peak position
        z(q).pkpos(s) = pks(s,1) + p.trange(q,1) - 1;
        z(q).mpos(s) = (r_nd+f_st)/2 + p.trange(q,1) - 1;
%         z(q).mpos(s) = mean(pks(s,:),2) + p.trange(q,1) - 1;
        
        %Rise Time and Fall Time
        z(q).rise(s) = (r_nd - r_st)*p.tsamp;
        z(q).fall(s) = (f_nd - f_st)*p.tsamp;
        %Duration
        z(q).dur(s) = (f_st - r_nd + 1)*p.tsamp;
        %Peak Signal and Amplitude
        z(q).peak(s) = max(dt(r_nd:f_st));
        z(q).amp_peak(s) = z(q).peak(s) - lv(s,1);
        %Mean Signal and Amplitude
        z(q).mean(s) = nanmean(dt(r_nd:f_st));
        z(q).amp_mean(s) = z(q).mean(s) - lv(s,1);
    end
    %Remove NaN-valued indices
    z(q) = structfun(@(x)x(~isnan(x)), z(q), 'UniformOutput', false);
end

%PROCEDURE DESCRIPTION

%Get points before the peak where the (preceding) derivative is below the
%   median over all derivatives (~looks like baseline).  Search backward if
%   not found, stopping at the previous valley or beginning of file.  Use
%   min value nearest peak if no suitable region found.

%Characterize rising phases
%   Rise time = time from last point under 10% to first over 90%
%   Define 0% as mean of pre-rise segment, 100% as mean of peak segment
%   Keep segments bounded near to rise.  Find segments by low derivative
%   magnitudes.

%Characterize falling phases
%   As with rises

%Characterize pulse features (duration, peak amplitude, mean amp)
%   Duration:  Time from end of rise to beginning of fall
%   Peak amp:  Value at peak - mean value pre-rise
%       Also:  Value at peak := 'Peak signal'
%   Mean amp:  Mean over Duration - mean pre-rise
%       Also:  Mean over Duration := 'Mean peak signal'

%Infer distributions and statistics (Not yet implemented)
%   On a per track and/or bulk basis.
%   Above analytics are per pulse
%   Pack as a structure (1 element per track), each element.field with 1
%       value per pulse.


end

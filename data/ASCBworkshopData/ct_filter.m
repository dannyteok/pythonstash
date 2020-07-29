%CT_FILTER
%   Filtering for cell track data.  Employs infinite impulse response (IIR)
%   filters to remove desired frequency content from the data.  Uses
%   Butterworth filter design for optimally flat passband gain.
%   
%Usage:  
%   DOUT = ct_filter(D, TYPE, PCUT, MISSING) 
%
%Inputs:
%   D - Data, as a 2-D matrix (nCells x nTime) or a cell array of data
%       vectors. 
%
%Parameters:
%   TYPE - String indicationg the type of filter to use.
%       'noise' or 'low': Lowpass filter for removing high frequency noise.
%       'drift' or 'high': Highpass filter for removing drift.
%       'base': Remove change in local baseline value.  In this
%           option, PCUT is the number of time points to consider local.
%   PCUT - Cutoff period, the maximum (or minimum) period of pulse/
%       oscillation that should be eliminated, for a noise (or drift)
%       filter. Minimum value allowed is 2 (as 2 maps to the Nyquist
%       frequency).
%   MISSING - Value given to missing data in D.  Default is NaN.

function d = ct_filter(d, type, pcut, mv)

nord = 5;   %Order of Butterworth filter to use

%Check input data type, and get sizes
if iscell(d) %IF cell, assemble as matrix, tailed with NaNs as needed
    nC = numel(d);  nTcell = cellfun('length', d);  nT = max(nTcell);
    d = cellfun(@(x)[x(:)', nan(1,nT-length(x))], d, ...
        'UniformOutput', false);    %Tail each track to the max length
    d = cat(1, d{:});   %Concatenate data tracks to a single matrix
elseif isnumeric(d);  [nC, nT] = size(d);
end

%Design butterworth filter
switch lower(type)
    case {'noise','low','lowpass'}; ftype = 'low';
    case {'drift','high','highpass','hi'}; ftype = 'high';
    %IF correcting baseline, return early (does not run butterworth filter)
    case 'base'; str = strel('line', pcut, 0); mnv = nan(size(d));
        d(d == mv) = nan;  %Convert missing values to NaN to avoid bias
        for s = 1:nC;   nnd = ~isnan(d(s,:));     %Avoid NaNs
            mnv(s,nnd) = imerode(d(s,nnd), str);  %Erosion gives local min
            %Filter to smooth local min
            fltb = ones( 1, min(floor(nnz(nnd)/3)-1, pcut) )/pcut;
            mnv(s,nnd) = filtfilt( fltb, 1, mnv(s,nnd));
            %Remove initial value to avoid subtracting mean from track
            mnv(s,nnd) = mnv(s,nnd) - ...
                mean(mnv( s, find(nnd,max(1,round(nC/20)),'first') ));
        end
        d = d - mnv;  return
end
wn = 2./pcut;     %Convert period cutoff to normalized frequency
[B,A] = butter(nord, wn, ftype);    %Butterworth design

%Identify missing data (typically at beginning/end of track)
%   Expect NaNs, and include any indicated value if provided (typ. 0)
imiss = isnan(d);  if exist('mv','var'); imiss = imiss | d == mv; end

%IF a drift filter, get the initial mean value to add back after filter
imv = zeros(nC,1);
if strcmpi(ftype,'high');  
    for s = 1:nC; dtemp = d(s,~imiss(s,:));
        imv(s) = mean(dtemp(1:min( length(dtemp), max(1,floor(nT./10)) )));
    end
end

%Filter data
for s = 1:nC
    d(s,~imiss(s,:)) = filtfilt( B, A, d(s,~imiss(s,:)) ) + imv(s);
end

%Return as incoming data type
if exist('nTcell', 'var'); dc = cell(nC,1);
    for s = 1:nC; dc{s} = d(s,1:nTcell(s)); end;  d = dc;
end


end
%CT_OUTLIER
%   Outlier removal procedure for cell track data.
%   
%Usage:  
%   DOUT = ct_outlier(D, THRESH, DTHRESH, MANUAL, MISSING) 
%
%Inputs:
%   D - data, as a 2-D matrix (nCells x nTime) or a cell array of data
%       vectors. 
%
%Parameters:
%   THRESH - Lower and upper threshold values. Values of D outside of this
%       range are considered outliers.
%   DTHRESH - Threshold for the magnitude of the derivative (i.e. change
%       from one point to the next).  Values exceeding this level are
%       considered outliers.
%   MANUAL - Time points considered outliers by manual examination.
%   MISSING - Value given to missing data in D.  Default is NaN.

function d = ct_outlier(d, varargin)
%Fill inputs, with empty for any missing
if nargin < 5; [varargin{end+1:4}] = deal([]);  end
[th, dth, man, mv] = deal(varargin{:});

%Check input data type, and get sizes
if iscell(d) %IF cell, assemble as matrix, tailed with NaNs as needed
    nC = numel(d);  nTcell = cellfun('length', d);  nT = max(nTcell);
    d = cellfun(@(x)[x(:)', nan(1,nT-length(x))], d, ...
        'UniformOutput', false);    %Tail each track to the max length
    d = cat(1, d{:});   %Concatenate data tracks to a single matrix
elseif isnumeric(d);  [nC, nT] = size(d);
end

%Ensure NaNs as missing values
if ~isempty(mv);  imiss = d == mv;  d(imiss) = NaN; end


%% Identify outliers
%By absolute thresholds
if numel(th) == 2;  ols = d<th(1) | d>th(2);  else ols = false(nC,nT);  end

%By derivative thresholds
if ~isempty(dth);  dd = diff(d,1,2);  ols = ols | [false(nC,1), abs(dd) > dth];  end

%From manual input, applies to all cells
ols(:,man) = true;


%% Remove outliers
%Set any values missing at start or end to NaN
iends = [true(nC,1), false(nC,nT-2), true(nC,1)];
outend = ols & iends;  d(outend) = NaN;   ols(iends) = false;

%Interpolate missing values (not at start or end)
xax = 1:nT;
for s = 1:nC
    d(s,ols(s,:)) = interp1(xax(~ols(s,:)), d(s,~ols(s,:)), xax(ols(s,:)));
end

%Restore missing value style
if ~isempty(mv); d(imiss | outend) = mv; end

%Return as incoming data type
if exist('nTcell', 'var'); dc = cell(nC,1);
    for s = 1:nC; dc{s} = d(s,1:nTcell(s)); end;  d = dc;
end

    
end
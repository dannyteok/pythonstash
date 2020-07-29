%CT_TRACKVIS
%   A potting routine for visualizing cell track data.
%
%Usage:  
%   AH = ct_trackvis(TYPE, D) prepares a plot of data D, according to the
%       style defined by TYPE (see 'Inputs' section below), and returns a
%       handle to the plot axes.
%   AH = ct_trackvis(..., D, 'PARAM1', VALUE1, 'PARAM2', VALUE2, ...) uses
%       the specified values for plotting parameters (see 'Parameters'
%       section below).
%   AH = ct_trackvis(AH, ...) plots on the axes specified the handle AH
%
%Inputs:
%   AH - a handle to existing axes; new axes will be generate if not
%       provided.
%   TYPE - a string specifying the type of plot desired.
%       'heatmap' plots the full data set as a heatmap with time on the
%           x-axis and cells represented as rows.
%       'ensemble' plots all tracks as lines, overlayed on a single plot,
%           with the color intensity of the line darker for longer tracks.
%   	'mean' plots the mean value over time and 25th/75th quantiles,
%           overlayed on existing axes if provided (as the 'ah' input).
%   	'histogram' plots a color-scaled '2D' histogram of the data values
%           at each time point; histograms are presented as columns with
%           time on the x-axis.
%       'triple' plots three axes in one figure: an ensemble of the longest
%           few tracks, an ensemble of all tracks overlayed with a mean,
%           and a heatmap of the dataset.
%   D - data to plot, as a 2-D matrix (nCells x nTime) or a cell array of
%       data vectors. 
%
%Parameters:
%   CMAP - a colormap (n-by-3 array of RGB values) or string indicating the
%       desired colormap.  Value strings are: 'red', 'orange', 'yellow',
%       'chartreuse', 'green', 'springgreen', 'cyan', 'azure', 'blue',
%       'violet', 'magenta', 'rose', 'gray', and any valid arguments the
%       colormap function.  The first letter of listed maps may also be
%       used (ch for chartreuse, sg for springgreen, no alternate for gray).
%   LW - a double, the linewidth to plot individual tracks.  Quantiles and
%       means will be plottes as lw+1 and lw+2.
%   NOLABEL - a logical indicating if axes labels should be suppressed.
%   FILETYPE - a string indicating the type of output file to save: 'eps',
%       'tiff', 'png', or 'jpeg'; no file is saved if empty or not provided.
%   MISSING - a string indicating how missing data points are treated.
%       'nan' - (default) missing values are expected to be NaNs.
%       'zero' - missing values are expected to equal 0.
%       'nan2zero' - NaNs should be converted to the value 0.


%Sample data and run
% a = load('celltracer_shifttest_xy01.mat'); %Or any file with valcube
% d = a.valcube(:,:,3);
% ah = ct_trackvis('triple', [], d, 'orange', 1, false, '');


%

%FIXME Proper x/y axis labels and titles? (add tsamp?, y unit?)
%FIXME Help header

function ah = ct_trackvis(varargin)
%Parse Inputs ------------------------------------------------------------
%Define default parameters
p.cmap = 'gray';  p.lw = 1;             p.nolabel = false;  
p.filetype = '';  p.missing = 'nan';

nin = numel(varargin);  %Check number of inputs provided
%Check for provided axes, and adjust to empty if not present
if numel(varargin{1}) > 1 || ... %IF not scalar OR neither numeric nor handle
        ~( isnumeric(varargin{1}) || ishandle(varargin{1}) );  
    varargin = [{[]},varargin];  nin = nin+1;  %Adjust if no axis handle
end
if nin < 3; error(['TYPE and data D must be provided.  ',...
        'Type "help ct_trackvis".']); end
%Apply axes, data inputs to named variables
[ah, type, d] = deal(varargin{1:3});

if nin > 3  %IF input options provided
    %   Check for even number of add'l inputs
    if rem(nin-3,2) ~= 0; warning(['Additional inputs must be ',...
            'provided as option, value pairs']);  end
    %   Parse input option pairs to a structure
    for s = 4:2:nin;   p.(lower(varargin{s})) = varargin{s+1};   end
end
% ------------------------------------------------------------------------

%Check and set colormap as needed
if ischar(p.cmap); p.cmap = ct_colormaps(p.cmap); end  %IF named color, get map
if isempty(p.cmap); p.cmap = colormap; close; end 
cmap_x = linspace(0, 1, size(p.cmap,1));	%Define colormap x-axis

%Orient to indicated axes or set new
if isempty(ah); figure; ah = axes;   else axes(ah);   end;
%Check input data type, and get sizes
if iscell(d) %IF cell, assemble as matrix, tailed with NaNs as needed
    nCells = numel(d);  nTime = max(cellfun('length', d));
    d = cellfun(@(x)[x(:)', nan(1,nTime-length(x))], d, ...
        'UniformOutput', false);    %Tail each track to the max length
    d = cat(1, d{:});   %Concatenate data tracks to a single matrix
elseif isnumeric(d);  [nCells, nTime] = size(d);
end

%Adjust missing data values (e.g. zeros, NaNs) as needed
switch lower(p.missing)
    case {0,'0','zero'};    d(d == 0) = NaN;
    case 'nan';             %Do nothing = treat NaNs as missing data
    case 'nan2zero';         d(isnan(d)) = 0;
end


%% Generate figure, per type requested
switch lower(type)
    case 'heatmap' % --Prints a heatmap of all tracks, stacked--
        %Plot heatmap of data matrix
        imagesc(d);  set(ah, 'YDir', 'reverse'); axis([0,nTime,0,nCells]);
        
        %Add colorbar below the heatmap, outside the axis
        ch = colorbar('SouthOutside'); %#ok<NASGU>
        
        %Implement colormap
        colormap(ah, p.cmap);
        
        %Manage axis labeling
        %   Print axis labels
        if ~p.nolabel;  ylabel(ah, 'Cell Track');  xlabel(ah, 'Time'); end
        
    case 'ensemble' % --Plots all tracks over time, overlayed--
        %   Normalize color intensities to use for ensemble plot
        clr = linspace(0.5,0.8,nCells)';  ndark = min(nCells, 50);
        clr(1:ndark) = clr(1:ndark) + linspace(-0.1,0,ndark)';
        %   Map color intensities to current colormap  
        cvals = interp1(cmap_x, p.cmap, clr);
        
        %Plot ensemble of tracks
        %   First, set up the axes and color order
        set(ah, 'ColorOrder', cvals(end:-1:1,:));  hold(ah,'on');
        %   Plot tracks
        plot(ah, d(end:-1:1,:)', 'LineWidth', p.lw);
        
        %Adjust axis limits and labeling
        ax = axis(ah);  axis(ah, [0, nTime, ax(3:4)]);
        if ~p.nolabel;  ylabel(ah, 'Intensity');  xlabel(ah, 'Time'); end
        
    case 'mean' % --Plots the mean and 25th, 75th quantiles over time--
        %Calculate, then plot mean and quantile values
        mtrace = nanmean(d, 1);     qtiles = prctile(d, [25,75]);
        hold(ah,'on');   %Overlay to current plot on axes
        %Map dark values from colormap
        mqclr = interp1(cmap_x, p.cmap, 0.3);  mlow = mqclr < max(mqclr);
        mqclr = mqclr.*(mlow*0.5 + ~mlow*0.75);  %Darken and purify color
        plot(ah, qtiles', 'Color', mqclr, 'LineWidth', p.lw+1); %Quantiles
        mqclr = mqclr.*0.75; %Darken futher for the Mean plot
        plot(ah, mtrace,  'Color', mqclr, 'LineWidth', p.lw+2); %Mean
        
        %Adjust axis limits and labeling
        ax = axis(ah);  axis(ah, [0, nTime, ax(3:4)]);
        if ~p.nolabel;  ylabel(ah, 'Intensity');  xlabel(ah, 'Time');  end
        
    case 'histogram' % --Generates a time-lapse histogram (color-scaled)--
        %Estimate optimal number of bins (Scott 1992)
        nbins = ceil( range(d(:)) ./ ...
            ( 3.5.*nanmedian(nanstd(d,0,1)) ./ (nCells.^(1/3)) ) );
        %Build histograms and plot (as color-scale image)
        [hn, hx] = hist(d, nbins); 	imagesc(hn(end:-1:1,:));
        %Implement colormap
        colormap(ah, p.cmap);
        %Adjust axis limits and labeling
        axis(ah, [1, nTime, 0.5, nbins+0.5]);
        %Set intesity bin values
        mny = min(hx); mxy = max(hx); rny = mxy - mny; %Get extrema, range
        ord = 10.^floor(log10(rny)); %Tick spacing to be on order of range
        if rny/ord < 6; ord = ord/2; end %Halve spacing if too sparse
        %   Define y tick labels to use
        ytl = ceil(mny./ord)*ord : ord : mxy;
        if ytl(1) - ord <= 0; ytl = [0,ytl]; end  %Check if 0 is appropriate
        %   Get tick positions for labels, and place labeling
        yt = nbins - cellfun(@(x)interp1([0,hx'],[0.5,1:nbins],x), ...
            num2cell(ytl)) + 1;
        set(ah, 'YTick', yt(end:-1:1)); set(ah, 'YTickLabel', ytl(end:-1:1));
        %Label axes
        if ~p.nolabel;  ylabel(ah, 'Intensity bin');  xlabel(ah, 'Time'); end
        
    case 'triple' % --Recursively calls trackvis to generate 3-part plot--
        %Sample tracks (ensemble with few tracks)
        ah(1) = subplot(3,1,1);
        ct_trackvis(ah(1), 'ensemble', d(1:3,:), varargin{4:end}, 'nolabel', true);
        %Ensemble with mean overlay
        ah(2) = subplot(3,1,2);
        ct_trackvis(ah(2), 'ensemble', d, varargin{4:end}, 'nolabel', true);
        ct_trackvis(ah(2), 'mean', d, varargin{4:end}, 'nolabel', true);
        %Heatmap
        ah(3) = subplot(3,1,3);
        ct_trackvis(ah(3), 'heatmap', d, varargin{4:end}, 'nolabel', true);
        
        %Adjust axes, labeling, etc.
        axis(ah(1:2),'tight');
        ylabel(ah(1), 'Intensity');  %title(ah(1), 'Title');
        ylabel(ah(2), 'Intensity');
        xlabel(ah(3), 'Time');  ylabel(ah(3), 'Cell Track');
        %Clear x-axis Tick Labels from upper plots, for space
        set(ah(1:2), 'XTickLabel', []);
        
        %Triple-plot generate issues with some renderers in MATLAB figures
        v = version('-release');
        if str2double(v(1:4)) < 2015;  set(gcf, 'Renderer', 'zbuffer');
            %Adjust positions of lower plots for more efficient space usage
            set(ah(2), 'Position', get(ah(2),'Position') + [0,0.04,0,0]);
            set(ah(3), 'Position', get(ah(3),'Position') + [0,-0.02,0,0.1]);
        else    %set(gcf, 'Renderer', 'OpenGL'); %NOT YET TESTED ON 2015 
            %Adjust positions of lower plots for more efficient space usage
            set(ah(2), 'Position', get(ah(2),'Position') + [0,0.04,0,0]);
            set(ah(3), 'Position', get(ah(3),'Position') + [0,-0.12,0,0.16]);
        end
end


%IF requested, Print the figure to a file
if ~isempty(p.filetype)
    %Determine filename
    filename = [];
    switch lower(p.filetype)
        case 'eps';     print('-depsc', filename);
        case 'tiff';    print('-dtiff', filename);
        case 'png';     print('-dpng',  filename);
        case 'jpeg';    print('-djpeg', filename);
    end
end

end


%Define some convenient colormaps here.
function cmap = ct_colormaps(clr)
n2 = 32;    c1 = 0.3;  c2 = 0.2;  c2b = 0;
imain = [0; linspace(c1, 1, n2)'; ones(n2, 1)];
isec =  [0; linspace(c2, 1-c2b, n2*2)'];
ilow =  [0; zeros(32, 1); linspace(0, 1-2*c2b, n2)'];

switch upper(clr)
    case {'RED','R'};               cmap = [imain, ilow, ilow];
    case {'ORANGE','O'};            cmap = [imain, isec, ilow];
    case {'YELLOW','Y'};            cmap = [imain, imain, ilow];
    case {'CHARTREUSE','CH','YG'};  cmap = [isec, imain, ilow];
    case {'GREEN','G'};             cmap = [ilow, imain, ilow];
    case {'SPRINGGREEN','SG'};      cmap = [ilow, imain, isec];
    case {'CYAN','C'};              cmap = [ilow, imain, imain];
    case {'AZURE','A'};             cmap = [ilow, isec, imain];
    case {'BLUE','B'};              cmap = [ilow, ilow, imain];
    case {'VIOLET','V'};            cmap = [isec, ilow, imain];
    case {'MAGENTA','M'};           cmap = [imain, ilow, imain];
    case {'ROSE','PINK','P'};       cmap = [imain, ilow, isec];
    case {'GRAY'};                  cmap = [isec, isec, isec];
    otherwise;                      
        try     cmap = colormap(clr);
        catch;   warning('CT_COLORMAP:badMapName', ['Invalid colormap ',...
                'or name provided.  Using default.  Type HELP CT_TRACKVIS ',...
                'or HELP COLORMAP for proper names.']);  cmap = [];
        end
end

end

%References:
%Scott, David W. (1992). Multivariate Density Estimation: Theory, Practice, 
%   and Visualization. New York: John Wiley.

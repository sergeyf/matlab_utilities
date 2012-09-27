function K = histIntersect(X1,X2,bins)

% calculates % the histogram intersection kernel
% between vectors 'X1' and 'X2' (can be different lengths)
% 'bin' specifies the number of bins to use
% in the histogram calculation

% see http://perso.lcpc.fr/tarel.jean-philippe/publis/jpt-icip05.pdf

% sergey.feldman@gmail.com
% last edited: sept 27, 2012




% histogram function only works with doubles, so converting first

if isinteger(X1)
    X1 = double(X1);
end

if isinteger(X2)
    X2 = double(X2);
end

% if X1 and X2 are both matrices, then assume they are images and
% vectorize them
if ~isvector(X1);
    X1 = X1(:);
end
if ~isvector(X2);
    X2 = X2(:);
end

% get some info from X1 and X2
N1 = length(X1);
N2 = length(X2);
min_val = min(min(X1),min(X2)); % lower bound of the histogram
max_val = max(max(X1),max(X2)); % upper bound of the histogram

% if number of bins isn't specified, assume a bin per integer
if nargin < 3
    bins = max_val - min_val + 1;
end

span = min_val:(max_val-min_val)/(bins-1):max_val; % span of the histogram

hist1 = hist(X1,span)/N1; % normalized histograms
hist2 = hist(X2,span)/N2;

K = sum(min(hist1,hist2)); % histogram intersection kernel
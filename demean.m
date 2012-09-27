function [Xnorm,mus] = demean(X,mus)

% demean feature data

% 'X' is input feature data (each column is a feature dimension)
% input 'mus' are mean, and are optional.
% if given, will be used to demean 'X'.  otherwise 'X's own means will
% be used

% 'Xnorm' is the demeaned version of 'X'
% output 'mus' are the means used to demean 'X'

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

if nargin == 1 || isempty(mus)% use own stats
    mus = mean(X); 
    Xnorm = bsxfun(@minus,X,mus); % demean
else % use provided stats
    Xnorm = bsxfun(@minus,X,mus);
end

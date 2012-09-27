function [Xnorm,mus,stds] = normalize(X,mus,stds)

% standard normalize (z-score normalize) feature data

% 'X' is input feature data (each column is a feature dimension)
% input 'mus' are means, and 'stds' are standard deviations.  both are optional.
% if given, will be used to normalize 'X'.  otherwise 'X's own statistics will
% be used

% 'Xnorm' is the normalized 'X'
% output mus and stds are the means and standard deviations used 
% to normalize 'X'

% see http://en.wikipedia.org/wiki/Normalization_(statistics)

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

if nargin == 1 || isempty(mus)% use own stats
    mus = mean(X); 
    stds = std(X);
    stds(stds == 0) = -1; % to avoid numerical errors
    Xnorm = bsxfun(@minus,X,mus); % demean
    Xnorm = bsxfun(@rdivide,Xnorm,stds); % makes variance 1
    % removing singular dimensions
    Xnorm(:,stds == -1) = [];
else % use provided stats
    Xnorm = bsxfun(@minus,X,mus);
    Xnorm = bsxfun(@rdivide,Xnorm,stds);
    Xnorm(:,stds == -1) = []; % removing singular dimensions
end


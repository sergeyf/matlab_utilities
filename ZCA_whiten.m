function [X_zca,R,mu] = ZCA_whiten(X,epsilon)

% ZCA whitening function

% 'X' is input data
% 'epsilon' is the amount of regularization

% 'X_zca' is the whitened version of 'X'
% 'R' is the whitening matrix
% 'mu' is the mean of 'X'

% see http://ufldl.stanford.edu/wiki/index.php/Whitening 

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

if nargin == 1
    epsilon = 0.0001;
end

[X,mu] = demean(X);

[V,D] = svd(full(cov(X)));

R = V * diag(1./sqrt(diag(D) + epsilon)) * V';

X_zca =  X*R;


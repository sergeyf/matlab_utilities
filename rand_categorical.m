function x = rand_categorical(n,p)

% draw 'n' random integers from range 1..length(p)
% distributed according to pmf 'p'
% elements of p do not need to sum to 1, but should be non-negative

% see http://en.wikipedia.org/wiki/Categorical_distribution

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

if nargin < 2
    p = ones(10,1)/10;
end

[~,x] = histc(rand(1,n),[0;cumsum(p(:))/sum(p)]);
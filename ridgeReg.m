function [outputs,beta,Ymu] = ridgeReg(Xtest,Xtrain,Ytrain,params)

% regularized linear regression classifier/regressor
% using 1 vs all mentality

% 'Xtrain' and 'Xtest' are the training and test sets, respectively
% 'Ytrain' is the vector of class labels or outputs

% needs non-negative regularization parameter 'params.lambda'
% params.classRegFlag determines whether to do classification or regression
% assumed to be 1 (i.e. classification) if not specified

% 'outputs' are the class unnormalized posteriors (one per class)
% or the output estimates in case of regression
% 'beta' are the regression weights
% 'Ymu' is the mean of the outputs that needs to be added back in

% see http://ee.washington.edu/research/guptalab/publications/GuptaMortensen.pdf

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

% deal with parameters
if nargin < 4; 
    params.lambda = 1; 
    params.classRegFlag = 1;
end % if lambda not specified, assume 1
lambda = params.lambda;
classRegFlag = params.classRegFlag; % if 1 classify, else regress

% getting info
G = unique(Ytrain); 
[~,d] = size(Xtrain);

% normalizing
[Xtrain,mus,stds] = normalize(Xtrain);
Xtest = normalize(Xtest,mus,stds);

% demeaning y
if classRegFlag == 1
    Y1vsAll = zeros(length(Ytrain),length(G)); % allocating 1vsAll mat
    for g = 1:length(G)
        temp = zeros(size(Ytrain));
        temp(Ytrain == G(g)) = 1;
        temp(Ytrain ~= G(g)) = -1;
        Y1vsAll(:,g) = temp; 
    end
    [Y1vsAll,Ymu] = demean(Y1vsAll); % getting rid of the Y mean (will add back in later)
else
    [Ytrain,Ymu] = demean(Ytrain); % getting rid of the Y mean (will add back in later)
end

% test phase
if classRegFlag == 1
    beta = (Xtrain'*Xtrain+ lambda*eye(d))\(Xtrain'*Y1vsAll); % getting beta
else
    beta = (Xtrain'*Xtrain+ lambda*eye(d))\(Xtrain'*Ytrain); % getting beta
end

outputs = Xtest*beta; % class weights
outputs = bsxfun(@plus,outputs,Ymu); % adding the mean back in
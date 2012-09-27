function log_posterior = qda(Xtest,Xtrain,Ytrain,params,Pi)

% quadratic discriminant analysis (QDA) classifier

% 'Xtrain' and 'Xtest' are the training and test sets, respectively
% 'Ytrain' is the vector of class labels or outputs

% 'params.lambda' is how much identity matrix
% to add to the maximum likelihood covariance matrix
% 'params.diagCovFlag' determines whether to use a diagonalized covariance
% matrix

% 'log_posterior' is the matrix of class log posteriors for each test point

% see http://en.wikipedia.org/wiki/Quadratic_classifier

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

% deal with parameters
if nargin < 4; % if no params given 
    params.lambda = 0.1; % 
    params.diagCovFlag = 0; % don't use diagonalized covariance
else % if params given, have to make sure they are all specified
    if ~isfield(params,'lambda'); params.lambda = 0.1; end
    if ~isfield(params,'diagCovFlag'); params.diagCovFlag = 0; end
end
lambda = params.lambda;
diagCovFlag = params.diagCovFlag;

% training phase
G = unique(Ytrain);
[N,d] = size(Xtrain);
mu = cell(length(G),1); % means
S = cell(length(G),1); % cov matrices
factors = cell(length(G),2);
for g = 1:length(G)% training phase
    ind = (Ytrain == G(g)); % finding samples in this class
    temp = Xtrain(ind,:); % training samples of gth class
    mu{g} = mean(temp); % mean
    S{g} = cov(temp);
    S{g} = S{g} + lambda*eye(d); % regularized covariance
    if diagCovFlag == 1 % CAN BE DRASTICALLY SPED-UP
        S{g} = S{g}.*eye(d); % diagonlized covariance
    end
    factors{g,1} = mu{g}/S{g}; % same as mu{g}*inv(S{g})
    factors{g,2} = factors{g,1}*mu{g}';
    factors{g,1} = -2*factors{g,1};
end

% if no prior is given, calculate it
if nargin < 5
    Pi = hist(Ytrain,G)'/N;
end

% testing phase
N = size(Xtest,1);
log_posterior = zeros(N,length(G));


for g = 1:length(G)
    log_posterior(:,g) =  sum(Xtest'.*(S{g}\Xtest'),1) + factors{g,1}*Xtest'+ factors{g,2};
    log_posterior(:,g) = -log_posterior(:,g)/2 + log(Pi(g)) - logdet(S{g},'chol')/2;
end

log_posterior = log_posterior - d*log( 2*pi )/2;
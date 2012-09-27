function [mu_mt,W] = MTA_constant(mu_st,s_st,N,type_estimator,gamma)

% multi-task averaging (MTA)

% inputs: 
% 'mu_st' - single task means
% 's_st' - vector of variances
% 'N' - vector of number of samples in each task
% 'type_estimator' - either 'mean' or 'minimax'
% 'gamma' - regularization factor. positive real scalar 

% outputs:
% 'mu_mt' - mutli-task means
% 'W' - weight matrix

% see https://dl.dropbox.com/u/144839/my_papers/sf-mta_nips_2012.pdf

% sergey.feldman@gmail.com
% last edited: sept 27, 2012


[T,~] = size(mu_st);  % number of tasks

if nargin <  % if not provided, assume 1
    gamma = 1;
end

Sigma_diag = s_st./N;
problem_flag = ~isfinite(Sigma_diag);

if sum(~problem_flag) > 1 
    % setting some defaults
    if ~isempty(type_estimator) % if an estimator has been specified
        if strcmp(type_estimator,'mean')
            sum_sq_dists = 2*T*sum(mu_st.^2) - 2*sum(mu_st)^2;
            c = gamma*2*T*(T-1)/sum_sq_dists;
        elseif strcmp(type_estimator,'minimax');
            max_dist = max(mu_st) - min(mu_st);
            c = gamma*2/max_dist^2;
        end 
    else % if no estimator 'type' specified, then c is just gamma
        c = gamma;
    end

    % numerically equivalent to equation W^{cnst} (but much faster)
    % W = inv(eye(T) + c/T*diag(Sigma_diag)*laplacian(ones(T,T)));
    % mu_mt = W*mu_st;
    g = 1./(1+c.*Sigma_diag);
    
%     W = diag(g)+(1-g)*g'/sum(g);
%     mu_mt = W*mu_st;

    mu_mt = g.*mu_st + (1-g).*(g'*mu_st)/sum(g);
    
    mu_mt(problem_flag,:) = mu_st(problem_flag,:);
    
else % if only one task, just return the input
    
    mu_mt = mu_st;
    W = 1;
    
end
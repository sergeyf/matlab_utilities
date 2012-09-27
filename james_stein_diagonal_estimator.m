function mu_js = james_stein_diagonal_estimator(mu_st,s_st,Xi,N,simple_flag)

% positive-part james-stein estimator
% assuming diagonal covariance
% equation is taken from Bock 72

% inputs: 
% 'mu_st' - single task means
% 's_st' - vector of variances
% 'N' - vector of number of samples in each task
% 'Xi' - what value to regularize to (usually mean(mu_st))
% 'simple_flag' - if 0, use effective dimension as per Bock
% if 1, use T (tends to work better)

% 'mu_js' - are the james-stein means

% see http://projecteuclid.org/DPubS?service=UI&version=1.0&verb=Display&handle=euclid.aos/1176343009

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

[T_orig,d] = size(mu_st);

if nargin < 5 
    simple_flag = 1;
end

% only doing JS when the variance > 0 and N > 0
zero_flag = ( s_st == 0 | N < 1 );

% assuming diagonal covariance.  Q_diag(t,t) = variance of t-th sample mean
Sigma_tilde_diag = s_st./N; % diagonal of the matrix \tilde{\Sigma}

% effctive dimension
if simple_flag == 0
    eff_dim = sum(Sigma_tilde_diag)/max(Sigma_tilde_diag); % from Bock
else
    T = sum(~zero_flag); % number of tasks where the variance is positive
    eff_dim = T; % simple hack (improves performance)
end

% degrees-of-freedom in the residuals
% (see wikipedia page on Bessel's correction)
if Xi == 0
    deg_of_free_res = 2;
else
    deg_of_free_res = 3;
end

% condition in Bock for JS dominance over MLE
if eff_dim > deg_of_free_res

    % only doing JS where the variance is strictly positive and N > 0
    mu_js = zeros(T_orig,d);
    mu_js(zero_flag,:) = mu_st(zero_flag,:); 
    
    % computing Bock's formula (Bock 72)
    mu_st_centered = mu_st(~zero_flag,:) - Xi;
%     mu_st_centered = bsxfun(@minus,mu_st(~zero_flag,:),Xi);
    

    denom = (1./Sigma_tilde_diag(~zero_flag))' * (mu_st_centered).^2;
 
    pos_part = max(0 , 1 - (eff_dim - deg_of_free_res)./denom);

    mu_js(~zero_flag,:) = Xi + pos_part*mu_st_centered;
%     mu_js(~zero_flag,:) = bsxfun(@plus,bsxfun(@times,mu_st_centered,pos_part),Xi);
    
else % else just use the single-task estimate
    
    mu_js = mu_st;

end
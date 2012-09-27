function [L,Lnorm] = laplacian(A,sym_flag,norm_type)

% calculates the graph laplacian matrix, both unnormalized and normalized

% 'A' is non-negative symmetric weight/sim matrix
% if 'sym_flag' is 1 then symmetrize 'A'
% 'norm_type' determines type of normalized graph laplacian (see code)
% 'L' is unnormalized graph laplacian matrix
% 'Lnorm' is normalized graph laplacian matrix

% see http://en.wikipedia.org/wiki/Laplacian_matrix

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

if nargin < 2
    sym_flag = 0; % do not symmetrize
end

if nargin < 3
    norm_type = 1; % standard normalized graph laplacian
end

if sym_flag == 1;
    A = A + A';
end

d = sum(A,2);
D = diag(d);

L = D - A;

if nargout > 1
    if norm_type == 1
        sqrtInvD = diag(1./sqrt(d));
        Lnorm = sqrtInvD*L*sqrtInvD; % what most folks use
    else
        Lnorm = diag(1./d)*L; % when using this inv(I + Lnorm) has rows that sum to 1
    end
end
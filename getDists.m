function D = getDists(X1,X2)
% get squared squared euclidean distances
% between samples (rows) in 'X1' and samples in 'X2'

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

if nargin == 1; X2 = X1; end

N1 = size(X1,1);
N2 = size(X2,1);
D = X1*X2';
D = -2*D;
D = D + repmat(sum(X2.*X2,2)',[N1 1]); 
D = D + repmat(sum(X1.*X1,2),[1 N2]);

%% old method.  slower.  may or may not work better with more samples
% D = zeros(N1,N2);
% squaredNormX2 = zeros(N2,1);
% for i = 1:N2
%     squaredNormX2(i) = X2(i,:)*X2(i,:)';
% end
% 
% % get N1 x N2 squared distance matrix
% for i = 1:N1
%     squaredNormX1 = X1(i,:)*X1(i,:)';
%     D(i,:) = squaredNormX2 + squaredNormX1*ones(N2,1) - 2*X2*X1(i,:)';
% end 
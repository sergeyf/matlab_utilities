function a = str2cat(s)

% input 's' is a cell of strings
% output a is Nx1 vector of integer categories
% example: s = ['a' 'a' 'bark' '4' 'a' '4']
%          a = [1 1 2 3 1 3]
% the integers categories ascend in the alphabetical order of 's'

% sergey.feldman@gmail.com
% last edited: sept 27, 2012

[N,c] = size(s);
if N == 1 && c > 1; % if row, turn into a column
    s = s';
    N = c;
elseif N > 1 && c > 1; % if matrix, return an error
    display('error: received a matrix of strings')
    return
end

if N > 0
    [s_sort,idx] = sort(s);
    d = ~strcmp(s_sort(1:end-1),s_sort(2:end));
    d(N,1) = true; 
    pos = cumsum([1;d]);
    pos(N+1) = [];
    a(idx,1) = pos;
else
    a = [];
end
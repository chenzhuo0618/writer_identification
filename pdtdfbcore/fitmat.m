function X = fitmat(Y,N)
% FITMAT   fit a matrix to matrix of size N, truncate or expand if necessary
% Syntax 	
%   X = fitmat(Y,N)
% Input:
%   Y : the matrix to expand or cut
%   N : size of destination matrix , N*N if N is one value
%
% Output:
%   X:	Resulting matrix
%
% Note:
%   See formulat.tex in Tex folder
%      
% See also: 
% History 
% Apr,11,2004 : Creation ...
% Aug,15,2004 : Debug ...


if length(N) == 1
    N = [N,N];
end

test = Y - rot90(Y,2);
test = sum(test(:));

if (test > 10^(-5))
    disp('NOTE, Y not symetric');
%     return;
end

szY = size(Y);
szX = [max(szY(1),N(1)),max(szY(2),N(2))];
Xbig = zeros(szX);

diff = fix((szX-szY)/2);

Xbig(1+diff(1): diff(1)+szY(1),1+diff(2): diff(2)+szY(2))=Y;

X = zeros(N);

diff = fix((szX-N)/2);

X = Xbig(1+diff(1): diff(1)+N(1),1+diff(2): diff(2)+N(2));



function y = mkZero_pdtdfb(S, lev, res)
% MKZERO_PDTDFB   Make a structure of pdtdfb with all zeros
%
%   y = mkZero_pdtdfb(S, lev)
%
% Input:
%   y:	    Size of the image that structure y represent
%   lev:    Level of decomposition, see PDTDFBDEC
%   res:    Optinal, Residual band exist or not
% Output:
%   y:	    zero data structure
%
% See also: PDTDFBDEC, PDTDFBREC

N = length(lev); 
% lowest resolution level
if max(size(S)) == 1
    S = [S S];
end

y{1} = zeros(S(1)/2^N, S(2)/2^N);


for l = 2:N+1
    ls = S./2^(N+1-l);

    for in = 1:2^(lev(l-1)-1);
        s1 = ls(1)/2^(lev(l-1)-1);
        s2 = ls(2)/2;
        y{l}{1}{in} = zeros(s1, s2);
        y{l}{2}{in} = zeros(s1, s2);
    end

    for in = 2^(lev(l-1)-1)+1:2^(lev(l-1));
        s1 = ls(1)/2;
        s2 = ls(2)/2^(lev(l-1)-1);
        y{l}{1}{in} = zeros(s1, s2);
        y{l}{2}{in} = zeros(s1, s2);
    end
    
end

if ~exist('res','var')
    res = 0;
end

if res
% residual level
y{N + 2} = zeros(S(1), S(2));
end

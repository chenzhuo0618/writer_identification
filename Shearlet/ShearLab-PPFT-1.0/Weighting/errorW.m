function err = errorW(img,R,basisChoice)
%% ERRORW the frobenious error of ||F*wF I- I||^2/||I||^2
% here F is the operator PPFT.
%
%% Description
%  ERR = ERRORW(IMG,R,BASISCHOICE) return the frobenious norm of the
%  operator (F^*wF-Id) applying to an image I, i.e.,
%          err = ||(F^*wF-Id)I||^2/||I||^2
%
%% Examples
%     img = imread('barbara.gif');
%     R   = 2; Choice = 1;
%     err = errorW(img,R,Choice);
%
%% See also CONDW, LOADW, SAVEW, FINDWEIGHT, WEIGHTGENERATE, PPFT, ADJPPFT,
% BASISFUNCTION.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

[n,m] = size(img);
if n ~= m || (rem(n,2)==1)
    disp('size of image should be even. exiting the code ...')
end

N = n;

w0 = loadW(N,R,basisChoice);
P  = basisFunction(N,R,basisChoice);
W  = WeightGenerate(N,P,w0);

x0 = double(img);
px = ppFT(x0,R);
tx = AdjppFT(W.*px,R);

err= norm(tx-x0,'fro')/norm(x0,'fro');

return

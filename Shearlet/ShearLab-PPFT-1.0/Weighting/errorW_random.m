function op = errorW_random(N,R,basisChoice,nTotal)
%% ERRORW_RANDOM Operator norm estimate for  ||F*wF I- I||^2/||I||^2 
% using random image. here F is the operator PPFT.
%
%% Description
%  op = ERRORW_RANDOM(N,R,BASISCHOICE) return the frobenious norm estimate 
%  of the operator (F^*wF-Id) applying to a image I, i.e.,
%          op = \sum_{k=1}^{nTotal} ||(F^*wF-Id)I_k||^2/||I_k||^2.
%  I_k is the random image from routine RANDN or RAND.
%
%% Examples
%     nTotal = 5; N = 32;
%     R   = 2; Choice = 1;
%     err = errorW_random(N,R,Choice,nTotal);
%
%
%% See also CONDW, LOADW, SAVEW, FINDWEIGHT, WEIGHTGENERATE, PPFT, ADJPPFT,
% BASISFUNCTION, ERRORW.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


w0 = loadW(N,R,basisChoice);
P  = basisFunction(N,R,basisChoice);
W  = WeightGenerate(N,P,w0);
err= 0;

for k = [1:nTotal]
    x0 = rand(N);
    px = ppFT(x0,R);
    tx = AdjppFT(W.*px,R);

    err= err + norm(tx-x0,'fro')/norm(x0,'fro');
end

op = err/nTotal;

return

function [imageA,imageB,imageC,imageD]=TR_CWTcoef_quartering(in)
s=size(in);
imageA=in(1:s(1)/2,1:s(2)/2);
imageB=in(1:s(1)/2,s(2)/2+1:s(2));
imageC=in(s(1)/2+1:s(1),1:s(2)/2);
imageD=in(s(1)/2+1:s(1),s(2)/2+1:s(2));

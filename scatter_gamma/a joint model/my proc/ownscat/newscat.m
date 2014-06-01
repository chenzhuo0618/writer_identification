function [out]=newscat(filename,options)
% srcfun : apply fun to each filenames of a ScatNet-compatible src
%
% Usage :
%   cell_out = srcfun(fun, src);
%
% Example of use :
%

% x=imreadBW(filename);
% Wop=wavelet_factory_2d(size(x));
% Sx=scat(x,Wop);
% S_mat=format_scat(Sx)
% X_all=ownscat(filename,options);
% fun = @(Sx)(mean(mean((remove_margin(format_scat(Sx),1)),2),3));
% X=fun(X_all);
% X=double(X);
% %%split
% %formatting the output
% %present the output as a two dimensional matrix [K x N] (K subbands, N coeffs per subband)
% S=size(X_all);
% out=[];
foptions.J=3;
foptions.L=8;
soptions.M=2;
soptions.oversampling = 1;
x=imreadBW(filename);
Wop=wavelet_factory_2d(size(x),foptions,soptions);
trans_scatt_all=scat(x,Wop);
clear x;

fun = @(Sx)(mean(mean(remove_margin(format_scat(Sx),1),2),3));
trans_scatt = fun(trans_scatt_all);

X_all=trans_scatt_all;
S=size(X_all);
%%eners=zeros(1,S(2));
for s=1:S(2)
    out{s}=[];
    SS=size(X_all{s}.signal);
    for ss=1:SS(2)
        %%if strcmp(format,'split')==1
	        out{s} = [out{s} double(X_all{s}.signal{ss}(:))];
        %%elseif strcmp(format,'array')==1
	    %%    out{s} = [out{s}; transf{s}{ss}.signal(:)];
        %%elseif strcmp(format,'average')==1
	    %%    out{s} = [out{s} mean(transf{s}{ss}.signal(:))];
        %%end
		%%eners(s)=eners(s)+sum(X_all{s}.signal{ss}(:).^2);
	end

end
%%out=[outall;out];
%%X_all=ownscat(filename,options);
end









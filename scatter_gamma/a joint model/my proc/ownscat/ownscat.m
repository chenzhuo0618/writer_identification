function [cell_out]=ownscat(filename,options)
% srcfun : apply fun to each filenames of a ScatNet-compatible src
%
% Usage :
%   cell_out = srcfun(fun, src);
%
% Example of use :
%   

    
    Wop = wavelet_factory_2d_spatial(options, options);
   %%Wop = wavelet_factory_3d_spatial(options, options, options);
%%    fun = @(filename)(scat(imresize_notoolbox(imreadBW(filename),[200 200]), Wop));
    Wop=wavelet_factory_2d(size(x));
    %%fun = @(filename)(scat(imresize_notoolbox(imreadBW(filename) ,[512 512]), Wop));
    %%analysis filename with scale and angle
    if filename(7)=='1'
        fun = @(filename)(scat(imresize_notoolbox(imreadBW(filename) ,[256 256]), Wop));
    end
    if filename(7)=='2'
    fun = @(filename)(scat(imresize_notoolbox(imreadBW(filename) ,[512 512]), Wop));
    end
    if filename(7)=='3'
    fun = @(filename)(scat(imresize_notoolbox(imreadBW(filename) ,[1024 1024]), Wop));
    end
    %%Ñ­»·µü´ú¼ÆËãnewsrcfun

    cell_out = fun(filename);		
end
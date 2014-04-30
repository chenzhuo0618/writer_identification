%close all
im=imread('circle.gif');
x=double(im);
smooth_func = @rcos;
Pyr_mode = 2; %第一级LP分解下采样级数
L=3;
y = PyrNDDec_mm(x, 'S', L, Pyr_mode, smooth_func)
for i=L+1:-1:1
    figure,imshow(y{i},[])
end
%仅进行抗混叠Contourlet中的LP分解
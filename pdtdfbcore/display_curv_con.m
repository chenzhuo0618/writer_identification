% fdct_wrapping_demo_basic.m -- Displays a curvelet both in the spatial and frequency domains.

close all;clear all;
m = 512;
n = 512;

X = zeros(m,n);

addpath('/home/truong/pdfb/CurveLab-2.0/fdct_wrapping_matlab');

%forward curvelet transform
disp('Take curvelet transform: fdct_wrapping');
tic; C = fdct_wrapping(X,0); toc;

%specify one curvelet
s = 5;
w = 1;
[A,B] = size(C{s}{w});
a = ceil((A+1)/2);
b = ceil((B+1)/2);
C{s}{w}(a,b) = 1;

%adjoint curvelet transform
disp('Take adjoint curvelet transform: ifdct_wrapping');
tic; Y = ifdct_wrapping(C,0); toc;

%display the curvelet
F = ifftshift(fft2(fftshift(Y)));
subplot(2,2,1); colormap gray; imagesc(real(Y)); axis('image'); ...
    title('a curvelet: spatial viewpoint');
subplot(2,2,2); colormap gray; imagesc(abs(F)); axis('image'); ...
    title('a curvelet: frequency viewpoint');

%get parameters
[SX,SY,FX,FY,NX,NY] = fdct_wrapping_param(C);



% ========================= PDTDFB_F ==========================
cfg =  [2 3 5 5];
res = 4;
resi = true;
band = 2^(cfg(res)-1)+1;

yz = mkZero_pdtdfb([m n], cfg, resi);

F = pdtdfb_win([m n], 0.15, length(cfg), resi);

s = size(yz{res+1}{1}{band});
yz{res+1}{1}{band}(s(1)/2+1, s(2)/2+1) = 1;

imr = pdtdfbrec_f(yz, F, [], resi);

yz = mkZero_pdtdfb([m n], cfg, resi);
yz{res+1}{2}{band}(s(1)/2+1, s(2)/2+1) = 1;

imi = pdtdfbrec_f(yz, F, [], resi);

con1 = imr-j*imi;

%display the curvelet
F = ifftshift(fft2(fftshift(con1)));
subplot(2,2,3); colormap gray; imagesc(real(con1)); axis('image'); ...
    title('a contourlet: spatial viewpoint');
subplot(2,2,4); colormap gray; imagesc(abs(F)); axis('image'); ...
    title('a contourlet: frequency viewpoint');

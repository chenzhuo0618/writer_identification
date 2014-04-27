% test the new decomposition method for pdtdfb
close all; clear all
alpha = 0.15;

s = [256 256];
s = [16 8];


alpha = 0.15;
alpha = 0.3;

% create the grid
S1 = -1.5*pi:pi/(s(1)/2):1.5*pi;
S2 = -1.5*pi:pi/(s(2)/2):1.5*pi;
[x1, x2] = meshgrid(S2,S1);

r = [0.5-alpha 0.5 1-alpha, 1+ alpha];

% --------------------------------------------
% create Low pass and highpass window
sz = size(x1);
cen_row = x1((sz(1)+1)/2,:);
cen_row = abs(cen_row);
fl_row = fun_meyer(cen_row,pi*[-2 -1 r(1:2)]);

cen_col = x2(:,(sz(2)+1)/2);
cen_col = abs(cen_col);
fl_col = fun_meyer(cen_col,pi*[-2 -1 r(1:2)]);

FL =  fl_col(:)*fl_row(:).';
FH =  1-FL;

FL = 2*fftshift(sqrt((FL(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2)))));
FH = FH(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2));


% -------------------------------------------
% create the directional window
xd = abs(x1+x2);
f1 = fun_meyer(xd,pi*[-2, -1, 1-alpha, 1+alpha]);

xd = abs(x1-x2);
f2 = fun_meyer(xd,pi*[-2, -1, 1-alpha, 1+alpha]);

fl = f1.*f2;

fl = periodize(fl,s, 'r');
fl = [fl(s(1)/2+1:end,:); fl(1:s(1)/2,:)];


f1 = fun_meyer(x1,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);
f2 = fun_meyer(x2,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);

fh = f1.*f2;
f1 = fun_meyer(-x1,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);
f2 = fun_meyer(-x2,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);

fh = fh + f1.*f2;

fh = periodize(fh,s,  'r');

f1 = fftshift(sqrt(2*FH.*fl.*fh));
f2 = fftshift(sqrt(2*FH.*fl.* [fh(s(1)/2+1:end,:); fh(1:s(1)/2,:)]));
f3 = fftshift(sqrt(2*FH.*fftshift(fl).*fh));
f4 = fftshift(sqrt(2*FH.*fftshift(fl).* [fh(s(1)/2+1:end,:); fh(1:s(1)/2,:)]));

% -------------------------------------------
% create the phase function
% fourier series
k = -((1:10)).^(-1);
tmp = 0*x1;

for in = 1:10
    tmp = tmp+ k(in)*sin(2*in*x1);
end

tmp2 = mod(x1+pi,2*pi)-pi;

phs = tmp2-tmp;

phs = (phs(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2)));

tmp = 0*x2;

for in = 1:10
    tmp = tmp+ k(in)*sin(2*in*x2);
end

tmp2 = mod(x2+pi,2*pi)-pi;

phsb = tmp2-tmp;

phsb = (phsb(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2)));

% four complex directional window
f1c = f1+j*f1.*exp(-j*phs);
f2c = f2+j*f2.*exp(-j*phs);
f3c = f3+j*f3.*exp(-j*phsb);
f4c = f4+j*f4.*exp(-j*phsb);


% decomposition--------------------------------
s = [256 256];

im = double(imread('peppers256.png'));
im = mkZonePlate([256 256]);

% 
dat = readbin('/home/truong/pdfb/multiple/fortran/test.dat',1,87381);

F = pdtdfb_win(s, 0.3);

% y = ucurvdec(im, N, F);
imf = fft2(im);

x = [1 1 2 2 1 2 2 1];

tmp = periodize(imf.*F{1},s/2);
im0t = ifft2(tmp(1:s(1)/2, 1:s(2)/2));

tmp = periodize(circshift(imf.*F{1}, [1 1]),s/2);
im0t = ifft2(tmp(1:s(1)/2, 1:s(2)/2));

im0 = ifft2(imf.*F{1});

im1 = ifft2(imf.*F{2});
im2 = ifft2(imf.*F{3});
im3 = ifft2(imf.*F{4});
im4 = ifft2(imf.*F{5});

im0(2:2:end,:) = 0;
im0(:,2:2:end) = 0;
im1(x(1):2:end,:) = 0;
im1(:,x(2):2:end) = 0;
im2(x(3):2:end,:) = 0;
im2(:,x(4):2:end) = 0;
im3(x(5):2:end,:) = 0;
im3(:,x(6):2:end) = 0;
im4(x(7):2:end,:) = 0;
im4(:,x(8):2:end) = 0;

im0 = ifft2(fft2(im0).*F{1});
im1 = ifft2(fft2(im1).*conj(F{2}));
im2 = ifft2(fft2(im2).*conj(F{3}));
im3 = ifft2(fft2(im3).*conj(F{4}));
im4 = ifft2(fft2(im4).*conj(F{5}));

imr = im0+real(im1+im2+im3+im4);

snr(im,imr)







%
disp('Testing the two function PDTDFBDEC_F and PDTDFBREC_F')

close all; clear all;

s = 1024;
s = [s s];
cf = [4 4 4]
res = false;

im = mkZonePlate(s);
tic
F = pdtdfb_win(s, 0.1, length(cf), res );
disp('Window calculation')
toc
tic
y2 = pdtdfbdec_f(im, cf, F, [], res);
disp('Foward transform')
toc

tic
imr = pdtdfbrec_f(y2,F,[],res);
disp('Inverse transform')
toc

%
disp('Signal to noise ratio')
snr(im,imr)

% existing : 23 and 25 sec

for in = 1:2^(cf(1))
    yz = mkZero_pdtdfb(s, cf);

    szb = size(yz{2}{1}{in});

    yz{2}{1}{in}(szb(1)/2+1, szb(2)/2+1) = 1;
    imr = pdtdfbrec_f(yz,F);

    yz = mkZero_pdtdfb(s, cf);

    yz{2}{2}{in}(szb(1)/2+1, szb(2)/2+1) = 1;
    imi = pdtdfbrec_f(yz,F);

    figure(1);
    subplot(121);
    imagesc(fitmat(imr,20),0.1*[-1 1]);
    subplot(122);
    imagesc(fitmat(imi,20),0.1*[-1 1]);
    colormap gray

    figure(2);
    imagesc(abs(fftshift(fft2(imr+j*imi))));
    
end

% =====================================================================
% generate figure for paper part 1, figure 9
% =====================================================================
s = 256;

im = mkImpulse(s);
res = true
cf = 3;
tic
F = pdtdfb_win(s, 0.3, length(cf), res );
disp('Window calculation')
toc

tic
% y = pdtdfbdec_f(im, cf, F, [], res);
dfilt = 'meyer'
pfilt = 'meyer'
y = pdtdfbdec(im, cf, pfilt,dfilt,[], res);
disp('Foward transform')
toc

yz = mkZero_pdtdfb(256, 3, res);
yz{2}{1}{1} = y{2}{1}{1};
% im1 = pdtdfbrec_f(yz, F, [], res);
im1 = pdtdfbrec(yz, pfilt,dfilt,[], res);

yz = mkZero_pdtdfb(256, 3, res);
yz{2}{2}{1} = y{2}{2}{1};
% im2 = pdtdfbrec_f(yz, F, [], res);
im2 = pdtdfbrec(yz, pfilt,dfilt,[], res);

im3 = im1+im2;

subplot(131); freqz2(fitmat(im1,64));
subplot(132); freqz2(fitmat(im2,64));
subplot(133); freqz2(fitmat(im3,64));


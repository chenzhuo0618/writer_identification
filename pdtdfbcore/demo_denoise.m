% DENOISEDEMO   Denoise demo
% Compare the denoise performance of wavelet and contourlet transforms
%

im = double(imread('lena.png'));

% Parameters
NV = [5 10 15 20 30 50 75 100]
addpath('/home/truong/pdfb/contourlet_toolbox');
for in = 1: length(NV)

    % Generate noisy image.
    % sig = std(im(:));
    % sigma = sig / rho;
    sigma = 20; % NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    nim = im + noise;
    resnoi(in) = psnr(im, nim)

    %%%%% Wavelet denoising %%%%%
    % Wavelet transform using PDFB with zero number of level for DFB
    pfilt = 'db5';
    dfilt = 'db5';
    th = 3;                     % lead to 3*sigma threshold denoising
    rho = 3;                    % noise level

    y = pdfbdec(nim, pfilt, dfilt, [0 0 0], 1);
    [c, s] = pdfb2vec(y);

    % Threshold (typically 3*sigma)
    wth = th * sigma;
    c = c .* (abs(c) > wth);

    % Reconstruction
    y = vec2pdfb(c, s);
    wim = pdfbrec(y, pfilt, dfilt);

    reswav(in) = psnr(im, wim)

    %%%%% PDTDFB Denoising %%%%%

    residual = false;
    y = pdtdfbdec(nim, [1 4 5], 'nalias', 'meyer', 'db5', residual);

    % threshold for pdtdfb is lower because the energy of the filter is not 1
    thd = 0.6*wth;

    %threshold
    yth = pdtdfb_thrsh(y,'threshold', [0 thd thd wth], cfg);
    % Reconstruction
    pim = pdtdfbrec(yth, 'nalias', 'meyer', 'db5', residual);


    cfg =  [2 3 4 5];
    F = pdtdfb_win(512, 0.1, length(cfg));
    y = pdtdfbdec_f(nim, cfg, F);

    yth = pdtdfb_thrsh(y,'threshold', [0 thd thd thd wth], cfg);
    pim = pdtdfbrec_f(yth, F);
    respdtdfb(in) = psnr(im, pim)

    %%%%% Contourlet Denoising %%%%%
    % Contourlet transform
    nlevs = [0 4 5];
    pfilt = 'db5';
    dfilt = 'pkva';
    y = pdfbdec(nim, pfilt, dfilt, nlevs);
    [c, s] = pdfb2vec(y);

    % Threshold
    % Require to estimate the noise standard deviation in the PDFB domain first
    % since PDFB is not an orthogonal transform
    nvar = pdfb_nest(size(im,1), size(im, 2), pfilt, dfilt, nlevs);

    cth = th * sigma * sqrt(nvar);
    % cth = (4/3) * th * sigma * sqrt(nvar);

    % Slightly different thresholds for the finest scale
    fs = s(end, 1);
    fssize = sum(prod(s(find(s(:, 1) == fs), 3:4), 2));
    cth(end-fssize+1:end) = (4/3) * cth(end-fssize+1:end);

    c = c .* (abs(c) > cth);

    % Reconstruction
    y = vec2pdfb(c, s);
    cim = pdfbrec(y, pfilt, dfilt);

    rescon(in) = psnr(im, cim)

end

rmpath('/home/truong/pdfb/contourlet_toolbox');

%%%%% Plot: Only the hat!
range = [0, 255];
colormap gray;
subplot(2,3,1), imagesc(im(41:168, 181:308), range); axis image off
set(gca, 'FontSize', 8);
title('Original Image', 'FontSize', 10);

subplot(2,3,2), imagesc(nim(41:168, 181:308), range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Noisy Image (PSNR = %.2f dB)', ...
              psnr(im, nim)), 'FontSize', 10);

subplot(2,3,4), imagesc(wim(41:168, 181:308), range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Denoise using Wavelets (PSNR = %.2f dB)', ...
              psnr(im, wim)), 'FontSize', 10);

subplot(2,3,5), imagesc(cim(41:168, 181:308), range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Denoise using Contourlets (PSNR = %.2f dB)', ...
              psnr(im, cim)), 'FontSize', 10);
          
subplot(2,3,6), imagesc(pim(41:168, 181:308), range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Denoise using PDTDFB (PSNR = %.2f dB)', ...
              psnr(im, pim)), 'FontSize', 10);


figure;          
colormap gray;
subplot(2,2,1), imagesc(im, range); axis image off
set(gca, 'FontSize', 8);
title('Original Image', 'FontSize', 10);

subplot(2,2,2), imagesc(nim, range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Noisy Image (SNR = %.2f dB)', ...
              SNR(im, nim)), 'FontSize', 10);

subplot(2,2,3), imagesc(wim, range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Denoise using Wavelets (SNR = %.2f dB)', ...
              SNR(im, wim)), 'FontSize', 10);

subplot(2,2,4), imagesc(cim, range); axis image off
set(gca, 'FontSize', 8);
title(sprintf('Denoise using Contourlets (SNR = %.2f dB)', ...
              SNR(im, cim)), 'FontSize', 10);          
          
          
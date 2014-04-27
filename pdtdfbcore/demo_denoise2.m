% DENOISEDEMO2   Denoise demo : compare against CurveLab and non subsampled
% contoulret
%

close all; clear all;
im = double(imread('lena.png'));
im = double(imread('barbara.png'));
im = double(imread('peppers.png'));

cfg =  [3 4 5];
% cfg =  [0 0 4 5];
s = 512;
resi = true;

disp('Compute all thresholds');
Ff = ones(s);
X = fftshift(ifft2(Ff)) * sqrt(prod(size(Ff)));

y = pdtdfbdec(X, cfg, 'nalias','pkva',[], resi);

clear eng

for in1=1:length(cfg)
    for in2=1:2^cfg(in1)
        A = y{in1+1}{1}{in2}+j*y{in1+1}{1}{in2};
        eng(in1,in2) =  sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
        % sqrt(sum(sum(tmp.*conj(tmp))));
    end
end

if resi
    A = y{end};
    eng(length(cfg)+1,1) = sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
end

pfilt = 'db5';

NV = [5 10 15 20 30 50 75 100]
for in = 1: length(NV)

    % Generate noisy image.
    sig = std(im(:));
    
    sigma = NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    nim = im + noise;
    resnoi(in) = psnr(im, nim)


    % actual denoising
    tic
    % y = pdtdfbdec_f(nim, cfg, F, alpha, resi); toc

    y = pdtdfbdec(nim, cfg, 'nalias','pkva',[],resi); toc

    % Apply thresholding
    yth = y;
    for s = 2:length(cfg)+1
        thresh = 3*sigma + sigma*(s == length(cfg)+1);
        for w = 1:length(y{s}{1})
            A = y{s}{1}{w}+j*y{s}{2}{w};
            A = A.* (abs(A) > thresh*eng(s-1,w));
            % A = A.* (abs(A) >thersh_t(s));
            yth{s}{1}{w} = real(A);
            yth{s}{2}{w} = imag(A);
        end
    end

    if resi
        A = y{end};
        thresh = 4*sigma;
        yth{end} = A.* (abs(A) > thresh*sigma);
    end

    tic
    % pim = pdtdfbrec_f(yth, F, alpha,resi);toc

    pim = pdtdfbrec(yth, 'nalias','pkva',[],resi);

    respdtdfb(in) = psnr(im, pim)

end

% ----------------------------------------------------------------------

% noise level [5 10 15 20 30 50 75 100]
%   34.1514   28.1308   24.6090   22.1102   18.5884   14.1514   10.6296    8.1308
% result pdtdfb with residual band: Lena
%   36.6950   34.0104   32.2245   30.9535   29.0579   26.5321   24.4148   22.8156
% result pdtdfb with residual band: Barbara
% 32.4642   30.6519   29.2569   28.2457   26.5311   24.2967   22.4700   21.0548
% result pdtdfb with residual band: Peppers
% 33.9993   32.3700   31.1669   30.1044   28.5274   26.1541   23.9688   22.4525

% NO RESIDUAL BAND ========================================================
resi = false;
s = 512;

disp('Compute all thresholds');
Ff = ones(s);
X = fftshift(ifft2(Ff)) * sqrt(prod(size(Ff)));

y = pdtdfbdec(X, cfg, 'nalias','pkva',[], resi);

clear eng

for in1=1:length(cfg)
    for in2=1:2^cfg(in1)
        A = y{in1+1}{1}{in2}+j*y{in1+1}{1}{in2};
        eng(in1,in2) =  sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
        % sqrt(sum(sum(tmp.*conj(tmp))));
    end
end

if resi
    A = y{end};
    eng(length(cfg)+1,1) = sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
end

NV = [5 10 15 20 30 50 75 100]
for in = 1: length(NV)

    % Generate noisy image.
    
    sigma = NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    nim = im + noise;
    resnoi(in) = psnr(im, nim)


    % actual denoising
    tic
    % y = pdtdfbdec_f(nim, cfg, F, alpha, resi); toc

    y = pdtdfbdec(nim, cfg, 'nalias','pkva',[],resi); toc

    % Apply thresholding
    yth = y;
    for s = 2:length(cfg)+1
        thresh = 3*sigma; % + sigma*(s == length(y));
        for w = 1:length(y{s}{1})
            A = y{s}{1}{w}+j*y{s}{2}{w};
            A = A.* (abs(A) > thresh*eng(s-1,w));
            % A = A.* (abs(A) >thersh_t(s));
            yth{s}{1}{w} = real(A);
            yth{s}{2}{w} = imag(A);
        end
    end

    if resi
        A = y{end};
        thresh = 4*sigma;
        yth{end} = A.* (abs(A) > thresh*sigma);
    end

    tic
    % pim = pdtdfbrec_f(yth, F, alpha,resi);toc

    pim = pdtdfbrec(yth, 'nalias','pkva',[],resi);

    respdtdfb2(in) = psnr(im, pim)

end
% noise level [5 10 15 20 30 50 75 100]
% non residual band hard thresholding result
% Result for lena
% 36.3926   33.5030   31.9110   30.6587   28.8718   26.4080   24.2986   22.7825
% Result for Barbara
% 35.2953   31.6170   29.6477   28.2395   26.3879   23.9724   22.0719   20.8408
% Result for Peppers
% 35.0788   32.6724   31.2951   30.2381   28.5827   26.1190   23.8770   22.4008


%=========================================================================
% non subsampled contourlet transform
%=========================================================================
close all; clear all;
im = double(imread('lena.png'));
rmpath('C:\MATLAB71\work\pdtdfbcore');
addpath('C:\MATLAB71\work\nsct_toolbox');

cfg =  [2 3 4];
s = 512;

disp('Compute all thresholds');
Ff = ones(s);
X = fftshift(ifft2(Ff)) * sqrt(prod(size(Ff)));

% Parameteters:
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;              % Directional filter

% Nonsubsampled Contourlet decomposition
coeffs = nsctdec( X, cfg, dfilter, pfilter );

clear eng

for in1=1:length(cfg)
    for in2=1:2^cfg(in1)
        A = coeffs{in1+1}{in2};
        eng(in1,in2) =  sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
        % sqrt(sum(sum(tmp.*conj(tmp))));
    end
end


NV = [5 10 15 20 30 50 75 100]
for in = 1: length(NV)

    % Generate noisy image.
    sig = std(im(:));
    
    sigma = NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    nim = im + noise;
    resnoi(in) = psnr(im, nim)

    % actual denoising
    tic
    % Nonsubsampled Contourlet decomposition
    y = nsctdec( double(nim), cfg, dfilter, pfilter );
    toc
    
    % Apply thresholding
    yth = y;
    for s = 2:length(cfg)+1
        thresh = 3*sigma; % + sigma*(s == length(y));
        for w = 1:length(y{s})
            A = y{s}{w};
            A = A.* (abs(A) > thresh*eng(s-1,w));
            % A = A.* (abs(A) >thersh_t(s));
            yth{s}{w} = A;
        end
    end
    
    % Reconstruct image
    imrec = nsctrec( yth, dfilter, pfilter ) ;

    respdtdfb(in) = psnr(im, imrec)

end
% nonsubsmapled contourlet lena
% 38.0895   35.1478   33.3624   31.9920   29.9941   27.2590   25.1814   23.5375

im = double(imread('barbara.png'));
NV = [5 10 15 20 30 50 75 100]
for in = 1: length(NV)

    % Generate noisy image.
    sig = std(im(:));
    
    sigma = NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    nim = im + noise;
    resnoi(in) = psnr(im, nim)

    % actual denoising
    tic
    % Nonsubsampled Contourlet decomposition
    y = nsctdec( double(nim), cfg, dfilter, pfilter );
    toc
    
    % Apply thresholding
    yth = y;
    for s = 2:length(cfg)+1
        thresh = 3*sigma; % + sigma*(s == length(y));
        for w = 1:length(y{s})
            A = y{s}{w};
            A = A.* (abs(A) > thresh*eng(s-1,w));
            % A = A.* (abs(A) >thersh_t(s));
            yth{s}{w} = A;
        end
    end
    
    % Reconstruct image
    imrec = nsctrec( yth, dfilter, pfilter ) ;

    respdtdfb2(in) = psnr(im, imrec)
end

% nonsubsmapled contourlet barbara
% 37.4634   33.7049   31.4563   29.8318   27.4039   24.5530   22.7881   21.6466


im = double(imread('peppers.png'));
NV = [5 10 15 20 30 50 75 100]
for in = 1: length(NV)

    % Generate noisy image.
    sig = std(im(:));
    
    sigma = NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    nim = im + noise;
    resnoi(in) = psnr(im, nim)

    % actual denoising
    tic
    % Nonsubsampled Contourlet decomposition
    y = nsctdec( double(nim), cfg, dfilter, pfilter );
    toc
    
    % Apply thresholding
    yth = y;
    for s = 2:length(cfg)+1
        thresh = 3*sigma; % + sigma*(s == length(y));
        for w = 1:length(y{s})
            A = y{s}{w};
            A = A.* (abs(A) > thresh*eng(s-1,w));
            % A = A.* (abs(A) >thersh_t(s));
            yth{s}{w} = A;
        end
    end
    
    % Reconstruct image
    imrec = nsctrec( yth, dfilter, pfilter ) ;

    respdtdfb3(in) = psnr(im, imrec)
end

% % nonsubsmapled contourlet peppers
% 36.8604   34.3438   32.8744   31.7548   29.8933   27.1559   25.0690   23.5417


%=========================================================================
% CurveLab curvelet transform
%=========================================================================
% 
addpath('C:\MATLAB71\work\CurveLab\CurveLab-2.0\fdct_wrapping_matlab');

n= 512;
disp('Compute all thresholds');
F = ones(n);
X = fftshift(ifft2(F)) * sqrt(prod(size(F)));
tic, C = fdct_wrapping(X,1,1,4); toc;

% Compute norm of curvelets (exact)
E = cell(size(C));
for s=1:length(C)
  E{s} = cell(size(C{s}));
  for w=1:length(C{s})
    A = C{s}{w};
    E{s}{w} = sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
  end
end

img = double(imread('lena.png'));
img = double(imread('barbara.png'));

NV = [5 10 15 20 30 50 75 100]
for in = 1: length(NV)

    % Generate noisy image.
    sig = std(img(:));
    
    sigma = NV(in);
    noise = randn(size(im));
    noise = sigma.*(noise./(std(noise(:))));

    noisy_img = img + noise;
    resnoi(in) = psnr(img, noisy_img)
    
    % Take curvelet transform
    disp(' ');
    disp('Take curvelet transform: fdct_wrapping');
    tic; C = fdct_wrapping(noisy_img,1,1,4); toc;

    % Apply thresholding
    Ct = C;
    for s = 2:length(C)
        thresh = 3*sigma + sigma*(s == length(C));
        for w = 1:length(C{s})
            Ct{s}{w} = C{s}{w}.* (abs(C{s}{w}) > thresh*E{s}{w});
        end
    end

    % Take inverse curvelet transform
    disp(' ');
    disp('Take inverse transform of thresholded data: ifdct_wrapping');
    tic; restored_img = real(ifdct_wrapping(Ct,1,n,n)); toc;

    respdtdfb3(in) = psnr(img, restored_img)
end

% curvelab unwrapping curvelet thresholding result
% denoise result for Lena
% 37.0523   34.3213   32.6049   31.4132   29.5669   27.0165   25.0638   23.3893
% denoise result for Barbara
%   36.2220   32.7150   30.6381   29.2136   27.1598   24.4473   22.6149   21.3809
% denoise result for Peppers
%  37.0574   34.3182   32.6332   31.3971   29.5398   27.0825   24.9777   23.3436



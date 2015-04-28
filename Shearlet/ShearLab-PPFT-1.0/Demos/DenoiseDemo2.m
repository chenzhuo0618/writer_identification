%% DENOISEDEMO 
% denoising demo using shearlets
% 
%% Description
%    Denoising demo using shearlet transform 
%% Examples
%    
%% See also SHEARLETTRANSFORM, GENERATEW, ADJSHEARLETTRANSFORM,
%% INVSHEARLETTRANSFORM, DSHDEN
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


clc
clear all;
close all;

%% Reading image
% 1. image bridge
 img = imread('bridge.jpg');  
 img = double(img(89:600,1:512,:));

%% generating a noisy image
sigma = 30;   % noise level
noise = randn(size(img))*sigma; % Gaussian noise
noisyImg = img+noise;

%% Setting parameters
R      = 2;                % oversammpling rate R = 2, 4, 8, 16;
beta   = 2;                % scaling factor beta = 2, 4
Choice = 1;                % basis Choice, see GENERATEW
CG     = 0;                % Use CG or not
err    = 1e-5;             % CG control error
its    = 10;               % CG maximal iterations
thr    = 0.01*sigma;       % setting threshold
      
%% Denoising
tic
for j = 1:3
recImg(:,:,j) = dshden(noisyImg(:,:,j),thr,R,beta,Choice,0,CG,err,its);
end
toc

%% dispay original image, noisy image, and denoised image
psnr1 = PSNR(img,noisyImg);
figure(1), imshow(uint8(img));
figure(2), imshow(uint8(noisyImg)); text(10,-15,['PSNR = ' num2str(psnr1)]);
psnr2 = PSNR(img,real(recImg)) ;  
figure(3),imshow(uint8(real(recImg)));text(10,-15,['PSNR = ' num2str(psnr2)]);   

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
% img = imread('bridge.jpg');  
% img = img(89:600,1:512,:);
% 2. image barbara
img  = imread('barbara.gif');
img1 = double(img(:,:,1));
%img = rgb2gray(img);
%img = im2double(img);
%img1= img1(1:2:512,1:2:512);
%imshow(uint8(img1));
% size(img1)

%% generating a noisy image
sigma = 30;   % noise level
noise = randn(size(img1))*sigma; % Gaussian noise
noisyImg = img1+noise;

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
recImg = dshden(noisyImg,thr,R,beta,Choice,0,CG,err,its);
toc

%% dispay original image, noisy image, and denoised image
psnr1 = PSNR(img1,noisyImg);
figure(1), imshow(uint8(img1));
figure(2), imshow(uint8(noisyImg)); text(10,-15,['PSNR = ' num2str(psnr1)]);
psnr2 = PSNR(img1,real(recImg)) ;  
figure(3),imshow(uint8(real(recImg)));text(10,-15,['PSNR = ' num2str(psnr2)]);   

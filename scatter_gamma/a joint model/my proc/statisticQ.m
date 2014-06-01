%% TR_CWTcoef_main.m
% MATLAB code for the article
%  TITLE = 《A Joint Model of Complex Wavelet Coefficients for Texture Retrieval》
% AUTHOR = {Roland Kwitt and Andreas Uhl},
%	DATE = {nov,2009},
% BOOKTITLE = {Proceedings of the IEEE International Conference on Image Processing, ICIP '09},

% 子图的分割
% TR_CWTcoef_splitting.m
tic
% clear all
clc
clear
cd('G:\scattering+gamma\scattering+gamma\a joint model\my proc');
addpath(genpath(pwd));
  
% 子图数据导入
% %%%%%%% 图像分割为16个子图
% splittingimgs_path = 'H:\scattering\Brodatz分割\';
% data = texload('Brodatz',splittingimgs_path ,16,1,2);


%%%%%%% 图像分割为64个子图
Jmax=7;  %%%%%%%%%%%%%%% 每次记得修改sizeb
maxclasses=2;
% data=brodatz_data(Jmax,maxclasses);
number=6;
[data,filenames] = retrieve_writing_Ltrain(number,maxclasses);
icip09(data,filenames,'stage','genmodel','copula','Gaussian','samples',100,'debug',true);   

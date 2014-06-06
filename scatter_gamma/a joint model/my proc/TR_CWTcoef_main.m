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
% cd('D:\2_26\scatter_gamma\a joint model\my proc');
% addpath(genpath(pwd));
  
% 子图数据导入
% %%%%%%% 图像分割为16个子图
% splittingimgs_path = 'H:\scattering\Brodatz分割\';
% data = texload('Brodatz',splittingimgs_path ,16,1,2);


%%%%%%% 图像分割为64个子图
%%Jmax=7;  %%%%%%%%%%%%%%% 每次记得修改sizeb
maxclasses=3;
% data=brodatz_data(Jmax,maxclasses);
number=16;
t0=clock;
%filenames = retrieve_writing_Ltrain(maxclasses);
%data=vistex_data(Jmax,maxclasses);
% data=stex_data(Jmax,maxclasses);
%  path_to_db = 'D:\2_26\dataset\tmp';
%  path_to_db='E:\Jay\cvpr2013\umd dataset';
path_to_db='E:\Jay\project\writer_identification\dataset\joint_use\dataset\light';
% path_to_db='E:\Jay\project\writer_identification\dataset\joint_use\dataset\light';
src = kthtips_src(path_to_db);
c_t0=etime(clock,t0);
t1=clock;

% 为每幅子图计算一个model
models = icip09(src,'stage','genmodel','copula','none','samples',100,'debug',true);  
% models = icip09(src,'stage','genmodel','copula','Gaussian','samples',100,'debug',true);  
% models = icip09(src,'stage','genmodel','copula','t','samples',100,'debug',true);   
% model = icip09(data,'stage','genmodel','copula','t','samples',500,'debug',true); 
% 计算每幅子图与所有子图的距离
c_t1=etime(clock,t1);
t2=clock;
div = icip09(src,'stage','runsim','models',models,'samples',100,'debug',true,'copula','none');
c_t2=etime(clock,t2);

% save div;
% 得到平衡距离  kld 对称距离
t3=clock;
div = div + div';

% 得到最终的检索率(取40幅最匹配的)
[r, rs,or]=evalir(generic_rrate(div,40,'ascend'))
c_t3=etime(clock,t3);

 
toc








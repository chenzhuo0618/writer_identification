%% ---------------------------------------------------
%% ---------- roto_trans_scatt_log_scale_avg ---------
%% ---------------------------------------------------

%%%%%##################################################
%�ó��������ڣ��ṩԭʼ��ͼ��⣬������ͬ���塢�߶Ⱥͷ���Ϊ�˼����ڴ����ģ���ÿ��ͼ�񵥶�
%���б任��ֱ��������������





%% compute scattering of all images in the database

%% load the database
clear; close all;
% cd('Scatter_PCA');
addpath(genpath(pwd));
options = struct;

%%��д��ͼ��·��
% path_to_db = 'F:\dataset\3_28\normal';
path_to_db='E:\Jay\project\writer_identification\dataset\B';
% path_to_db='F:\dataset\3_28\tmpheavy';
src = kthtips_src(path_to_db);
db_name = 'handwriting';

feature_name = 'roto_trans_scatt_log_scale_avg';

%%��д�������洢·��
savepath = 'D:\2_26\��д��\roto_trans_scatt_log_scale_avg.mat'
% grid_train = [10 15 20];% number of training for classification
grid_train = [10]

nb_split = 10; % number of split for classification

% configure scattering
options.J = 3; % number of octaves
options.Q = 1; % number of scales per octave
options.M = 2; % scattering orders
fmt = 'table';
M = options.M;

% build the wavelet transform operators for scattering
Wop = wavelet_factory_3d_pyramid(options, options, options);

% a function handle that compute scattering given an image
fun = @(x)(scat(x, Wop));

%###############################��Ӷ�߶�
%     multi_fun = @(filename)(fun_multiscale(fun,imreadBW(filename), 2, 3));
%     roto_trans_scatt_multiscale = srcfun(multi_fun, src);

% (2748 seconds on a 2.4 Ghz Intel Core i7)

roto_trans_scatt_multiscale_log_sp_avg = new_srcfun(fun, src,fmt,M);%%%ȥ���˶�߶�
db = new_cellsrc2db(roto_trans_scatt_multiscale_log_sp_avg, src);
save dbfeature db;

%% classification
%% assure the person who to write

rsds_classif(db, db_name, feature_name, grid_train, nb_split);


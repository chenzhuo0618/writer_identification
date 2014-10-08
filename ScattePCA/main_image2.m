%% ---------------------------------------------------
%% ---------- roto_trans_scatt_log_scale_avg ---------
%% ---------------------------------------------------

%%%%%##################################################
%该程序适用于，提供原始的图像库，包括不同褶皱、尺度和方向，为了减少内存消耗，对每幅图像单独
%进行变换，直到生产特征向量





%% compute scattering of all images in the database

%% load the database
clear; close all;
% cd('Scatter_PCA');
addpath(genpath(pwd));
options = struct;

%%手写体图像集路径
% path_to_db = 'F:\dataset\3_28\normal';
path_to_db='E:\Jay\project\writer_identification\dataset\joint_use\dataset\heavy';
% path_to_db='F:\dataset\3_28\tmpheavy';
src = kthtips_src(path_to_db);
db_name = 'handwriting';

feature_name = 'roto_trans_scatt_log_scale_avg';

%%手写体特征存储路径
savepath = 'D:\2_26\手写体\roto_trans_scatt_log_scale_avg.mat'
% grid_train = [10 15 20];% number of training for classification
grid_train = [8]

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



%###############################添加多尺度
%     multi_fun = @(filename)(fun_multiscale(fun,imreadBW(filename), 2, 3));
%     roto_trans_scatt_multiscale = srcfun(multi_fun, src);

% (2748 seconds on a 2.4 Ghz Intel Core i7)

roto_trans_scatt_multiscale_log_sp_avg = new_srcfun(fun, src,fmt,M);%%%去掉了多尺度
db = new_cellsrc2db(roto_trans_scatt_multiscale_log_sp_avg, src);


%% classification
%% assure the person who to write

rsds_classif(db, db_name, feature_name, grid_train, nb_split);


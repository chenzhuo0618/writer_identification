%% ---------------------------------------------------
%% ---------- roto_trans_scatt_log_scale_avg ---------
%% ---------------------------------------------------

%%%%%##################################################
%该程序适用于，提供原始的图像库，包括不同褶皱、尺度和方向，为了减少内存消耗，对每幅图像单独
%进行变换，直到生产特征向量





%% compute scattering of all images in the database

%% load the database
clear; close all;
cd('D:\cyi\scatnet-0.2');
addpath(genpath(pwd));
options = struct;
% NOTE : the following line must be modified with the path to the
% KTH-TIPS database in YOUR system.
path_to_db = 'D:\cyi\scatnet-0.2\图像库\手写体(128,256,512)';
% path_to_db = 'D:\cyi\scatnet-0.2\图像库\test_small';
src = kthtips_src(path_to_db);
db_name = 'handwriting';

feature_name = 'roto_trans_scatt_log_scale_avg';

savepath = 'D:\cyi\scatnet-0.2\roto_trans_scatt_log_scale_avg.mat'

grid_train = [36 48 60]; % number of training for classification
nb_split = 10; % number of split for classification



    % configure scattering
    options.J = 3; % number of octaves
    options.Q = 1; % number of scales per octave
    options.M = 2; % scattering orders
%     options.L = 6;
    fmt = 'table';
    M = options.M;
    % build the wavelet transform operators for scattering
    Wop = wavelet_factory_3d_pyramid(options, options, options);
    
    % a function handle that compute scattering given an image
    fun = @(x)(scat(x, Wop));
    
    
    % (2748 seconds on a 2.4 Ghz Intel Core i7)
    roto_trans_scatt_multiscale = srcfun(fun, src);%%%去掉了多尺度
    
    %% log + spatial average

    fun = @(Sx)(mean(mean(log(format_scat(Sx,fmt,M)),2),3));

    roto_trans_scatt_multiscale_log_sp_avg = ...
        cellfun_monitor(fun, roto_trans_scatt_multiscale);
    
   db = cellsrc2db(roto_trans_scatt_multiscale_log_sp_avg, src);


%% classification
rsds_classif(db, db_name, feature_name, grid_train, nb_split);


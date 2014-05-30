function model=train_writer(path_to_db,train_length,modefile)
% path_to_db = 'F:\dataset\3_28\smalltemp';

%%手写体特征存储路径
% savepath = 'D:\2_26\手写体\roto_trans_scatt_log_scale_avg.mat'

src = kthtips_src(path_to_db);

% grid_train = [36 48 60];% number of training for classification
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
model=affine_train_writers(db,train_length);
save(modefile, '-struct', 'model')
end
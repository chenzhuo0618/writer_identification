clc  
clear
cd('C:\Users\cyi\Desktop\scatnet_signal_new');
addpath(genpath(pwd));
options=struct;
tic

N = 2^12;

src = gtzan_src('C:\Users\cyi\Desktop\scatnet_signal_new\实验数据\draw_data',N);%数据位置
% src = gtzan_src('D:\cyi\scatnet_signal_new\实验数据\12K-DE',N);%数据位置

% filt_opt.filter_type = 'spline_1d';
filt_opt.filter_type = 'gabor_1d';
% filt_opt.filter_type = 'morlet_1d';

 
filt_opt.Q =1;
filt_opt.J=2; 
scat_opt.M = 2;
 
Wop = wavelet_factory_1d(N, filt_opt, scat_opt);
 
feature_fun = @(x)(new_format_scat(log_scat(renorm_scat(scat(x, Wop)))));
for s=power(2,[1:4])
database_options.feature_sampling =s;

 database = new_prepare_database(src, feature_fun, database_options);
 database.features = database.features.';

   k=log2(s);
    tmp{k} = database.features;
end
for j=1:7
figure
 axis([0 300 -6 2])
for i=1:4
    subplot(2,2,i);
    plot(tmp{i}(j,:))
   
    title(['固定采样' num2str(2^i)])
   
end
end
     
     
 
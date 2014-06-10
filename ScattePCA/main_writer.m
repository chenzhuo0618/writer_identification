clear; close all;
%%手写体图像集路径
path_to_db = 'F:\dataset\3_28\smalltemp';
db_name = 'handwriting';
%%手写体特征存储路径
% savepath = 'D:\2_26\手写体\roto_trans_scatt_log_scale_avg.mat'
%%训练
%训练集中每类中的图片数
train_length=10;
modelfile='modelfile';

model=train_writers(path_to_db,train_length,modelfile);
%需要测试的笔迹文本图片
testimg='F:\dataset\3_28\smalltemp\2\g0201.0.0.jpg';
%预测书写者 
person=test_writer(modelfile,train_length,testimg);
%% classification
%% assure the person who to write
% rsds_classif(db, db_name, feature_name, grid_train, nb_split);


% rsds_classif : a function to reproduce classification experiments of paper
%
%   ``Rotation, Scaling and Deformation Invariant Scattering
%   for Texture Discrimination"
%   Laurent Sifre, Stephane Mallat
%   Proc. IEEE CVPR 2013 Portland, Oregon
%

function error = rsds_classif(db, db_name, feature_name, grid_train, nb_split)

n_class = numel(db.src.classes);
n_images = numel(db.src.files);
% n_images = size(db.features,2);%%%因为每幅图像加了尺度，所以特征数多于原始图像数
n_per_class = n_images / n_class; % assumes constant number of image per class

rng(1); % set the random split generator of matlab to 
% have reproducible results  
K=1,V=3;
for i_split = 1:nb_split
    for i_train = 1:numel(grid_train)
        n_train = grid_train(i_train);
        prop = n_train/n_per_class ;
        [train_set, test_set] = create_partition(db.src, prop);
        train_opt.dim = n_train;
        model = affine_train(db, train_set, train_opt,K,V);
        labels = affine_test(db, model, test_set,K,V);
        error(i_split, i_train) = classif_err(labels, test_set, db.src);
        fprintf('split %3d nb train %2d accuracy %.2f \n', ...
            i_split, n_train, 100*(1-error(i_split, i_train)));
       K=K+1;
    end
end

%% averaged performance
perf = 100*(1-mean(error));
perf_std = 100*std(error);

for i_train = 1:numel(grid_train)
    fprintf('%s %s with %2d training : %.2f += %.2f \n', ...
        db_name, feature_name, grid_train(i_train), perf(i_train), perf_std(i_train));
end

end

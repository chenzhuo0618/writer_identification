% affine_train: Train an affine space classifier.
% Usage
%    model = affine_train(db, train_set, options)
% Input
%    db: The database containing the feature vector.
%    train_set: The object indices of the training instances.
%    options: The training options. options.dim specifies the dimensionality
%        of the affine spaces modeling each class.
% Output
%    model: The affine space model.

function model = affine_train(db,train_set,opt,K,V)
	if nargin < 3
		opt = struct();
	end
	
	opt = fill_struct(opt,'dim',80);
	
	train_mask = ismember(1:length(db.src.objects),train_set);
% 
    XX=db.features(:,train_set)';
    St = cov(XX);
    [labelsize, nFea]=size(XX);	
%     labels=sort(randperm(labelsize));
%     Sw1 = zeros(nFea, nFea);
% 
% 	for k = 1:length(db.src.classes)
% 		ind_obj = find([db.src.objects.class]==k&train_mask);
% 		
% 		if length(ind_obj) == 0
% 			continue;
% 		end
% 		
% 		ind_feat = [db.indices{ind_obj}];
% 		
% % 		mu{k} = sig_mean(db.features(:,ind_feat));
%         
% %         x=db.features(:,ind_feat);
%           x=double(db.features(:,ind_feat))';
% %         A=sig_pca(x,0);
% % 		if size(A,2) > max(opt.dim)
% % 			A = A(:,1:max(opt.dim));
% % 		end   
% %         Q = orth(x');      
% %         A = x*Q;
% %         s = size(x);
% %         s = max(s(1),s(2));
% %         lambda = 1./sqrt(s);
% %         [Z,E] = lrra(x,A,lambda);
% %         v{k}=Z;
% %         As{k}=A;
%         %%calc sb
% 
% 		C = cov(x);
% 		p = size(x, 1) / (labelsize - 1);
% 		Sw1 = Sw1 + (p * C);
%     end
%    Sb=St-Sw1;
%    Sb(isnan(Sb)) = 0; 
%    Sb(isinf(Sb)) = 0; 

   for k = 1:length(db.src.classes)
		ind_obj = find([db.src.objects.class]==k&train_mask);
		
		if length(ind_obj) == 0
			continue;
		end
		
		ind_feat = [db.indices{ind_obj}];
		
		mu{k} = sig_mean(db.features(:,ind_feat));
        
%         x=db.features(:,ind_feat);
         x=double(db.features(:,ind_feat));

%         A=sig_pca(x,0);
% 		if size(A,2) > max(opt.dim)
% 			A = A(:,1:max(opt.dim));
% 		end   
%         Q = orth(x');      
%         A = x*Q;
%         s = size(x);
%         s = max(s(1),s(2));
%         lambda = 1./sqrt(s);
%         [Z,E] = lrra(x,A,lambda);
%         v{k}=Z;
        
%       As{k}=A;        
%       v{k}=x;
%       v{k}=x;
    mean_x = mean(x, 1);
	X = bsxfun(@minus, x, mean_x);    
        [mappedA, mapping]=compute_mapping(X,'KPCA',size(X,2),'gauss',K,V);
%         s = size(x);
%         s = max(s(1),s(2));
%         lambda = 1./sqrt(s);
%         tol = 1e-7; % for ALM
%         maxIter = 10000; % for ALM
%         [A_hat E_hat iter] = inexact_alm_rpca(single(x), lambda, tol, maxIter);
% % %         
% % %     [s,ind]=sort(diag(A_hat),'descend');     
%        v{k}=A_hat;
%         
% 		v{k} = sig_pca(x,0);
%         v{k}=rand(109,8);

%calc sb%%%%%%
%         x=double(db.features(:,ind_feat))';
%         [nFea,nClass]=size(x);
%         sw=zeros(nFea,nFea);
%         
% 		C = cov(x);
% 		p = size(x, 1) / (labelsize - 1);
% 		Sw = (p * C);
%         [M, lambda] = eig(Sw);
% 		[s,ind] = sort(diag(lambda),'descend');
% 		M = M(:,ind);
%         v{k}=M;
% Truncate principal components if they exceed the maximum dimension.
% 		if size(v{k},2) > max(opt.dim)
% 			v{k} = v{k}(:,1:max(opt.dim));
% 		end
%%%%
% 		v{k} = sig_pca(db.features(:,ind_feat),0);
        v{k} = mapping.V;
%         v{k} = mapping.M;
		if size(v{k},2) > max(opt.dim)
			v{k} = v{k}(:,1:max(opt.dim));
		end
	end
	
	model.model_type = 'affine';
	model.dim = opt.dim;
	model.mu = mu;
	model.v = v;
%     model.As=As;
end

function mu = sig_mean(x)
    C = size(x,2);
    
    mu = x*ones(C,1)/C;
end

function [u,s] = sig_pca(x,M)
	if nargin > 1 && M > 0
	    [u,s,v] = svds(x-sig_mean(x)*ones(1,size(x,2)),M);
	    s = abs(diag(s)/sqrt(size(x,2)-1)).^2;
	else
		[u,d] = eig(cov(x'));
        
%         s = size(x);
%         s = max(s(1),s(2));
%         lambda = 1./sqrt(s);
%         tol = 1e-7; % for ALM
%         maxIter = 1000; % for ALM
%         [A_hat E_hat iter] = inexact_alm_rpca(single(x), lambda, tol, maxIter);
%         [s,ind]=sort(diag(A_hat),'descend');
        
		[s,ind] = sort(diag(d),'descend');
		u = u(:,ind);
	end
end
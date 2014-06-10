% AFFINE_TRAIN Train an affine space classifier
%
% Usage
%    model = AFFINE_TRAIN(db, train_set, options)
%
% Input
%    db (struct): The database containing the feature vector.
%    train_set (int): The object indices of the training instances.
%    options (struct): The training options. options.dim specifies the dimen-
%        sionality of the affine spaces modeling each class.
%
% Output
%    model: The affine space model.
%
% See also
%    AFFINE_TEST, AFFINE_PARAM_SEARCH

function model = affine_train_writers(db,train_length,opt)
	if nargin < 3
		opt = struct();
	end
	
	% Set default options.
	opt = fill_struct(opt,'dim',train_length);
	
	% Create mask to separate the training vectors
	
	for k = 0:length(db.src.classes)-1
		
		% Calculate centroid and all the principal components.
		mu{k+1} = sig_mean(db.features(:,1+k*train_length:train_length*(k+1)));
		v{k+1} = sig_pca(db.features(:,1+k*train_length:train_length*(k+1)),0);

		% Truncate principal components if they exceed the maximum dimension.
		if size(v{k+1},2) > max(opt.dim)
			v{k+1} = v{k+1}(:,1:max(opt.dim));
		end
	end
	
	% Prepare output.
	model.model_type = 'affine';
	model.dim = opt.dim;
	model.mu = mu;
	model.v = v;
end

function mu = sig_mean(x)
	% Calculate mean along second dimension.

    C = size(x,2);
    
    mu = x*ones(C,1)/C;
end

function [u,s] = sig_pca(x,M)
	% Calculate the principal components of x along the second dimension.

	if nargin > 1 && M > 0
		% If M is non-zero, calculate the first M principal components.
	    [u,s,v] = svds(x-sig_mean(x)*ones(1,size(x,2)),M);
	    s = abs(diag(s)/sqrt(size(x,2)-1)).^2;
	else
		% Otherwise, calculate all the principal components.
		[u,d] = eig(cov(x'));
		[s,ind] = sort(diag(d),'descend');
		u = u(:,ind);
	end
end

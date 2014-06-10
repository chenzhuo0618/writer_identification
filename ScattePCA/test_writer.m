function [feature_label]=test_writer(modelfile,train_length,testimg)
model=load(modelfile);
options.J = 3; % number of octaves
options.Q = 1; % number of scales per octave
options.M = 2; % scattering orders
fmt = 'table';
M = options.M;

% build the wavelet transform operators for scattering
Wop = wavelet_factory_3d_pyramid(options, options, options);
% a function handle that compute scattering given an image
                        
% fun = @(Sx)(mean(mean(log(format_scat(Sx,fmt,M)),2),3));

x=imreadBW(testimg);
trans_scatt_all=scat(x,Wop);
fun = @(Sx)(mean(mean(log(format_scat(Sx,fmt,M)),2),3));
roto_trans_scatt_log_scale_avg = fun(trans_scatt_all);
[feature_label,feature_err] = select_class(roto_trans_scatt_log_scale_avg,model.mu,model.v,model.dim);
end

function [d,err] = select_class(t,mu,v,dim)
	L = length(dim);	% number of dimensions
	D = length(mu);		% number of classes
	P = size(t,2);		% number of feature vectors

	% Prepare approximation error vector. First index is the dimension of the
	% approximating affine space, second index that of the feature vectors
	% and third index is that of the approximating class.
	err = Inf*ones(max(dim)+1,P,D);
	for d = 1:D
		if isempty(mu{d})
			% Class has no model, skip.
			continue;
		end
		% Store approximation errors for all feature vectors with class d.
		err(1:size(v{d},2)+1,:,d) = approx(t,mu{d},v{d});
	end
	
	% Only store the approximating dimensions specified in dim.
	err = err(dim+1,:,:);
	
	% Calculate the class of each feature vector as the one minimizing error.
	[temp,d] = min(err,[],3);
end

function err = approx(s,mu,v)
	% Subtract the class centroid.
	s = bsxfun(@minus,s,mu);
	% Prepare the error matrix.
	err = zeros(size(v,2)+1,size(s,2));

	% Use Pythagoras to calculate the norm of the orthogonal projection at each
	% approximating dimension.
	err(1,:) = sum(abs(s).^2,1);
	err(2:end,:) = -abs(v'*s).^2;
	err = sqrt(cumsum(err,1));
end

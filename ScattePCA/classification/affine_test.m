% affine_test: Calculate labels for an affine space model.
% Usage
%    [labels, err, feature_err] = affine_test(db, model, test_set)
% Input
%    db: The database containing the feature vector.
%    model: The affine space model obtained from affine_train.
%    test_set: The object indices of the testing instances.
% Output
%    labels: The assigned labels.
%    err: The average approximation error for each testing instance and
%       class pair.
%    feature_err: The approximation error for each feature vector and class
%       pair.

function [labels,err,feature_err] = affine_test(db,model,test_set)
	test_mask = ismember(1:length(db.src.objects),test_set);
	
	ind_obj = find(test_mask);
	
	ind_feat = [db.indices{ind_obj}];
	
% 	[feature_labels,feature_err] = select_class(...
% 		db.features(:,ind_feat),model.mu,model.v,model.dim,model.As);
	[feature_labels,feature_err] = select_class(...
		db.features(:,ind_feat),model.mu,model.v,model.dim,{});		
	err = zeros(...
		[size(feature_err,1),length(ind_obj),size(feature_err,3)]);
	labels = zeros(size(feature_err,1),length(ind_obj));
		
	for l = 1:length(ind_obj)
		ind = find(ismember(ind_feat,db.indices{ind_obj(l)}));
		
		err(:,l,:) = mean(feature_err(:,ind,:),2);
		
		[temp,labels(:,l)] = min(err(:,l,:),[],3);
	end
end

function [d,err] = select_class(t,mu,v,dim,As)
	L = length(dim);	% number of dimensions
	D = length(mu);		% number of classes
	P = size(t,2);		% number of feature vectors

	err = Inf*ones(max(dim)+1,P,D);
	for d = 1:D
		if isempty(mu{d})
			continue;
		end
% 		err(1:size(v{d},2)+1,:,d) = approx(t,mu{d},v{d},As{d});
        err(1:size(v{d},2)+1,:,d) = approx(t,mu{d},v{d},{});

	end
	
	err = err(dim+1,:,:);
	
	[temp,d] = min(err,[],3);
end

function err = approx(s,mu,v,As)
	s = bsxfun(@minus,s,mu);
	
	err = zeros(size(v,2)+1,size(s,2));
	
	err(1,:) = sum(abs(s).^2,1);
%     lambda = 1./sqrt(max(size(s)));
%     [Z,E] = lrra(s,As,lambda);
% 	err(1,:) = sum(abs(Z).^2,1);
%     c=v';
%     for i=1:size(c,1)
%         for j=1:size(s,2)
%             err(1+i,j)=sum(sum(c(i,:)-s(:,j)').^2);
%         end
%     end
    
% 	err(2:end,:) = -abs(v'*Z).^2;
    err(2:end,:) = -abs(v'*s).^2;

	err = sqrt(cumsum(err,1));
end
%#########用于进行单幅图像完全变换

function db = new_cellsrc2db(cell, src)
sz = size(cell,2);
for k=1:sz
    tmp(:,k) =cell{k}{1}; 
end
	db.src = src;
% 	db.features = cell2mat(tmp);
	db.features = tmp;
    clear tmp
	for i = 1:numel(db.features)
		db.indices{i} = i;
	end
end
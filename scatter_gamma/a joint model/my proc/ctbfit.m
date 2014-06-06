function model = ctbfit(data,varargin)
    p = inputParser;
    p.addRequired('data');
    p.addParamValue('margin','Gamma',@(x)any(strcmpi(x,{'Weibull','Gamma','Rayleigh','GGD','Cauchy'})));
    p.addParamValue('copula','Gaussian', @(x)any(strcmpi(x,{'Gaussian','t','none'})));
    p.addParamValue('debug',false,@islogical);
    p.parse(data,varargin{:});
    margintype = p.Results.margin;
    copulatype = p.Results.copula;
    debug = p.Results.debug;
    progname ='ctbfit';
    dim = size(data,2);%%%%%% 列的数目
    model = struct('inttrans',[],'margins',[],'Rho',0,'nu',0, 'emp', []);
    if (isempty(data))
        error('data is empty');
    end
%     if (debug)
%         fprintf('[%s]: fitting %s margins ...\n', progname, margintype);
%     end
    for i=1:dim
        col = data(:,i);
        switch margintype
            case 'Weibull'
                param = wblfit(col); % fit Weibull parameters estimate
                model.margins(i,:) = [param(1) param(2)];
%               wblcdf(col,param(1),param(2))%%%%%是一个列向量
                model.inttrans = [model.inttrans wblcdf(col,param(1),param(2))];
                model.emp = [model.emp empiricalCDF(col)];
            case 'Gamma'
                param = gamfit(col);
                model.margins(i,:) = [param(1) param(2)];
                model.emp = [model.emp empiricalCDF(col)];
                model.inttrans = [model.inttrans gamcdf(col,param(1),param(2))];
        end
    end
%     if (debug)
%         fprintf('[%s]: fitting %s copula\n', ...
%             progname, copulatype);
%     end
    switch(copulatype)
        case 't'
            [Rho,nu] = copulafit('t',abs(model.inttrans-eps),'Method','ApproximateML');
            model.Rho = Rho;
            model.nu = nu;
        case 'Gaussian'
%             f=find(model.inttrans==1);
%             U=model.inttrans(f)-eps;
%             model.inttrans(f)=U;
            Rho = copulafit('Gaussian',abs(model.inttrans-eps));%%%%%%% 保证U（0,1）
            %%Rho = copulafit('Gaussian',model.inttrans);    %%%%%%% 保证U（0,1）

%           Rho = copulafit('Gaussian',model.inttrans-eps);

            
            model.Rho = Rho;%%%% 为n*n=size(model.inttrans-eps,2)大小的对称矩阵，对角元为1
    end
end

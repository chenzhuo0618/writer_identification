function sample = ctbsample(model,varargin)
    p = inputParser;
    p.addRequired('model',@isstruct);
    p.addParamValue('margin','Weibull',@(x)any(strcmpi(x,{'Weibull','Gamma','Rayleigh','GGD','Cauchy'})));
    p.addParamValue('copula','Gaussian',@(x)any(strcmpi(x,{'Gaussian','t'})));
    p.addParamValue('len',100,@(x)x>0);
    p.addParamValue('debug',false,@islogical);
    p.parse(model,varargin{:});
    copulatype = p.Results.copula;
    margintype = p.Results.margin;
    len = p.Results.len;
    debug = p.Results.debug;
    progname = 'ctbsample';
%     if (debug)
%         fprintf('[%s]: generating sample from %s copula with %s margins (%d samples)\n', ...
%             progname, copulatype, margintype, len);
%     end
    sample = [];
    switch copulatype
        case 't'
            rn = copularnd('t',model.Rho,model.nu,len);
        case 'Gaussian'
            rn = copularnd('Gaussian',model.Rho,len);%%%%%大小为 len*size(model.Rho,1)=100*18
    end
    dim = size(rn,2);
%    CoreNum=4;
%if matlabpool('size')<=0  %判断并行并行计算环境是否已经启动
%    matlabpool('open','local',CoreNum);
%else
%    disp('Already initialized');
%end
    for i=1:dim
        col = rn(:,i);
        switch margintype
            case 'Weibull'
                sample(:,i) = wblinv(col,...
                    model.margins(i,1),model.margins(i,2));
            case 'Gamma'
                sample(:,i) = gaminv(col, ...
                    model.margins(i,1),model.margins(i,2));
        end
    end
% matlabpool close
end
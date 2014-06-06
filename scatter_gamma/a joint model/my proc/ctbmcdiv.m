function KL = ctbmcdiv(A,B,varargin)
p = inputParser;
p.addRequired('A',@isstruct);
p.addRequired('B',@isstruct);
p.addParamValue('margin','Weibull',@(x)any(strcmpi(x,{'Weibull','Gamma','Rayleigh','GGD','Cauchy'})));
p.addParamValue('copula','Gaussian',@(x)any(strcmpi(x,{'Gaussian','t','none'})));
p.addParamValue('len',100,@(x)x>0);
p.addParamValue('debug',false,@islogical);
p.parse(A,B,varargin{:});
copulatype = p.Results.copula;
margintype = p.Results.margin;
% margintype='Gamma'
len = p.Results.len;
debug = p.Results.debug;
progname = 'ctbmcdiv';
KL=0;
switch(copulatype)
    case 'none'
        for i =1:size(A.margins,1)
            temp=A.margins(i,:);
            alpha1=temp(1);
            beta1=temp(2);
            temp=B.margins(i,:);
            alpha2=temp(1);
            beta2=temp(2);
            switch (margintype)
                case 'Gamma'
                    KL1=psi(alpha1)*(alpha1-alpha2)-alpha1+log(gamma(alpha2)/gamma(alpha1))+alpha2*log(beta2/beta1)+alpha1*beta1/beta2;
                    KL2=psi(alpha2)*(alpha2-alpha1)-alpha2+log(gamma(alpha1)/gamma(alpha2))+alpha1*log(beta1/beta2)+alpha2*beta2/beta1;
                case 'Weibull'
                    KL1=gamma(alpha2/alpha1+1)*(beta1/beta2)^alpha2+log((beta1^(-alpha1))*alpha1)-log((beta2^(-alpha2))*alpha2)+log(beta1)*alpha1-log(beta1)*alpha2+0.577216*alpha2/alpha1-0.577216-1;
                    KL2=gamma(alpha1/alpha2+1)*(beta2/beta1)^alpha1+log((beta2^(-alpha2))*alpha2)-log((beta1^(-alpha1))*alpha1)+log(beta2)*alpha2-log(beta2)*alpha1+0.577216*alpha1/alpha2-0.577216-1;
                case 'Reighy'
                    KL1=(alpha1/alpha2)^2+2*log(alpha2/alpha1)-1;
                    KL2=(alpha2/alpha1)^2+2*log(alpha1/alpha2)-1;
            end
            KL=KL+(KL1+KL2)/2;
        end
    otherwise
        sA = ctbsample(A,'margin',margintype,'copula',copulatype,'len',len, 'debug',debug);
        sB = ctbsample(B,'margin',margintype,'copula',copulatype,'len',len, 'debug',debug);
        % %
        LL1 = ctbll(sA,A,margintype,copulatype);
        LL2 = ctbll(sA,B,margintype,copulatype);
        LL3 = ctbll(sB,A,margintype,copulatype);
        LL4 = ctbll(sB,B,margintype,copulatype);
        KL = (abs(LL1-LL2)+abs(LL4-LL3))/2;
end
%
%      if (debug)
%          fprintf('[%s]: computing MC KL approximation\n',progname);
%      end
%      sA = ctbsample(A,'margin',margintype,'copula',copulatype,'len',len, 'debug',debug);
%      sB = ctbsample(B,'margin',margintype,'copula',copulatype,'len',len, 'debug',debug);
% % %
%      LL1 = ctbll(sA,A,margintype,copulatype);
%      LL2 = ctbll(sA,B,margintype,copulatype);
%      LL3 = ctbll(sB,A,margintype,copulatype);
%      LL4 = ctbll(sB,B,margintype,copulatype);
%
%      sA = ctbsample(A,'margin',margintype,'copula',copulatype,'len',len, 'debug',debug);
%      LL1 = ctbll(sA,A,margintype,copulatype);
%      LL2 = ctbll(sA,B,margintype,copulatype);
%     if LL1<LL2
%          fprintf('KL has a - value');
%         pause;
%      end
%     KL = (LL1-LL2);
%     if LL1<LL2
%        fprintf('KL has a - value');
%          return;
%         pause;
%     end
%     KL = (abs(LL1-LL2)+abs(LL4-LL3))/2;

end

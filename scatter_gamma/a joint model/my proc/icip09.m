function varargout = icip09(src,varargin)
p = inputParser;   % inputParser:Construct input parser object 构造输入解析器对象
% p: 调用输入构造器类(inputParser)创造此类的一个实例(instance),或者曰对象(object)，是一个空的输入解析器对象
% 目的：可以存取/访问(access)此类的所有方法和属性，来解析、验证函数的输入参数
%p.addRequired('data',@iscell); % returns logical 1 (true)if data is a cell array
p.addRequired('filenames',@isstruct);
% p.addRequired(argname, validator) argname:必须的参数   validator：验证器（matlab解析验证的时候使用的句柄）
% 作用：为解析器对象p增加一个"required argument"
% If the validator function returns false or errors,the parsing fails and MATLAB throws an error.
% MATLAB parses  required arguments before optional or parameter-value arguments.
% MATLAB parses  parameter-value arguments after required arguments and optional arguments.

% model = icip09(data,'stage','genmodel','debug',true)
p.addParamValue('models',{},@iscell);
% Add parameter-value pair argument to inputParser schema
p.addParamValue('stage','genmodel',@(x)any(strcmpi(x,{'genmodel','runsim'}))); % strcmpi比较结果相同则1，any不全0则1，这个验证器为真则通过验证，否则抛出错误
% 默认选项‘genmodel’，x是输入参数，要和后面的选项进行匹配
% p.addParamValue('margin', 'Gamma', @(x)any(strcmpi(x,{'Weibull','Gamma'})));
p.addParamValue('margin', 'Weibull', @(x)any(strcmpi(x,{'Weibull','Gamma'})));
p.addParamValue('copula', 'none', @(x)any(strcmpi(x,{'Gaussian','t','none'})));
p.addParamValue('level',3,@(x)x>=1);
p.addParamValue('samples',100,@(x)x>=100);
p.addParamValue('debug',false,@islogical);

%p.parse(data,varargin{:});
p.parse(src,varargin{:});
%     %%p.parse(filenames,varargin{:});
%
debug = p.Results.debug;
models = p.Results.models;
level = p.Results.level;
samples = p.Results.samples;
stage = p.Results.stage;
margintype = p.Results.margin
copulatype = p.Results.copula;

progname ='icip09';

% %     if (debug)
%         fprintf('[%s]: running %s for %s margins and %s copula (level %d)\n', ...
%             progname, stage, margintype, copulatype, level);
%     end
% configure scattering
switch stage                 % 步骤
    case 'genmodel'          % 产生模型
        if (~isempty(models))
            error('model parameter given although stage is genmodel');
        end
        options.J = 3; % number of octaves
        options.Q = 1; % number of scales per octave
        options.M = 2; % scattering orders
        fmt = 'table';
        M = options.M;
        filt_opt=struct;
        filt_rot_opt=struct;
        scat_opt=struct;
        %     filt_opt.J = 5;
        %     filt_opt.L = 6;
        scat_opt.M=2;
        %  testt=clock;
        %  x=imreadBW(filename);
        foptions.J=3;
        foptions.L=8;
        foptions.Q=1;
        soptions.M=2;
        soptions.oversampling = 2;
        Wop=wavelet_factory_2d([512,512],foptions,soptions);
        %         Wop = wavelet_factory_3d_pyramid(filt_opt, filt_rot_opt,scat_opt);
        
        % a function handle that compute scattering given an image
        fun = @(x)(scat(x, Wop));
        
        
        
        %###############################添加多尺度
        %     multi_fun = @(filename)(fun_multiscale(fun,imreadBW(filename), 2, 3));
        %       roto_trans_scatt_multiscale = srcfun(multi_fun, src);
        % (2748 seconds on a 2.4 Ghz Intel Core i7)
        % ctbfit(abs(out),'margin', margintype, 'copula',copulatype,'debug',debug);
        model = new_srcfun(fun, src,fmt,M,margintype,copulatype,debug);%%%去掉了多尺度
        varargout={model}
        %    db = new_cellsrc2db(roto_trans_scatt_multiscale_log_sp_avg, src);
        
        %            k=1;%%%%%%% k=i*j,记录所有图像数。
        %             for i=1:size(filenames,2)
        %                  for j=1:size(filenames{i},2)
        %                         %%in=double(data{i}{j});
        %                         filename=filenames{i}{j};
        %                         %%X=ownscat(filename,options);
        %                        %% X=newscat(filename,options);
        %                         %%X=double(X);
        %                         %%fun = @(Sx)(mean(mean((remove_margin(format_scat(Sx),1)),2),3));
        %                         %%X=fun(X_all);
        %                         %%X=double(X);
        %            %     %     X=scatt_copula(in,options);
        %            %           if k==3
        %            %                 k;
        %            %                 model{k} = ctbfit(abs(X{M+1}),'margin', margintype, 'copula',copulatype,'debug',debug);
        %            %             end
        %            %
        %            %            X = abs(scatt(in,options));
        %            %            X = ctbgen(data{i}{j},'margin',margintype,...
        %            %            'levels',level,'debug',debug);                                                     %%彩色copula
        %            %            model{k} = ctbfit(abs(X{M}),'margin', margintype, 'copula',copulatype,'debug',debug);
        %                          foptions.J=2;
        %                          foptions.L=4;
        %                          soptions.M=2;
        %                          soptions.oversampling = 0;
        %                          testt=clock;
        %                          x=imreadBW(filename);
        %                          %Wop=wavelet_factory_2d(size(x),foptions,soptions);
        %                          filt_opt = struct;
        %
        %                          filt_rot_opt = struct;
        %                          % oversampling must be set to infty
        %                          % so that scattering of original and rotated
        %                          % image will be sampled at exactly the same points
        %                          scat_opt = struct;
        %
        %                          %Wop = wavelet_factory_3d(size(x), filt_opt, filt_rot_opt, scat_opt);
        %                          Wop=wavelet_factory_3d_pyramid();
        %                          trans_scatt_all=scat(x,Wop);
        %                          %[x1,x2]=scat(x,Wop);
        %                          clear x;
        %                          clear Wop;
        %
        % %                          fun = @(Sx)(mean(log(format_scat(Sx)),3));
        % %                          trans_scatt = fun(trans_scatt_all);
        %
        %                          f_fun = @(Sx)(mean(mean(log(format_scat(Sx,fmt,M)),2),3));
        %
        %                          SS=size(trans_scatt_all{3}.signal);
        %                          out=[];
        %                          for ss=1:SS(2)
        %                              out = [out double(trans_scatt_all{3}.signal{ss}(:))];
        %                          end
        %                          clear trans_scatt_all;
        %               %        varmodel{k} = ctbfit(abs(X{M+1}),'margin', margintype, 'copula',copulatype,'debug',debug);
        %                       varmodel{k} = ctbfit(abs(double(out)),'margin', margintype, 'copula',copulatype,'debug',debug);
        %                       clear out;
        %                       c_test=etime(clock,testt);
        %                       k=k+1;
        %                 end
        %
        %             end
        % 输出参数的个数（变长）
    case 'runsim'             % 运行相似度度量
        for i=1:size(models,2)
            for j=1:i
                div(i,j) = ctbmcdiv(models{i},models{j},...
                    'margin',margintype, ...
                    'copula',copulatype,'len',samples,'debug',debug);  % Gaussian
                %
                %                      div(i,j) = ctbmcdiv(models{i},models{j},...
                %                         'margin','Weibull', ...
                %                         'copula','Gaussian','len',samples,'debug',debug);
                %                     if div(i,j)<0
                %                         fprintf('distance has a -value');
                %                         pause;
                %                     end
                
            end
        end
        varargout(1) = {div};
end
end



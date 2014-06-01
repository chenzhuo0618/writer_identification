function data = ctbgen(image,varargin)
    p = inputParser;
    p.addRequired('image',@(x)~isempty(x));
    p.addParamValue('margin','Weibull',@(x)any(strcmpi(x,{'Weibull','Gamma','Rayleigh','GGD','Cauchy'})));
    p.addParamValue('levels',3,@(x)x>=1 && x <= 5);
    p.addParamValue('debug',false,@islogical);
    p.parse(image,varargin{:});
    type = p.Results.margin;
    levels = p.Results.levels;
    debug = p.Results.debug;
    dim = size(image,3);%%%%  颜色通道为3
    progname ='ctbgen';
%     if (debug)
%         fprintf('[%s]: margin = %s, levels = %d\n', progname, type,levels);
%     end

%   data=gabortransform(image,options);

    
    
 
%%%%%%%%%%%%  默认程序    
for i=1:dim
		plane = double(image(:,:,i));%%%%读取每个通道尺度的图像数据
       plane = (plane - mean2(plane)./std2(plane));    
        switch type
            case {'Weibull','Gamma','Rayleigh'}
                [Yl,Yh] = dtwavexfm2(plane,levels,'near_sym_b','qshift_b');
                channels{i}.Yl = Yl;
                channels{i}.Yh = Yh;                
                
            case {'ggd','cauchy'}
                [c,s] = wavedec2(plane,levels,'bior4.4');
                channels{i}.c = c;
                channels{i}.s = s;
        end
end
    
    for l=1:levels%%%%% 每个分解层，6个方向，每个方向，3个尺度（颜色通道）
        data{l} = [];%%%%新定义的变量，与前面提取出的data{}不同
        switch type
            case {'Weibull','Gamma','Rayleigh'}
                for or=1:6%%%%%%Yh每层包含6个复高通子图,即6个方向
                    for ch =1:dim %%%颜色通道
                        coef = abs(channels{ch}.Yh{l}(:,:,or));%%% 颜色通道-分解层-方向数
                        coef = coef(:)+eps;%%%%%% 为列向量
                        data{l} = [data{l} coef];
                    end
                end
            case {'ggd','cauchy'}
                for ch=1:dim
                    [H,V,D] = detcoef2('all',channels{ch}.c,channels{ch}.s,l);
                    data{l} = [data{l} H(:) V(:) D(:)];
                end
        end
    end
end






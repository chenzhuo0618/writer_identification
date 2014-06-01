function data = texload(dbname,dirname,nsubs,texfrom,texto)
% dirname: 存放分割好的子图的根目录，要能直接读取到诸如Bark.0000.01.tif
% 'D:\A Joint Model of Complex Wavelet Coefficients for Texture Retrieval\program\my proc\imgs\'
% dbname： 要调用的函数的名字：vistex.m (不区分大小写，case non-sensitive)
% nsubs：每幅纹理图分割的子图数目
% texfrom,texto：依次读取的纹理次序，多少个待处理纹理:1:40

    data = {};   % 空的cell
    name = eval(dbname);  % 调用：function name = VisTex,是40*1的cell
    ntexs = length(name); % 待处理的纹理个数，40
    cnt = 1;
    fprintf('loading %d textures\n', (texto-texfrom+1)*nsubs); % 默认输出到屏幕
    for p = texfrom:texto   
        if p > ntexs
            break
        end
        for q= 1:nsubs   %每幅纹理做16次，16幅子图
             file = sprintf('%s/%s.%02d.gif', dirname, name{p}, q);  
%             file = sprintf('%s/%s.%02d.tif', dirname, name{p}, q);  
            % name{1}:  Bark.0000
            
            data{cnt}.image = imread(file);
            data{cnt}.dim = size(data{cnt}.image,3); % size运算后的第三个数字是维度
            data{cnt}.idx = p;   
            data{cnt}.filename = sprintf('%s.%02d',name{p},q);  % 子图名字： Bark.0000.01
            cnt = cnt + 1;
        end
    end
    fprintf('read %d images.\n',cnt-1);
    % my add code for storage the result of this file
    % vistex_data = strcat('D:\A Joint Model of Complex Wavelet Coefficients for Texture Retrieval\program\my proc\Data');
    % save(vistex_data,'data');
end

%% 得到的结果：data
% data{1}:
%       image: [128x128x3 uint8]
%         dim: 3
%         idx: 1                      所属纹理编号
%    filename: 'Bark.0000.01'

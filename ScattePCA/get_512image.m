clc
clear
cd('D:\cyi\scatnet-0.2\Í¼Ïñ¿â\handwritng_all');
files = dir();
sz = size(files,1);
savepath = 'C:\Users\ch\Desktop\512ÊÖÐ´ÌåÍ¼Ïñ¿â\'
for i=3:sz
    if(files(i).isdir == true)
        insides = dir(files(i).name);
        in_sz = size(insides);
        for j=3:in_sz
            name = insides(j).name;
            if(name(7) == '2')
            image = imread(name);
            spath = strcat(savepath,num2str(i-2),'\',name);
            imwrite(image,spath);
            end         
        end
    end
end

clc
clear
cd('D:\cyi\scatnet-0.2\图像库\512手写体图像库');
files = dir();
sz = size(files,1);
savepath = 'C:\Users\ch\Desktop\tmp\'
for i=3:sz 
    
    
    dirname=['C:\Users\ch\Desktop\tmp\' files(i).name];%新的文件夹名
    a=['mkdir ' dirname];%创建命令
    system(a) %创建文件夹
    
   
        insides = dir(files(i).name);
        in_sz = size(insides);
        
           
            
        for j=3:in_sz
            name = insides(j).name;
            image = imread(name);
            spath = strcat(savepath,files(i).name,'\',name);
            imwrite(image,spath);
            
            image1 = imresize(image,[128 128]);
            name(7) = '0';
            newname1 = name;
            spath = strcat(savepath,files(i).name,'\',newname1);
            imwrite(image1,spath);
            
            image2 = imresize(image,[256 256]);
            name(7) = '1';
            newname2 = name;
            spath = strcat(savepath,files(i).name,'\',newname2);
            imwrite(image2,spath);
              
        end
end

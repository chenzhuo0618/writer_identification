function filenames= retrieve_writing_Ltrain(classes)
%train=cell(1,classes);
filenames=cell(1,classes);
%%startmatlabpool;
cd('D:\2_26\dataset\tmp3');
files=dir('D:\2_26\dataset\tmp3\*.bmp');
filesize=size(files,1);
for i=1:length(files)
    %if count>classes
    %    break;
    %end
    filename=files(i).name;
    realfilename=['D:\2_26\dataset\tmp3\',filename];    
    temp=double(imread(realfilename));
    if size(temp,3)==3
        temp=rgb2gray(temp);
    end
    temp= double(temp);
    %%temp = temp - mean(temp(:));
    %%temp = temp / norm(temp(:));
    %%train{eval(filename(2:3))}=[train{eval(filename(2:3))} {temp}];
    filenames{eval(filename(2:3))}=[filenames{eval(filename(2:3))} {filename}];
    %train{count}{k} = temp;
    %k=k+1;
    %if mod(k,41)==0
    %    count =count+1;
    %    k = 1;
    %end
end
end
               


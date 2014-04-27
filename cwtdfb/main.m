tic;
%pdata_path='D:\zhubeibei\practiceimagebase';
classnum=50;

%朱贝贝的库
%pdata_path='C:\Program Files\MATLAB\R2012b\bin\workplace\zbb\practiceimagebase';
%tdata_path='C:\Program Files\MATLAB\R2012b\bin\workplace\zbb\testimagebase';
%pdata_path='D:\picturelibrary\handwriting\practiceimagebase';%cut库
%tdata_path='D:\picturelibrary\handwriting\testimagebase';%cut库
%预处理库（曹海的库）
%pdata_path='D:\picturelibrary\caohai\practiceimagebase';
%tdata_path='D:\picturelibrary\caohai\testimagebase';
%曹海哥轻度
%pdata_path='D:\picturelibrary\caohai\writing\writing\轻度\practiceimagebase';%cut库
%tdata_path='D:\picturelibrary\caohai\writing\writing\轻度\testimagebase';%cut库
%曹海哥正常
pdata_path='D:\picturelibrary\caohai\writing\writing\正常\practiceimagebase';%cut库
tdata_path='D:\picturelibrary\caohai\writing\writing\正常\testimagebase';%cut库
%曹海哥重度
%pdata_path='D:\picturelibrary\caohai\writing\writing\重度\seprate\practiceimagebase';%cut库
%tdata_path='D:\picturelibrary\caohai\writing\writing\重度\seprate\testimagebase';%cut库

%获取训练样本的类特征
FeatureTrainMatrix=[];

for classid=1:classnum
    
    if(classid<10)
        class_name=strcat(pdata_path,'\g0',num2str(classid));
        ClassFeatureMatrix=GainTrainImageFeature(class_name);
    else
        class_name=strcat(pdata_path,'\g',num2str(classid));
        ClassFeatureMatrix=GainTrainImageFeature(class_name);
    end 
    FeatureTrainMatrix=[FeatureTrainMatrix,ClassFeatureMatrix];
end

%tdata_path='D:\zhubeibei\testimagebase';

%获取测试样本所有的图像特征
FeatureMatrix=[];

for classid=1:classnum
    if(classid<10)
        class_name=strcat(tdata_path,'\g0',num2str(classid));
        ClassFeatureMatrix=GainImageFeatureArr(class_name,classid);
    else
        class_name=strcat(tdata_path,'\g',num2str(classid));
        ClassFeatureMatrix=GainImageFeatureArr(class_name,classid);
    end 
    FeatureMatrix=[FeatureMatrix;ClassFeatureMatrix];
end

%%subband KL distance array
subimagenum=classnum*20;

for i=1:classnum
    for j=1:subimagenum     
        KLMarrtrix(i,j).kld=sub_kld_measure(FeatureTrainMatrix(:,i),FeatureMatrix(j,1).featurevocter);
        KLMarrtrix(i,j).cid=FeatureMatrix(j,1).classid;
    end
end

%normal the subband kl distance array

NorKLMarrtrix=normal_subkld_marrtrix(KLMarrtrix);

%%statetic the all sub kl distance 
[m,n]=size(NorKLMarrtrix);
[msize,nsize]=size(NorKLMarrtrix(1,1).kld);
for i=1:m
    for j=1:n
        KLDArray(i,j).kld=0;
        KLDArray(i,j).classid=0;
    end
end

for i=1:m
    for j=1:n
        for k=1:nsize
             KLDArray(i,j).kld=KLDArray(i,j).kld+NorKLMarrtrix(i,j).kld(k);
        end
        KLDArray(i,j).classid=NorKLMarrtrix(i,j).cid;
    end
end

%%sort the the kl distance between two images
SortingResult=sort_KLDvalue(KLDArray);

%%compute the average retrieval rate
[AverRetrievalRate1,RR1]=Gain_AverageRetrievalRate(SortingResult)
toc;

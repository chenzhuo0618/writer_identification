%%function Gain the texture feature of image by pdwt
function ImageFeatureMatrix=GainImageFeature(class_name,type)

    FeatureMatrix=[];
 
for ImageDataId=1:20
    if(ImageDataId<10)
        data_name=strcat(class_name,'010',num2str(ImageDataId),'.mat');
    else
        data_name=strcat(class_name,'01',num2str(ImageDataId),'.mat');
    end
    temp=load(data_name);
    imagedata=temp.mm;
    %%imagedata=double(temp(1).heavy1);
    featurevocter=PDTDFB_extra_texture_feature(imagedata);
    FeatureMatrix=[FeatureMatrix,featurevocter];
    if(ImageDataId<10)
        data_name=strcat(class_name,'020',num2str(ImageDataId),'.mat');
    else
        data_name=strcat(class_name,'02',num2str(ImageDataId),'.mat');
    end
    temp=load(data_name);
    imagedata=temp.A;
    %%imagedata=double(temp(1).heavy1);
    featurevocter=PDTDFB_extra_texture_feature(imagedata);
    FeatureMatrix=[FeatureMatrix,featurevocter];

end 

classvector=[];
[msize,nsize]=size(FeatureMatrix);
for i=1:msize
   classvector=[classvector;mean(FeatureMatrix(i,:))];
end

ImageFeatureMatrix=classvector;

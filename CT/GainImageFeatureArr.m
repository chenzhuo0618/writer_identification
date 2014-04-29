%%function Gain the texture feature of image by pdwt
function ImageFeatureMatrix=GainImageFeatureArr(class_name,classid)

ImageFeatureMatrix=[];

for ImageDataId=1:20
    if(ImageDataId<10)
        data_name=strcat(class_name,'020',num2str(ImageDataId),'.mat');
    else
        data_name=strcat(class_name,'02',num2str(ImageDataId),'.mat');
    end
   
    temp=load(data_name);
    
    imagedata=temp.A;
%   im=imresize(imagedata,0.25);    
    imagefeature.featurevocter=CT_Extra_Feature(imagedata);
    imagefeature.classid=classid;
    ImageFeatureMatrix=[ImageFeatureMatrix;imagefeature];
end 

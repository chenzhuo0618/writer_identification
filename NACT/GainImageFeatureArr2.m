%%function Gain the texture feature of image by pdwt
function ImageFeatureMatrix=GainImageFeatureArr2(class_name,classid)

ImageFeatureMatrix=[];
filenames = retrieve_writing_Ltrain(number,maxclasses);
for i=1:size(filenames,2)
    feature=[];
    for j=1:size(filenames{i},2)
        filename=filenames{i}{j};
        foptions.J=2;
        foptions.L=4;
        soptions.M=2;
        soptions.oversampling = 0;
        testt=clock;
        x=imreadBW(filename);
        Wop=wavelet_factory_2d(size(x),foptions,soptions);
        trans_scatt_all=scat(x,Wop);
        clear x;
        clear Wop;          
        fun = @(Sx)(mean(mean(remove_margin(format_scat(Sx),1),2),3));
        trans_scatt = fun(trans_scatt_all);
        [alpha,beta]=gamfit(trans_scatt);
        feature=[feature;alpha;beta];
    end
    imagefeature.featurevocter=feature;
    imagefeature.classid=i;
    ImageFeatureMatrix=[ImageFeatureMatrix;imagefeature];
end
for ImageDataId=1:20
    if(ImageDataId<10)
        data_name=strcat(class_name,'020',num2str(ImageDataId),'.mat');
    else
        data_name=strcat(class_name,'02',num2str(ImageDataId),'.mat');
    end
   
    temp=load(data_name);
    imagedata=temp.A;
    
    imagefeature.featurevocter=ContourletSDD_Extra_Feature(imagedata);
    imagefeature.classid=classid;
    ImageFeatureMatrix=[ImageFeatureMatrix;imagefeature];
end 

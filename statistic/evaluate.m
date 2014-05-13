data_path='E:\4_30\data\one\÷ÿ∂»Òﬁ÷Â\mat';%cutø‚
FeatureTrainMatrix=[];
type='pdtdfb';
%type='nact' or 'ct' or 'nsct' or 'shearlet' and others
classid=1;
if(classid<10)
    class_name=strcat(data_path,'\g0',num2str(classid));
    ClassFeatureMatrix=GainImageFeature(class_name,type)
else
    class_name=strcat(data_path,'\g',num2str(classid));
    ClassFeatureMatrix=GainImageFeature(class_name,type);
end 

[msize,nsize]=size(ClassFeatureMatrix)
%mean
meanalpha=mean(ClassFeatureMatrix(1:2:msize))
meanbeta=mean(ClassFeatureMatrix(2:2:msize))
%var
varalpha=var(ClassFeatureMatrix(1:2:msize))
varbeta=var(ClassFeatureMatrix(2:2:msize))



ImageFeatureMatrix=[];
maxclasses=2;
filenames = retrieve_writing_Ltrain(maxclasses);
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
classnum=2;
subimagenum=classnum*6;

for i=1:classnum
    for j=1:subimagenum     
        KLMarrtrix(i,j).kld=sub_kld_measure(FeatureTrainMatrix(:,i),FeatureMatrix(j,1).featurevocter);
        KLMarrtrix(i,j).cid=FeatureMatrix(j,1).classid;
    end
end


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

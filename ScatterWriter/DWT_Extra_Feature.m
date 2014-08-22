%function Extra the image feature by DWT
function imagefeature=DWT_Extra_Feature(imagedata)

imagedata=double(imagedata);
feature=[];

%%%GDD model extra the feature of high frequency
[CA1,CH1,CV1,CD1]=dwt2(imagedata,'db2');
[CA2,CH2,CV2,CD2]=dwt2(CA1,'db2');
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%[CA3,CH3,CV3,CD3]=dwt2(CA2,'db2');%3级分解时需要

[msize,nsize]=size(CA1);
sh=[];sv=[];sd=[];

for i=1:nsize
    sh=[sh;CH1(:,i)];
    sv=[sv;CV1(:,i)];
    sd=[sd;CD1(:,i)];
end
[alpha,beta]=ggmle(sh);feature=[feature;alpha;beta];
[alpha,beta]=ggmle(sv);feature=[feature;alpha;beta];
[alpha,beta]=ggmle(sd);feature=[feature;alpha;beta];

[msize,nsize]=size(CA2);
sh=[];sv=[];sd=[];
for i=1:nsize
    sh=[sh;CH2(:,i)];
    sv=[sv;CV2(:,i)];
    sd=[sd;CD2(:,i)];
end
[alpha,beta]=ggmle(sh);feature=[feature;alpha;beta];
[alpha,beta]=ggmle(sv);feature=[feature;alpha;beta];
[alpha,beta]=ggmle(sd);feature=[feature;alpha;beta];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3 级分解时需要
%%%[msize,nsize]=size(CA3);
%%%sh=[];sv=[];sd=[];

%%%for i=1:nsize
%%%    sh=[sh;CH3(:,i)];
%%%    sv=[sv;CV3(:,i)];
%%%    sd=[sd;CD3(:,i)];
%%%%end
%%%%[alpha,beta]=ggmle(sh);feature=[feature;alpha;beta];
%%%%[alpha,beta]=ggmle(sv);feature=[feature;alpha;beta];
%%%%[alpha,beta]=ggmle(sd);feature=[feature;alpha;beta];
%%%%%%%%%%%%%%%
imagefeature=feature;


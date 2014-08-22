%function Extra the image feature by DWT
function imagefeature=Scatter_Extra_Feature(imagedata)

imagedata=double(imagedata);
feature=[];
        if (~isempty(models))
            error('model parameter given although stage is genmodel');
        end
        options.J = 3; % number of octaves
        options.Q = 1; % number of scales per octave
        options.M = 2; % scattering orders
        fmt = 'table';
        M = options.M;
        filt_opt=struct;
        filt_rot_opt=struct;
        scat_opt=struct;
        %     filt_opt.J = 5;
        %     filt_opt.L = 6;
        scat_opt.M=2;
        %  testt=clock;
        %  x=imreadBW(filename);
        foptions.J=3;
        foptions.L=4;
        foptions.Q=1;
        soptions.M=2;
%       soptions.J=3;
        soptions.oversampling = 2;
        
        Wop=wavelet_factory_3d([526 526],foptions,soptions);
        fun = @(x)(scat(x, Wop));     
        

        
param = wblfit(col+eps);



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


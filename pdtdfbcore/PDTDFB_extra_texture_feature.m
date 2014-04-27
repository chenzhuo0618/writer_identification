%extract the feature of the subimage
function  imagefeature=PDTDFB_extra_texture_feature(image)

x=double(image);
dfilt = 'meyer';
pfilt = 'nalias';
wfame='db5';
nlevs=[2,3,4];
res=0;
feature=[];

 y = pdtdfbdec(x, nlevs, pfilt, dfilt, wfame, res);
 
 for i=2:(length(nlevs)+1)
     real=y{1,i}{1,1};
     imag=y{1,i}{1,2};
    for j=1:length(real)
        b=real{1,j};
        [m,n]=size(b);
        c=reshape(b,m*n,1);
        [alpha,beta]=ggmle(c);
        feature=[feature;alpha;beta];
    end
    for j=1:length(imag)
        b=imag{1,j};
        [m,n]=size(b);
        c=reshape(b,m*n,1);
        [alpha,beta]=ggmle(c);
        feature=[feature;alpha;beta];
    end
 end
 imagefeature=feature;
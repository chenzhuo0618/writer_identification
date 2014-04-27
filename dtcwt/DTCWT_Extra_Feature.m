%function Extra the image feature by DWT
function imagefeature=DTCWT_Extra_Feature(imagedata,nlevel)

imagedata=double(imagedata);
s=[];
[Yl,Yh,Yscale] = dtwavexfm2(imagedata,nlevel,'near_sym_b','qshift_b');

 for i=1:nlevel
%     
%     [size1,size2]=size(Yh{i,1});
%     
    for j=1:6
        y1=real(Yh{i,1}(:,:,j));
        [m,n]=size(y1);
        x1=reshape(y1,m*n,1);
        [alpha,beta]=ggmle(x1);
        s=[s;alpha;beta];
        y2=imag(Yh{i,1}(:,:,j));
        [r,p]=size(y2);
        x2=reshape(y2,r*p,1);
        [alpha,beta]=ggmle(x2);
        s=[s;alpha;beta];
        
    end
end


imagefeature=s;


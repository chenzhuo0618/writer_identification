%function Extra the image feature by CT(Contourlet transform)
function imagefeature=CT_Extra_Feature(imagedata)

 pfilt='pkva';
 dfilt='pkva';
 nlevs=[2,3,4];

 x=double(imagedata);
 y=pdfbdec(x, pfilt, dfilt, nlevs);
 feature=[];
   
  for j=2:4
     xhi_dir=y{1,j};
     for k=1:length(xhi_dir)
         b=xhi_dir{1,k};
         [m,n]=size(b);
         c=reshape(b,m*n,1);
         [alpha,beta]=ggmle(c);
         feature=[feature;alpha;beta];
     end
  end

imagefeature=feature;
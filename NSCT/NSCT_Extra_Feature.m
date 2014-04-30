%function Extra the image feature by NSCT(Contourlet transform)
function imagefeature=NSCT_Extra_Feature(imagedata)
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;              % Directional filter
nlevels=[2,3,4];
y = nsctdec(double(imagedata), nlevels, dfilter, pfilter );

%  x=double(imagedata);
%  y=pdfbdec(x, pfilt, dfilt, nlevs);
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
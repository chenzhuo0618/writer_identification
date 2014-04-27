% Extra the image feature by dtcwt and DFB
function imagefeature = Cwtdf_Extra_Feature(imagedata)

 J=1;
 dfilt='pkva';
 nlevs=[2,2];

 x=double(imagedata);
 y=cwtfbdec(x, J, dfilt, nlevs);
 feature=[];
   
  for j=2:(length(nlevs)+1)
     xhi_dir=y{1,j};
     [m,n]=size(xhi_dir);
     for k=1:m
         for l=1:n
             b=xhi_dir{m,n};
             [p,q]=size(b);
             c=reshape(b,p*q,1);
             [alpha,beta]=ggmle(c);
             feature=[feature;alpha;beta]; 
        end
     end      
  end

imagefeature=feature;

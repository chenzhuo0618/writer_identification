function imagefeature=ContourletSDD_Extra_Feature(imagedata)

 dfilt = 'pkva';
 nlev_SD = [2 3 4];
 smooth_func = @rcos;
 Pyr_mode = 2; 

 x=double(imagedata);
 y = ContourletSDDec(x, nlev_SD, Pyr_mode, smooth_func, dfilt);
 feature=[];
   
  for j=2:4
     xhi_dir=y{j,1};
     for k=1:length(xhi_dir)
         b=xhi_dir{1,k};
         [m,n]=size(b);
         c=reshape(b,m*n,1);
         [alpha,beta]=ggmle(c);
         feature=[feature;alpha;beta];
     end
  end

imagefeature=feature;

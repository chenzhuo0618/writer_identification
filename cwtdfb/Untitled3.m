 J=1;

 dfilt='pkva';
 nlevels=1;
 imagedata=imread('barbara.png');
 x=double(imagedata);
 [Yl,Yh,Yscale] = dtwavexfm2(x,nlevels,'near_sym_b','qshift_b');
 
%  y=cwtfbdec(x, J, dfilt, nlevs)
%  
%  feature=[];
%    
%   for j=2:4
%      xhi_dir=y{1,j};
%      [m,n]=size(xhi_dir);
%      for k=1:m
%          for l=1:n
%              b=xhi_dir{m,n};
%              [p,q]=size(b);
%              c=reshape(b,p*q,1);
%              [alpha,beta]=ggmle(c);
%              feature=[feature;alpha;beta]; 
%         end
%      end      
%   end
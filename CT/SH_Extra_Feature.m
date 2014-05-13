function [ imagefeature ] = SH_Extract_Feature( imagedata )
%SH_EXTRACT_FEATURE Summary of this function goes here
%   Detailed explanation goes here
%  pfilt='pkva';
%  dfilt='pkva';
%  nlevs=[2,3];
[sizeX,sizeY]=size(imagedata);
useGPU=0;
 x=double(imagedata);
%  y=pdfbdec(x, pfilt, dfilt, nlevs);
system=SLgetShearletSystem2D(useGPU,sizeX,sizeY,2,[0 1 2]);
shearletCoefficients=SLsheardec2D(imagedata,system);
feature=[];
length=size(shearletCoefficients,3)-1;
for j=1:length
%     [m,n]=size(coefficients);
    coefficients=shearletCoefficients(:,:,j);
    [m,n]=size(coefficients);
    c=reshape(coefficients,m*n,1);
    [alpha,beta]=ggmle(c);
    feature=[feature;alpha;beta];
end
imagefeature=feature;
% 
%  feature=[];   
%  for j=2:3
%      xhi_dir=y{1,j};
%      for k=1:length(xhi_dir)
%          b=xhi_dir{1,k};
%          [m,n]=size(b);
%          c=reshape(b,m*n,1);
%          [alpha,beta]=ggmle(c);
%          feature=[feature;alpha;beta];
%      end
%   end
% 
% imagefeature=feature;

end


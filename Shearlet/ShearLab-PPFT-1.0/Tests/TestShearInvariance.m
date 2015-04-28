function output_TestShearInvariance=TestShearInvariance(N,R,beta,s,lfile)
%% TESTSHEARINVARIANCE Test shear invariance
%
%% Description
%  OUTPUT_TESTSHEARINVARIANCE=TESTSHEARINVARIANCE(N,R,BETA,S,LFILE)
%   compute shear invariance of shearlet coefficients
%   S: slope or shear
%
%   Save measurements M_{shear_j}
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSPEED, TESTGEOMEXACT, TESTROBUSTNESS,TESTTHRESHOLDING,SHEARLETTRANSFORM, 
% ADJSHEARLETTRANSFORM
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


fprintf(lfile, 'Test Shear Invariance: \n');
fprintf(lfile, 'N = %d, R = %d, beta = %d, slope = %.1f\n\n', N,R,beta,s);


x                = zeros(N,N);
x(N/2-0:N/2+0,:) = 1;

I = imShear(x,0);                  % an horizontal edge pass through origin.      
J = imShear(x,s);                  % an edge through origin with slope s.

pI = ppFT(I,R);
pJ = ppFT(J,R);
 
% figure(1), imshow(I);       cmap = colormap;
% figure(2), ppview(abs(pI)); colormap(cmap); 
% figure(3), imshow(J);       cmap = colormap;
% figure(4), ppview(abs(pJ)); colormap(cmap);

shxI = ShearletTransform(I,R,beta);
shxJ = ShearletTransform(J,R,beta);

JH = ceil(log2(N)/log2(beta));      
JL = -ceil(log2(R/2)/log2(beta));  % lowest possible level. if R=8 and beta=4, then JL=-1.

ML     = ceil(log2(1/abs(s)));         % 2^j*s must be an integer  
Mshear = zeros(JH-ML+1,1);

output_TestShearInvariance = zeros(JH-ML+1,2);
output_TestShearInvariance(1,1) = N;

for scale = JH:-1:ML
   Ntile = ParaScale(scale,beta);
   ss = 2^scale*s;
   
   %disp(['Scale= ' num2str(scale) '; ss = ' num2str(ss) '; Ntile=' num2str(Ntile)]);   
   for tileI = -Ntile+1:Ntile-1
         tileJ = tileI-ss;
         if tileJ > -Ntile && tileJ < Ntile
            cJ = shxJ{1,scale-JL+2,tileJ+Ntile+1}+shxJ{3,scale-JL+2,tileJ+Ntile+1};
            cI = shxI{1,scale-JL+2,tileI+Ntile+1}+shxI{3,scale-JL+2,tileI+Ntile+1};
            M1 =  norm(cI-cJ,'fro');            
            if M1 > Mshear(scale-ML+1)
                Mshear(scale-ML+1) = M1;
            end
            
            fprintf(lfile, 'log: scale = %d,\t tileI = %d, \t tileJ = %d, \t maxI = %f, \t maxJ = %f, \t maxIJ = %f\n',scale, tileI, tileJ, max(max(abs(cI))),max(max(abs(cJ))),max(max(abs(cI-cJ))));
            cJ2 = shxJ{2,scale-JL+2,tileJ+Ntile+1}+shxJ{4,scale-JL+2,tileJ+Ntile+1};
            cI2 = shxI{2,scale-JL+2,tileI+Ntile+1}+shxI{4,scale-JL+2,tileI+Ntile+1};            
%             figure(5)
%             subplot(2,2,1),imagesc(abs(cI));
%             subplot(2,2,2),imagesc(abs(cJ));
%             subplot(2,2,3),imagesc(abs(cI2));
%             subplot(2,2,4),imagesc(abs(cJ2));            
%             pause
            
         end
   end
end

fprintf(lfile,'\n');
output_TestShearInvariance(:,2) = Mshear/norm(I,'fro');

for scale = ML:JH
  fprintf(lfile,'Shear Invariance: Scale =%d, Mshear = %E\n',scale, Mshear(scale-ML+1)/norm(I,'fro'));
end

fprintf(lfile,'\n');

end
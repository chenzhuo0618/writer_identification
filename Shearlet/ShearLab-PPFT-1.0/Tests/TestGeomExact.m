function output_TestGeomExact = TestGeomExact(N,R,beta,lfile)
%% TESTGEOMEXACT Test Geometric Exactness
%
%% Description
%  OUTPUT_TESTGEOMEXACT = TESTGEOMEXACT(N,R,BETA,LFILE)
%   Save measurement M_{geo_1}, M_{geo_2}.
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSPEED, TESTSHEARINVARIANCE,TESTROBUSTNESS,TESTTHRESHOLDING,SHEARLETTRANSFORM, 
% ADJSHEARLETTRANSFORM
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
 

fprintf(lfile, 'Test Geometric Exactness: \n');
fprintf(lfile, 'N = %d, R = %d, beta = %d\n\n', N,R,beta);

output_TestGeomExact      = zeros(4,2);
output_TestGeomExact(1,1) = N;

JH = ceil(log2(N)/log2(beta));      
JL = -ceil(log2(R/2)/log2(beta));    % lowest possible level. if R=8 and beta=4, then JL=-1.
  
slope = [-1,-0.5,0,0.5,1,0.5,0,-0.5]; ksep = 4;
%slope = [-1,0,1,0]; ksep = 2;
numS        = length(slope);
mShXLine    = zeros(numS,JH);
mShXNotLine = zeros(numS,JH);

fprintf(lfile, 's=%f\n', slope);
for i = 1:numS
      x = zeros(N,N);      
      s = slope(i);
      if i > ksep
         x(N/2-0:N/2+0,:) = 1; % Edge
         I = imShear(x,s);           
      else
         x(:,N/2-0:N/2+0) = 1; % Edge 
         I = imShear(x',s);
         I = I';
      end
      %I = I(N/2+1:3*N/2,N/2+1:3*N/2);      
      %subplot(2,numS,i),
      %figure(2*i-1),imshow(I); cmap = colormap;
      %filename = ['geoExact' num2str(i) 't.eps'];
      %print('-deps',filename);
      %subplot(2,numS,i+numS),
      %figure(2*i),ppview(abs(ppFT(I))); %colormap(cmap);%colorbar off;
      %filename = ['geoExact' num2str(i) 'f.eps'];
      %print('-deps',filename);
      
      shX = ShearletTransform(I,R,beta);
      
      for scale = JH:-1:1
          Ntile = ParaScale(scale,beta);
          shear = round(-2^scale*s);
          cMax0 = 0;          
          for tile = -Ntile:Ntile
              
              cMax1 = max(max(abs(shX{1,scale-JL+2,tile+Ntile+1}+shX{3,scale-JL+2,tile+Ntile+1})));
              cMax2 = max(max(abs(shX{2,scale-JL+2,tile+Ntile+1}+shX{4,scale-JL+2,tile+Ntile+1})));
              disp(['Edge i, scale, tile, cMax1, cMax2' num2str([i,scale,tile,cMax1,cMax2])]);
              
              cMax = max(cMax1,cMax2);
              if tile == shear && i <= ksep                
                 mShXLine(i,scale) = cMax2;
              elseif tile == shear  && i > ksep
                 mShXLine(i,scale) = cMax1;
              else                 
                 if cMax > cMax0
                     cMax0 = cMax;
                 end
              end
          end
          mShXNotLine(i,scale) = cMax0;
      end
end

%mShXLine
%mShXNotLine
yDataLine    = sum(mShXLine)/numS;
yDataNotLine = sum(mShXNotLine)/numS;

sJL   = 1; 
sJH   = JH-1; % ignore the boundary shearlet coefficients
XData = [ones(sJH-sJL+1,1),(sJL:sJH)'];

Mgeo1 = XData\log2(yDataLine(sJL:sJH)');
Mgeo2 = XData\log2(yDataNotLine(sJL:sJH)');

output_TestGeomExact(2,:) = Mgeo1';
output_TestGeomExact(3,:) = Mgeo2';

fprintf(lfile,'\n');
fprintf(lfile,'Decay for Significant Coefficient Aligned with Line = %f\n',output_TestGeomExact(2,2));
fprintf(lfile,'Decay for Insignificant Coefficient = %f\n\n',output_TestGeomExact(3,2));
fprintf(lfile,'\n');
return;
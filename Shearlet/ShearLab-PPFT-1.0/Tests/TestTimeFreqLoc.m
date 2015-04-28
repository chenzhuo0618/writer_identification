function output_TestTimeFreqLoc = TestTimeFreqLoc(N,R,beta,scale,sector,shear,lfile)
%% TESTTIMEFREQLOC Time frequency localization Test.
%
%% Description
%  OUTPUT_TESTTIMEFREQLOC = TESTTIMEFREQLOC(N,R,BETA,SCALE,SECT,SHEAR,LFILE)
%   compute decay of a shearlet in time and frequency domains
%   SCALE: which level j
%   SECT : sect = 1,2,3,4
%   SHEAR: shear s = -2^{j}...2^{j}
%
%   Save measurements M_{decay_1}, M_{supp}, M_{decay_2}, M_{smooth_1},
%   and M_{smooth_2}
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, 
% TESTSHEARINVARIANCE, TESTSPEED, TESTGEOMEXACT, TESTROBUSTNESS,
% TESTTHRESHOLDING, WINDOWONPPGRID
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

fprintf(lfile, 'Test Time Frequency Localization: \n');
fprintf(lfile, 'N = %d, R = %d, beta = %d, scale = %d, sector = %d, shear = %d\n\n', N,R,beta,scale,sector,shear);

output_TestTimeFreqLoc      = zeros(6,4);
output_TestTimeFreqLoc(1,1) = N;


disp('Computing Decay in Time and Frequency Domain...');

sect          = mod(sector,2);
y             = ones(2,R*N+1,N+1);
y(1+sect,:,:) = 0;
shX           = WindowOnPPGrid(y,beta);                  % Windowing get all shearlets 

JH = ceil(log2(N)/log2(beta));                           % highest possible level
JL = -ceil(log2(R/2)/log2(beta));                        % lowest possible level. if R=8 and beta=4, then JL=-1.

if scale > JH || scale < JL
    error(['Scale must be integers in [' num2str(JL) ',' num2str(JH), ']']);
end

for j = JH:-1:JL
    Ntile = ParaScale(j,beta);
    for tile = -Ntile:Ntile 
        if j ~= scale || tile ~= shear                  
            shX{2-sect,j-JL+2, tile+Ntile+1}(:,:) = 0;    % kill the other shearlets
            shX{4-sect,j-JL+2, tile+Ntile+1}(:,:) = 0;    % leave only one
        end
    end
end

ty = AdjWindowOnPPGrid(shX,N,R,beta);
C  = generateW(N,R,1);
X  = InvppFTCG(ty,N,C,1e-5,0);

output_TestTimeFreqLoc(2,:) = decayRates(X,'t');
fprintf(lfile,'Decay Rate in Spatial Domain = %f\n\n', output_TestTimeFreqLoc(2,1));

fftX = fftshift(fft2(ifftshift(X)));

output_TestTimeFreqLoc(3,1:2) = [max(max(abs(fftX(N/2-3: N/2+3,N/2-3:N/2+3)))),max(max(abs(fftX)))];
output_TestTimeFreqLoc(4,:)   = decayRates(fftX,'f');
fprintf(lfile,'Compactly Supportedness in Frequency Domain = %E\n', output_TestTimeFreqLoc(3,1));
fprintf(lfile,'Decay Rate in Frequency Domain = %f\n\n', output_TestTimeFreqLoc(4,1));

disp('Computing Holder Regularity...');
CSmoothX = zeros(size(X));
CSmoothY = zeros(size(fftX));
for i = 1:N
    for j = 1:N
        CSmoothX(i,j) = pHolderSmooth2D(X,i,j,4);
        CSmoothY(i,j) = pHolderSmooth2D(fftX,i,j,4);
    end
end
CX = CSmoothX(:,:);
CY = CSmoothY(:,:);

output_TestTimeFreqLoc(5,:) = [median(CX(:)),mean(CX(:)),min(CX(:)),max(CX(:))];
output_TestTimeFreqLoc(6,:) = [median(CY(:)),mean(CY(:)),min(CY(:)),max(CY(:))];
fprintf(lfile,'Holder Regulairty in Time Domain = %f\n', output_TestTimeFreqLoc(5,1));
fprintf(lfile,'Holder Regularity in Frequency Domain = %f\n\n', output_TestTimeFreqLoc(6,1));

figure(1),surf(real(X));
figure(2),surf(abs(fftX));


end

function d = decayRates(X,TimeFreq)
   N     = size(X,1);
   dRate = [];
   Y     = X;
   n0    = round(sqrt(N));
   if TimeFreq == 't'
     for i = 1:N %N/2-n0:N/2+n0
       [y,ind] = monoMajorant(Y(N/2+1:N,i));
       y       = y(1:N/2); 
       ind     = ind(1:N/2);
       A       = [ones(length(y),1),log2(ind(:))];       
       dr      = A\log2(y(:));
       dRate   = [dRate dr(2)];
       
       [y,ind] = monoMajorant(Y(i,N/2+1:N));
       y       = y(1:N/2); 
       ind     = ind(1:N/2);
       A       = [ones(length(y),1),log2(ind(:))];
       dr      = A\log2(y(:));
       dRate   = [dRate dr(2)];
     end
   else
     for i = 1:N%N/2-n0:N/2+n0
       [y,ind] = monoMajorant(Y(i,N/2+1:N));
       y       = y(1:N/2); 
       ind     = ind(1:N/2);
       A       = [ones(length(y),1),log2(ind(:))];
       dr      = A\log2(y(:));
       dRate   = [dRate dr(2)];
     end  
     for i = 1:N%N/2+n0:N/2+N/4
       [y,ind] = monoMajorant(Y(N/2+1:N,i));
       y       = y(1:N/2); 
       ind     = ind(1:N/2);
       A       = [ones(length(y),1),log2(ind(:))];       
       dr      = A\log2(y(:));
       dRate   = [dRate dr(2)];
     end
   end
   d = [median(dRate),mean(dRate),min(dRate),max(dRate)];
end

function [y,ind] = monoMajorant(x)   
    [y,ind] = sort(abs(x),'descend');
 
%     n = length(x);
%     y = zeros(n,1);
%     for i = 1:n
%         y(i) = max(abs(x(i:n)));
%     end
end



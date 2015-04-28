function displayShX(x,R,beta,Choice,level)
%% DISPLAYSHX display shearlet coefficient blocks
%  Use pause, press any key to continue
%% DESCRIPTION
%    DISPLAYSHX(X,R,BETA,PRECOND,LEVEL), 
%    Input
%      X     - image
%      R     - oversampling rate
%      beta  - scaling factor
%      Choice- basisChoice
%      scale - which scale (level)
%      level - decomposition level
%
%% EXAMPLE
%      N = 256; R = 8; beta = 4; Choice = 0; level=0;
%      x = randn(N);
%      displayShX(x,R,beta,Choice,level);
%
%% See also PPVIEW, PLOTSHEARLETIMAGE

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


[N,M] = size(x);
y = ppFT(x,R);

figure(1);
subplot(1,2,1),imagesc(x);
subplot(1,2,2),ppview(abs(y));

C   = generateW(N,R,Choice);
shX = ShearletTransform(x,R,beta,C,level);

JH = ceil(log2(N)/log2(beta));      
JL = -ceil(log2(R/2)/log2(beta));% lowest possible level. if R=8 and beta=4, then JL=-1.
JL = -ceil(log2(R/2)/log2(beta));    % lowest possible level. if R=8 and beta=4, then JL=-1.
if level > 0 && level <= JH-JL+1   
    JL = JH-level+1;   % lowest level.
end

for scale = JH:-1:JL
   Ntile = ParaScale(scale,beta);   
     
   for tile = -Ntile:Ntile   
        
            cJ1 = shX{1,scale-JL+2,tile+Ntile+1}+shX{3,scale-JL+2,tile+Ntile+1};
            %[scale, tileI, tileJ, max(max(abs(cI))),max(max(abs(cJ))),max(max(abs(cI-cJ)))]
            cJ2 = shX{2,scale-JL+2,tile+Ntile+1}+shX{4,scale-JL+2,tile+Ntile+1};
            display(['scale = ', num2str(scale), ', tile = ' num2str(tile)]);
            figure(2)
            subplot(1,2,1),imagesc(abs(cJ1));colorbar;
            subplot(1,2,2),imagesc(abs(cJ2));colorbar;
            pause
   end
end
end

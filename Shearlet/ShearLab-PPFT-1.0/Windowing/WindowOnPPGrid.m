function y = WindowOnPPGrid(x,beta,level)
%% WINDOWONPPGRID W operator, subband windowing on PPGRID with 2D iFFT
%
%% Description
%  Y = WINDOWONPPGRID(X,BETA,LEVEL)
%    x: array (2,(R*n)+1,n+1) : (sector,radial,slope) 2 sectors.  
%    beta: 2 or 4; scaling factor 2^j or 4^j.
%    level: decomposition level, default to lowest possible level.
%    R: oversampling rate
%    y: digital shearlet coefficients which is a cell array:   
%       each y{sector,scale,tile} is a complex-valued matrix, 2D FFT
%    sector runs through 4 values
%    scale  runs through J     approx log(N)/log(beta/2) values
%    tile   runs through Ntile approx beta^scale values   [OUCH!]
%
%% Examples
%    R    = 4; beta = 4;
%    img  = imread('barbara.gif');
%    img  = double(img);
%    pimg = ppFT(img,R);
%    shX  = WindowOnPPGrid(pimg,beta,0);
%    size(shX)
%    
%
%% See also MEYER, BUMPV, NV, PARASCALE, ADJWINDOWONPPGRID

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

%% Update History
% Feb-21-2011: glue seam line coefficient together. (X.Z)

if nargin == 1  beta  = 4;  level = 0;  end
if nargin == 2  level = 0;              end

N  = size(x,3)-1;                     % size(x,3) == N = n
R  = (size(x,2)-1)/N;                 % size(x,2) == (R*n)+1
JH = ceil(log2(N)/log2(beta));        % size(x,3) <= beta^J, Highest possible level
JL = -ceil(log2(R/2)/log2(beta));     % lowest possible level. if R=8 and beta=4, then JL=-1.

if level > 0 && level <= JH-JL+1   
    JL = JH-level+1;                  % lowest level.
end

x1 = squeeze(x(1,:,:));               % grab sector 1
x2 = squeeze(x(2,:,:));               % grab sector 2

Ntile = ParaScale(JH,beta);
MaxNtile = 2*Ntile+1;                 % 2*2^(J+1)+2;
y  = cell(4,JH-JL+2,MaxNtile);        % digital shearlet coefficients
r0 = R*N/2+1;                         % r0 = size(x,2)/2 approx

disp('Decomposition of high-frequency part...');
for scale = JH:-1:JL,
    Ntile = ParaScale(scale,beta);
    disp(sprintf('scale = %d, Number of Tiles = %d',scale, 2*Ntile+1));

    r1 = (R/2) * beta^(scale-1);                  % r1 = lowest  support of radial window
    r2 = (R/2) * beta^(scale+1);                  % r2 = highest support of radial window    
    mx = ceil(r1):r2; 
    Wradial = Meyer(r1,r2,mx,'wavelet');          % middle subband radial window        
    if (r2 >= r0)
        r2 = r0-1;      
        Wradial = Wradial(1:r2-r1+1);             % highest subband radial window 
    end
    r1 = ceil(r1);
    r2 = r1+length(Wradial)-1;    
      
    %disp('Multiplying by radial windows...');    
    t1 = repmat(Wradial.',1,N+1);                          % matrix with Wradial as its columns

    ind = [r0+r1:r0+r2 r0-r1:-1:r0-r2];                    % subband has positive and negative twins
    t2 = [t1; t1];                                         % sector has positive and negative signs
    xt1 = x1(ind,:).*t2;                                   % multiply sector 1 by Wradial
    xt2 = x2(ind,:).*t2;                                   % multiply sector 2 by Wradial
    
    %disp('Multiplying by angular windows...');
    for tile = -Ntile:Ntile
        if Ntile == 0
            a1 = 1; 
            a2 = N+1;
            Wangular = ones(1,N+1);
        elseif tile == Ntile
            a1 = N/(2*Ntile)*(tile-1)+N/2+1; 
            a2 = N/(2*Ntile)*(tile)+N/2+1;
            Wangular = bumpV(0,N/Ntile);
            Wangular = Wangular(1:a2-a1+1);
        elseif tile == -Ntile
            a1 = N/(2*Ntile)*(tile)+N/2+1; 
            a2 = N/(2*Ntile)*(tile+1)+N/2+1;
            Wangular = bumpV(0,N/Ntile);        
            Wangular = Wangular(end-a2+a1:end);
        else            
            a1 = N/(2*Ntile)*(tile-1)+N/2+1; 
            a2 = N/(2*Ntile)*(tile+1)+N/2+1;
            Wangular = bumpV(0,N/Ntile);            
        end
        Wangular2=repmat(Wangular,2*(r2-r1+1),1);          % each row is a copy of Wangular
        y1=xt1(:,a1:a2).*Wangular2;                        % multiply sector 1 by Wangular
        y2=xt2(:,a1:a2).*Wangular2;                        % multiply sector 2 by Wangular

        % -----------------------------------------------
        % deal with discontinuity along seam lines
        if tile == -Ntile && Ntile >= 1
            y2lr = fliplr(y2);
            y1   = [y2lr y1];
            y2   = y1;
        end
        if tile == Ntile && Ntile >= 1
            y1lr   = fliplr(y1);
            y1lrud = flipud(y1lr);
            y1     = [y2 y1lrud];
            y2     = y1;
        end
        %-----------------------------------------------

         y{1,scale-JL+2,tile+Ntile+1} = ifft2(y1(1:end/2,:));           % FT positive half sector 1
         y{3,scale-JL+2,tile+Ntile+1} = ifft2(y1(end/2+1:end,:));       % FT negative half sector 1  [OUCH! FLIP?]
         y{2,scale-JL+2,tile+Ntile+1} = ifft2(y2(1:end/2,:    ));       % FT positive half sector 2
         y{4,scale-JL+2,tile+Ntile+1} = ifft2(y2(end/2+1:end,:));       % FT negative half sector 2  [OUCH! FLIP?]

    end
end

disp(['Decomposition of low frequency part...']);
r1 = (R/2) * beta^(JL-1);
r2 = (R/2) * beta^(JL+1);
mx = [0:floor(sqrt(r1*r2))]; 
Wradial = Meyer(r1,r2,mx,'scaling');                    % scaling function radial window
   
r2  = length(Wradial);
t1  = repmat(Wradial.',1,N+1);                           % matrix with Wradial as its columns
ind = [r0:r0+r2-1 r0:-1:r0-r2+1];                       % subband has positive and negative twins
t2  = [t1; t1];                                          % sector has positive and negative signs
xt1 = x1(ind,:).*t2;                                    % multiply sector 1 by Wradial
xt2 = x2(ind,:).*t2;                                    % multiply sector 2 by Wradial  
y1  = xt1;
y2  = xt2;

y{1,1,1} = ifft2(y1(1:end/2,:    ));       % FT positive half sector 1
y{3,1,1} = ifft2(y1(end/2+1:end,:));       % FT negative half sector 1  [OUCH! FLIP?]
y{2,1,1} = ifft2(y2(1:end/2,:    ));       % FT positive half sector 2
y{4,1,1} = ifft2(y2(end/2+1:end,:));       % FT negative half sector 2  [OUCH! FLIP?]
disp(['Done!']);

return % function end here    

function x = AdjWindowOnPPGrid(y,N,R,beta)
%% ADJWINDOWONPPGRID W^* operator, adjoint subband windowing  with 2D FFT
%
%% Description
%  Y = ADJWINDOWONPPGRID(Y,N,R,BETA)
%    x: array (2,(R*n)+1,n+1) : (sector,radial,slope) 2 sectors.  
%    beta: 2 or 4; scaling factor 2^j or 4^j.
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
%    N    = size(img,1);
%    pimg = ppFT(img,R);
%    shX  = WindowOnPPGrid(pimg,beta,0);
%    size(shX)
%    tpimg= AdjWindowOnPPGrid(shX,N,R,beta);
%    size(tpimg)
%    errX2= reshape(tpimg-pimg,2*(R*N+1),N+1);
%    errX1= reshape(pimg,2*(R*N+1),N+1);
%    err1 = norm(errX2,inf)
%    err2 = norm(errX2,2)
%    err3 = norm(errX2,'fro')/norm(errX1,'fro')
%% See also MEYER, BUMPV, NV, PARASCALE, WINDOWONPPGRID

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%
%% Update History
% Feb-21-2011: glue seam line coefficient together. (X.Z)

if nargin == 3  beta = 2; end

x  = zeros(2,R*N+1,N+1);
x1 = zeros(R*N+1,N+1);
x2 = zeros(R*N+1,N+1);

s2    = size(y,2);
level = s2-1;
JH    = ceil(log2(N)/log2(beta));
JL    = JH-level+1;
r0    = R*N/2+1;

disp(['Reconstruction from high-frequency part...']);
for scale = JH:-1:JL,
    Ntile = ParaScale(scale,beta);    
    disp(sprintf('scale = %d, Number of Tiles = %d',scale, 2*Ntile+1));
    
    r1 = (R/2) * beta^(scale-1);                 % r1 = lowest  support of radial window
    r2 = (R/2) * beta^(scale+1);                 % r2 = highest support of radial window
    mx = ceil(r1):r2;        
    Wradial = Meyer(r1,r2,mx,'wavelet');     % middle subband radial window                
    if (r2 >= r0)
        r2 = r0-1; Wradial = Wradial(1:r2-r1+1); % highest subband radial window        
    end 
    r1 = ceil(r1);
    r2 = r1+length(Wradial)-1;
      
    %disp('Multiplying by radial windows...');
    t1 = repmat(Wradial.',1,N+1);                          % matrix with Wradial as its columns
    ind = [r0+r1:r0+r2 r0-r1:-1:r0-r2];                    % subband has positive and negative twins
    t2 = [t1; t1];                                         % sector has positive and negative signs
    xt1 = t2*0;                                            % prepare section 1 by Wradial
    xt2 = t2*0;                                            % prepare sector 2 by Wradial
    
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
              
        Wangular2 = repmat(Wangular,2*(r2-r1+1),1);                   % each row is a copy of Wangular
  
        y1a = fft2(y{1,scale-JL+2,tile+Ntile+1});                     % FT positive half sector 1
        y1b = fft2(y{3,scale-JL+2,tile+Ntile+1});                     % FT negative half sector 1 [OUCH! Flip?]
        y2a = fft2(y{2,scale-JL+2,tile+Ntile+1});                     % FT positive half sector 2 
        y2b = fft2(y{4,scale-JL+2,tile+Ntile+1});                     % FT negative half sector 2 [OUCH! Flip?]             

        y1 = [y1a; y1b];
        y2 = [y2a; y2b];
        
        % -----------------------------------------------
        % deal with discontinuity along seam lines
        if tile == -Ntile && Ntile >= 1
            y2 = y1(:,1:end/2);            
            y2 = fliplr(y2);
            
            y1 = y1(:,end/2+1:end);
        end
        if tile == Ntile && Ntile >= 1
            y2 = y1(:,1:end/2);
            y1 = y1(:,end/2+1:end);
            y1 = flipud(y1);
            y1 = fliplr(y1);
        end     
        %-----------------------------------------------
        
        xt1(:,a1:a2) = xt1(:,a1:a2)+ y1.*conj(Wangular2);
        xt2(:,a1:a2) = xt2(:,a1:a2)+ y2.*conj(Wangular2);         
     
    end
    
    x1(ind,:) = x1(ind,:)+xt1.*conj(t2);
    x2(ind,:) = x2(ind,:)+xt2.*conj(t2);
end

disp(['Reconstrucion from low frequency part...']);
%low frequency part
r1 = (R/2) * beta^(JL-1);        
r2 = (R/2) * beta^(JL+1);
mx = [0:floor(sqrt(r1*r2))];
Wradial = Meyer(r1,r2,mx,'scaling');     % scaling function radial window
r2 = length(Wradial);
  
t1 = repmat(Wradial.',1,N+1);                % matrix with Wradial as its columns 
ind = [r0:r0+r2-1 r0:-1:r0-r2+1];            % subband has positive and negative twins
t2 = [t1; t1];                               % sector has positive and negative signs
  
xt1 = t2*0;                                  % multiply sector 1 by Wradial
xt2 = t2*0;                                  % multiply sector 2 by Wradial  
   
y1a = fft2(y{1,1,1});                        % FT positive half sector 1
y1b = fft2(y{3,1,1});                        % FT negative half sector 1 [OUCH! Flip?]
y2a = fft2(y{2,1,1});                        % FT positive half sector 2 
y2b = fft2(y{4,1,1});                        % FT negative half sector 2 [OUCH! Flip?]             

y1 = [y1a;y1b];
y2 = [y2a;y2b];

x1(ind,:)=x1(ind,:)+ y1.*conj(t2);
x2(ind,:)=x2(ind,:)+ y2.*conj(t2);

x(1,:,:)=x1;
x(2,:,:)=x2;
disp('Done!');

end
function thr = dshGetThr(N,R,beta,Choice)
%thr = dshGetThr(shX,N,R,beta,method,parameter)
% parameter: 0<= p <=1
% method: 'PCoef', discard p*100 percent of the coefficients 
%         'PMax',  discard coefficient that is lower than p*abs(max).
% return thresholding value: thr
[n,m] = size(X);
if n ~= m
    error('image must be a square.');
end
N = n;

if parameter < 0 || parameter > 1
        error('Usage: thr = dshGetThr(X,R,beta,method,parameter). parameter must be in [0,1]!');
end

if strcmp(PreCond,'PreCond')
    ShX = ShearletTransform_xz(X,R,beta,'PreCond',level);
else     
    ShX = ShearletTransform_xz(X,R,beta,'NoPreCond');
end;

[nSector,nScale,nTile] = size(ShX);

level = nScale-1;
JH = ceil(log2(N)/log2(beta));
JL = JH-level+1;
%t2 = clock;
ListCoeff = [];
for sector=1:4
    for scale=JH:-1:JL
         Ntile = ParaScale_xz(scale,beta);
         for tile=-Ntile:Ntile
             LengthVector =  prod(size(ShX{sector,scale-JL+2,tile+Ntile+1}));
             ListCoeff=[ListCoeff reshape(ShX{sector,scale-JL+2,tile+Ntile+1},1,LengthVector)];             
         end;   
    end;    
end;  

%disp(['test:']); etime(clock,t2)
SortCoeff=sort(ListCoeff);

if strcmp(method,'PCoef')
    NumberThres = floor(size(SortCoeff,2)*parameter); % number of value used for thresholding
    if NumberThres == 0 
        thr = 0; 
    else
        thr = abs(SortCoeff(NumberThres)); % value used for threshold
    end
elseif strcmp(method,'PMax')
    thr = SortCoeff(end)*parameter;
else
    error('Please specify method, either PCoef or PMax');
end

end
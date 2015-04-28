function RMS = SLPaperGetRMS3D(X,Y,Z,transform, varargin )
%SLPAPERIMAGEDENOISINGGETRMS Summary of this function goes here
%   Detailed explanation goes here

    delta = zeros(X,Y,Z);
    delta(ceil(X/2),ceil( Y/2),ceil(Z/2)) = 1;
    if strcmp(transform,'NSST3D')
        dataClass = varargin{1};
        filterDilationType = varargin{2};
        filterType = varargin{3};
        level = varargin{4};            
        dBand=varargin{5};                 
        filterSize=varargin{6};
        
        F=GetFilter(filterType,level,dBand,filterSize,filterDilationType ,dataClass);        
        BP=DoPyrDec(delta,level);
        for pyrCone=1:3
            coeffs=ShDec(pyrCone,F,BP,level,dataClass);
            for l=1:level  
                [sizel2,sizel1] =size(F{pyrCone,l});
                for l2=1:sizel2
                    for l1=1:sizel1                       
                      RMS{pyrCone,l}(l2,l1) = sqrt(sum(sum(sum(abs(fftn(coeffs{l}{l2,l1})).^2)))/numel(coeffs{l}{l2,l1}));
                    end
                end
            end
        end
    end

    if strcmp(transform,'SURF')
        Pyr_mode = varargin{1};
        Lev_array = varargin{2};
        bo = varargin{3};        
        sz = [X,Y,Z];
        nRepeat = 50;
        RMS = SurfEP(sz, Lev_array, Pyr_mode, bo, nRepeat);    
    end
    
    if strcmp(transform,'SWT')
    end

end
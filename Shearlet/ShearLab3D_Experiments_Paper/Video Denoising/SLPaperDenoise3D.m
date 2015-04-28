function Xrec = SLPaperDenoise3D(Xnoisy,sigma,thresholdingFactor,transform,varargin)
%SLPAPERDENOISE3D Summary of this function goes here
%   Detailed explanation goes here
    
    %% SL3D1 or SL3D2
    if strcmp(transform,'SL3D1') || strcmp(transform,'SL3D2')
        useGPU = varargin{1};
        scales = varargin{2};
        shearLevels = varargin{3};

        if useGPU
            Xnoisy = gpuArray(Xnoisy);
        end
        
        [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,Xnoisy,scales,shearLevels);
        for j = 1:size(shearletIdxs,1)
            shearletIdx = shearletIdxs(j,:);

            %%shearlet decomposition
            [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);

            %%put processing of shearlet coefficients here, for example:
            %%thresholding
            coeffs = coeffs.*(abs(coeffs) > thresholdingFactor(shearletIdxs(2))*RMS*sigma);

            %%shearlet reconstruction 
            Xrec = SLshearrecSerial3D(coeffs,shearlet,Xrec);      
        end

        Xrec = gather(SLfinishSerial3D(Xrec,dualFrameWeightsCurr));
    end

    %% SURF
    if strcmp(transform,'SURF')
        Pyr_mode = varargin{1};
        Lev_array = varargin{2};
        bo = varargin{3};
        rmsscalars = varargin{4};
        [coeffs, Recinfo] = Surfdec(Xnoisy, Pyr_mode, Lev_array, 'ritf', 'bo', bo);

        % Hard-thresholding the surfacelet coefficients
        for n = 1 : length(coeffs) - 1
            thresh = 3 * sigma + (n==1) * sigma;
            for dd = 1 : length(coeffs{n})
                for sd = 1 : length(coeffs{n}{dd})
                    coeffs{n}{dd}{sd} = coeffs{n}{dd}{sd} .* (abs(coeffs{n}{dd}{sd}) > thresh * rmsscalars{n}{dd}{sd});
                end
            end
        end
        Xrec = Surfrec(coeffs, Recinfo);        
    end
    
    %% NSST3D
    if strcmp(transform,'NSST3D')
        dataClass = varargin{1};
        filterDilationType = varargin{2};
        filterType = varargin{3};
        level = varargin{4};
        dBand = varargin{5};
        filterSize = varargin{6};
        rmsnsst = varargin{7};
        
        F=GetFilter(filterType,level,dBand,filterSize,filterDilationType ,'double');
        BP=DoPyrDec(Xnoisy,level);
        partialBP=cell(size(BP));
        recBP=cell(size(BP));
        for pyrCone=1:3
          shCoeff=ShDec(pyrCone,F,BP,level,dataClass);
          %clear F{pyrCone,:}
          shCoeff=ThresholdShCoeff(shCoeff,rmsnsst,pyrCone,sigma,thresholdingFactor);
          partialBP{pyrCone}=ShRec(shCoeff);
          %clear shCoeff;
        end
        clear F;
        clear shCoeff;

        for l=1:level      
          %% Assuming different pyramidal zone have same shCoeff size at different 
          %%level
          recBP{l}=zeros(size(partialBP{1}{l}),dataClass);
          for pyrCone =1:3
           recBP{l}=recBP{l}+ partialBP{pyrCone}{l};
          end
        end

        recBP{level+1}=BP{level+1};

        % Do Reconstruction
        Xrec=DoPyrRec(recBP);        
    end
    
    %% SL2D2
    if strcmp(transform,'SL2D2')
        sl2d2 = varargin{1};
        
        Xrec = zeros(size(Xnoisy));
        if sl2d2.useGPU
            Xnoisy = gpuArray(Xnoisy);
            Xrec = gpuArray(Xrec);
        end
        for i_img = 1:size(Xnoisy,3)
            coeffs = SLsheardec2D(squeeze(Xnoisy(:,:,i_img)),sl2d2);
            for j = 1:sl2d2.nShearlets
                idx = sl2d2.shearletIdxs(j,:);
                coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j)) >= thresholdingFactor(idx(2)+1)*sl2d2.RMS(j)*sigma);
            end
            Xrec(:,:,i_img) = SLshearrec2D(coeffs,sl2d2);
        end
        if sl2d2.useGPU
            Xrec = gather(Xrec);
        end
    end

end


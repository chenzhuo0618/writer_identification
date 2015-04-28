function Xrec = SLExperimentDenoise3D(Xnoisy,sigma,thresholdingFactor,transform,varargin)
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

    
    %% SL2D2
    if strcmp(transform,'SL2D2')
        sl2d2 = varargin{1};
        
        Xrec = zeros(size(Xnoisy));
        if sl2d2.useGPU
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


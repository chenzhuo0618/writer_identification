function videoInpainted = SLExperimentInpaint3D(videoMasked,mask,iterations,stopFactor,transform,varargin)
% This routine perfomrs image inpainting using the shearlet transform.
% It uses simple iterative thresholding algorithm which appears in 
% "Image decomposition via the combination of sparse representation and 
%  a variational approach", J. Starck et al.,
%  IEEE Trans. Image Proc. vol. 14, 2005.
%
% iterations: max numbr of iterations
% stop: smallest threshold considered
% 
%s

    %SL3D1 or SL3D2
    if strcmp(transform,'SL3D1') || strcmp(transform,'SL3D2')
        useGPU = varargin{1};
        scales = varargin{2};
        shearLevels = varargin{3};
        
        if useGPU
            videoMasked = gpuArray(videoMasked);
            mask = gpuArray(mask);
        end;
        
        
        %initialize thresholding parameter                
        delta = -inf;
        [Xfreq, Xrec, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,videoMasked,scales,shearLevels);
        for j = 1:size(shearletIdxs,1)
            shearletIdx = shearletIdxs(j,:);

            % shearlet decomposition
            [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);            
            delta = max([abs(coeffs(:)/RMS);delta]);
        end
        
        % set thresholding parameter which will exponentially decrease.
        if useGPU
            lambda=gpuArray((stopFactor)^(1/(iterations-1)));
            videoInpainted = gpuArray(0);
        else
            lambda=(stopFactor)^(1/(iterations-1));
            videoInpainted = 0;
        end
        %iterative thresholding
        for it = 1:iterations
            res = mask.*(videoMasked-videoInpainted);          
            
            [Xfreq, videoInpainted, preparedFilters, dualFrameWeightsCurr, shearletIdxs] = SLprepareSerial3D(useGPU,videoInpainted + res,scales,shearLevels);
            for j = 1:size(shearletIdxs,1)
                shearletIdx = shearletIdxs(j,:);

                %% shearlet decomposition
                [coeffs,shearlet, dualFrameWeightsCurr,RMS] = SLsheardecSerial3D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
                
                %% apply hard thresholding
                coeffs = coeffs.*(abs(coeffs)/RMS > delta);

                %% shearlet reconstruction 
                videoInpainted = SLshearrecSerial3D(coeffs,shearlet,videoInpainted);      
            end
            videoInpainted = real(SLfinishSerial3D(videoInpainted,dualFrameWeightsCurr));
            delta=delta*lambda;    
            display([it, delta]);
        end
        if useGPU
            videoInpainted = gather(videoInpainted);
        end;
    end
    
    
    %SL2D2
    if strcmp(transform,'SL2D2')
        sl2d2 = varargin{1};
        if sl2d2.useGPU
            mask = gpuArray(mask);
            videoMasked = gpuArray(videoMasked);
            videoInpainted = gpuArray.zeros(size(videoMasked)); 
        else
            videoInpainted = zeros(size(videoMasked)); 
        end
        
        for it= 1:size(videoMasked,3)
            mask2D = mask(:,:,it);
            imgMasked = videoMasked(:,:,it);
            videoInpainted(:,:,it) = SLinpaint2D(imgMasked,mask2D,iterations,stopFactor,'SL2D2',sl2d2);
            display(it);
        end
        if sl2d2.useGPU
            videoInpainted = gather(videoInpainted);
        end
    end    
 end

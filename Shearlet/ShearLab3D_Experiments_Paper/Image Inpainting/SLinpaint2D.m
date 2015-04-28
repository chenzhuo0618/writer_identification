function imgInpainted = SLinpaint2D(imgMasked,mask,iterations,stopFactor,transform,varargin)
% This routine perfomrs image inpainting using the shearlet transform.
% It uses simple iterative thresholding algorithm which appears in 
% "Image decomposition via the combination of sparse representation and 
%  a variational approach", J. Starck et al.,
%  IEEE Trans. Image Proc. vol. 14, 2005.
%
% iterations: max numbr of iterations
% stop: smallest threshold considered
% 
%

    %SL2D1
    if strcmp(transform,'SL2D1')
        sl2d1 = varargin{1};
        
        %initialize thresholding parameter
        coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(imgMasked,sl2d1),sl2d1);        
        delta = max(abs(coeffsNormalized(:)));
        if sl2d1.useGPU    
            lambda=gpuArray((stopFactor)^(1/(iterations-1)));
            imgInpainted = gpuArray(0);
        else
            lambda=(stopFactor)^(1/(iterations-1));
            imgInpainted = 0;
        end
        
    end
    %SL2D2
    if strcmp(transform,'SL2D2')
        sl2d2 = varargin{1};
        
        %initialize thresholding parameter
        coeffsNormalized = SLnormalizeCoefficients2D(SLsheardec2D(imgMasked,sl2d2),sl2d2);
        delta = max(abs(coeffsNormalized(:)));
        if sl2d2.useGPU    
            lambda=gpuArray((stopFactor)^(1/(iterations-1)));
            imgInpainted = gpuArray(0);
        else
            lambda=(stopFactor)^(1/(iterations-1));
            imgInpainted = 0;
        end
    end
    %NSST
    if strcmp(transform,'NSST')
        shear_parameters.dcomp = varargin{1};
        shear_parameters.dsize = varargin{2};
        rmsnsst = varargin{3};
        
        %initialize thresholding parameter
        delta = 0;
        coeffs = nsst_dec2(imgMasked,shear_parameters,'maxflat');
        for j = 1:size(coeffs,2)
            for k = 1:size(coeffs{j},3)
                delta = max([max(max(abs(coeffs{j}(:,:,k)/rmsnsst(j,k)))),delta]);
            end                
        end
        lambda=(stopFactor)^(1/(iterations-1));

        imgInpainted = 0;
    end
    %SWT
    if strcmp(transform,'SWT')
        swtN =  varargin{1};
        swtName =  varargin{2};
        rmsswt =  varargin{3};
                
        %initialize thresholding parameter
        coeffsNormalized = swt2(imgMasked,swtN,swtName);
        for j = 1:size(coeffsNormalized,3)
            coeffsNormalized(:,:,j) = coeffsNormalized(:,:,j)/rmsswt(j);
        end
        delta = max(abs(coeffsNormalized(:)));
        lambda=(stopFactor)^(1/(iterations-1));

        imgInpainted = 0;

    end

    %FDCT
    if strcmp(transform,'FDCT')
        isreal = varargin{1};
        finest = varargin{2};
        nbscales =  varargin{3};
        nbangles = varargin{4};
        rmsfdct =  varargin{5};
  
        %initialize thresholding parameter
        delta = 0;
        coeffs = fdct_wrapping(imgMasked,isreal,finest,nbscales,nbangles);
        for j = 2:length(coeffs)
            for k = 1:length(coeffs{j})
                delta = max([max(max(abs(coeffs{j}{k}/rmsfdct(j,k)))),delta]);
            end
        end
        lambda=(stopFactor)^(1/(iterations-1));

        imgInpainted = 0;
    end
    



    % set thresholding parameter which will exponentially decrease. 

    
    %iterative thresholding
    for it = 1:iterations
        res = mask.*(imgMasked-imgInpainted);
        %SL2D1
        if strcmp(transform,'SL2D1')
            coeffs = SLsheardec2D(imgInpainted+res,sl2d1);
            coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,sl2d1))>delta);
            imgInpainted = SLshearrec2D(coeffs,sl2d1); 
        end
        %SL2D2
        if strcmp(transform,'SL2D2')
            coeffs = SLsheardec2D(imgInpainted+res,sl2d2);
            coeffs = coeffs.*(abs(SLnormalizeCoefficients2D(coeffs,sl2d2))>delta);
            imgInpainted = SLshearrec2D(coeffs,sl2d2);         
        end
        %NSST
        if strcmp(transform,'NSST')
            %here
            [coeffs, filters] = nsst_dec2(imgInpainted + res,shear_parameters,'maxflat');
            for j = 1:size(coeffs,2)
                for k = 1:size(coeffs{j},3)
                    coeffs{j}(:,:,k) = coeffs{j}(:,:,k).*(abs(coeffs{j}(:,:,k))/rmsnsst(j,k) > delta);
                end                
            end
            imgInpainted = nsst_rec2(coeffs,filters,'maxflat');
        end
        %SWT
        if strcmp(transform,'SWT')
            coeffs = swt2(imgInpainted + res,swtN,swtName);
            for j = 1:size(coeffs,3)
                coeffs(:,:,j) = coeffs(:,:,j).*(abs(coeffs(:,:,j))/rmsswt(j) > delta);
            end
            imgInpainted = iswt2(coeffs,swtName);
        end

        %FDCT
        if strcmp(transform,'FDCT')
            coeffs = fdct_wrapping(imgInpainted + res,isreal,finest,nbscales,nbangles);
            for j = 2:length(coeffs)
                for k = 1:length(coeffs{j})
                    coeffs{j}{k} = coeffs{j}{k}.*(abs(coeffs{j}{k})/rmsfdct(j,k) > delta);
                end
            end
            imgInpainted = real(ifdct_wrapping(coeffs,isreal,size(imgMasked,1),size(imgMasked,2)));
        end
        delta=delta*lambda;        
    end    
end

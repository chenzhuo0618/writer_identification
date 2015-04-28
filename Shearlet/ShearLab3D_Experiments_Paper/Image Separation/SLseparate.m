function [imgCurves, imgPoints] = SLseparate(img,lvlWavelets,iterations,stopFactor,gamma,freqWeights,transform,varargin)
% This routine performs image separation to separate two geometrically 
% different objects (points + curves).
% This routine builds up on MCA2_Bcr.m (in MCALab110 ) written by J. M. Fadili. 

    
    N = length(img);

    %% re weighting of frequency bands
    coeffs = atrousdec(img,'maxflat',length(freqWeights)-1);
    for  j = 1:length(freqWeights)
        coeffs{j} = freqWeights(j)*coeffs{j};
    end
    imgReWeighted = atrousrec(coeffs,'maxflat');

    %% Compute minimal threshold deltaMin, at which the iteration stops
    coeffsWaveletOP = FWT2_PO(imgReWeighted,log2(N)-1,MakeONFilter('Daubechies',4));
    hh = coeffsWaveletOP(N/2+1:N/2+floor(N/2),N/2+1:N/2+floor(N/2)); %consider only highpass
    sigma = MAD(hh(:));
    deltaMin = stopFactor*sigma;
    
    %SL2D1
    if strcmp(transform,'SL2D1')
        sl2d1 = varargin{1};


        %estimate a starting thresholding parameter delta 
        %we compute all coefficients for the directional and the wavelet system
        coeffsDirectional = SLnormalizeCoefficients2D(SLsheardec2D(imgReWeighted,sl2d1),sl2d1);
        coeffsWavelet = swt2(imgReWeighted,lvlWavelets,'sym4');
        delta = min([max(abs(coeffsDirectional(:))), max(abs(coeffsWavelet(:)))]);

    end
    %SL2D2
    if strcmp(transform,'SL2D2')
        sl2d2 = varargin{1};

        %estimate a starting thresholding parameter delta 
        %we compute all coefficients for the directional and the wavelet system
        coeffsDirectional = SLnormalizeCoefficients2D(SLsheardec2D(imgReWeighted,sl2d2),sl2d2);
        coeffsWavelet = swt2(imgReWeighted,lvlWavelets,'sym4');
        delta = min([max(abs(coeffsDirectional(:))), max(abs(coeffsWavelet(:)))]);
    end
    %NSST
    if strcmp(transform,'NSST')
        shear_parameters.dcomp = varargin{1};
        shear_parameters.dsize = varargin{2};
        rmsnsst = varargin{3};

        %initialize thresholding parameter
        delta = 0;
        coeffsDirectional = nsst_dec2(imgReWeighted,shear_parameters,'maxflat');
        for j = 1:size(coeffsDirectional,2)
            for k = 1:size(coeffsDirectional{j},3)
                delta = max([max(max(abs(coeffsDirectional{j}(:,:,k)/rmsnsst(j,k)))),delta]);
            end                
        end
        coeffsWavelet = swt2(imgReWeighted,lvlWavelets,'sym4');
        delta = min([delta, max(abs(coeffsWavelet(:)))]);
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
        coeffs = fdct_wrapping(imgReWeighted,isreal,finest,nbscales,nbangles);
        for j = 2:length(coeffs)
            for k = 1:length(coeffs{j})
                delta = max([max(max(abs(coeffs{j}{k}/rmsfdct(j,k)))),delta]);
            end
        end
        coeffsWavelet = swt2(imgReWeighted,lvlWavelets,'sym4');
        delta = min([delta, max(abs(coeffsWavelet(:)))]);
    end





    %% Compute an update factor lambda (deltaNew = deltaOld*lambda;)
    lambda=(delta/deltaMin)^(1/(1-iterations)); % Exponential decrease.

    %% Approximately solve l0 minimization
    imgSep = zeros(N,N,2); %initialize separated images with 0

    for i = 1:iterations
        %Directional Dictionaries
        res = imgReWeighted - (imgSep(:,:,1)+imgSep(:,:,2));
        resWavelet = res+imgSep(:,:,1);
        
        %SL2D1
        if strcmp(transform,'SL2D1')
            coeffsDirectional = SLsheardec2D(resWavelet,sl2d1);
            coeffsDirectional = coeffsDirectional.*(abs(SLnormalizeCoefficients2D(coeffsDirectional,sl2d1)) > 1.4*delta);    
            imgSep(:,:,1) = SLshearrec2D(coeffsDirectional,sl2d1);    
        end
        %SL2D2
        if strcmp(transform,'SL2D2')
            coeffsDirectional = SLsheardec2D(resWavelet,sl2d2);
            coeffsDirectional = coeffsDirectional.*(abs(SLnormalizeCoefficients2D(coeffsDirectional,sl2d2)) > 1.4*delta);    
            imgSep(:,:,1) = SLshearrec2D(coeffsDirectional,sl2d2);    
        end
        %NSST
        if strcmp(transform,'NSST')
            [coeffsDirectional, filters] = nsst_dec2(resWavelet,shear_parameters,'maxflat');
            for j = 1:size(coeffsDirectional,2)
                for k = 1:size(coeffsDirectional{j},3)
                    coeffsDirectional{j}(:,:,k) = coeffsDirectional{j}(:,:,k).*(abs(coeffsDirectional{j}(:,:,k))/rmsnsst(j,k) > 1.4*delta);
                end                
            end
            imgSep(:,:,1) = nsst_rec2(coeffsDirectional,filters,'maxflat');
        end
        %FDCT
        if strcmp(transform,'FDCT')
            coeffsDirectional = fdct_wrapping(resWavelet,isreal,finest,nbscales,nbangles);
            for j = 2:length(coeffsDirectional)
                for k = 1:length(coeffsDirectional{j})
                    coeffsDirectional{j}{k} = coeffsDirectional{j}{k}.*(abs(coeffsDirectional{j}{k})/rmsfdct(j,k) > 1.4*delta);
                end
            end
            imgSep(:,:,1) = real(ifdct_wrapping(coeffsDirectional,isreal,size(img,1),size(img,2)));
        end


        %apply soft-thresholding with the (undecimated) Haar wavelet transform 
        imgSep(:,:,1) = TVCorrection(imgSep(:,:,1),gamma);

        %Wavelet Dictionary
        resDirectional = res + imgSep(:,:,2);
        coeffsWavelet = swt2(resDirectional,lvlWavelets,'sym4');
        coeffsWavelet = coeffsWavelet.*(abs(coeffsWavelet) > 1.4*delta);
        imgSep(:,:,2) = iswt2(coeffsWavelet,'sym4');
        %apply soft-thresholding with the (undecimated) Haar wavelet transform 
        imgSep(:,:,2) = TVCorrection(imgSep(:,:,2),gamma);

        %Updating thresholding parameter (Exponential decrease).
        delta=delta*lambda; 
    end

    imgCurves = imgSep(:,:,1); 
    imgPoints = imgSep(:,:,2);
    %aviobj = close(aviobj);
    %close(f1);    
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = TVCorrection(x,gamma)
    % Total variation implemented using the approximate (exact in 1D) equivalence between the TV norm and the l_1 norm of the Haar (heaviside) coefficients.

    %qmf = MakeONFilter('Haar');
    %[ll,wc] = mrdwt(x,qmf,1);
    wc = swt2(x,1,'haar');
    wc = SoftThresh(wc,gamma);
    y = iswt2(wc,'haar');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
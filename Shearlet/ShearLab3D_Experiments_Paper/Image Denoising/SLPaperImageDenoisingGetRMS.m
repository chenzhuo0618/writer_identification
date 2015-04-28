function RMS = SLPaperImageDenoisingGetRMS( X,Y,transform, varargin )
%SLPAPERIMAGEDENOISINGGETRMS Summary of this function goes here
%   Detailed explanation goes here

delta = zeros(X,Y);
delta(ceil(X/2),ceil( Y/2)) = 1;
if strcmp(transform,'NSCT')
    levels = varargin{1};
    dfilt = varargin{2};
    pfilt = varargin{3};
    coeffs = nsctdec(delta, levels,dfilt,pfilt);
    for j = 1:size(coeffs,2)
        if iscell(coeffs{j})
           for k = 1:size(coeffs{j},2)
                RMS(j,k) = sqrt(sum(sum(abs(fft2(coeffs{j}{k})).^2))/(X*Y));
            end
        else
            RMS(j,1) = sqrt(sum(sum(abs(fft2(coeffs{j})).^2))/(X*Y));
       
        end
    end    
end
if strcmp(transform,'NSST')
    shear_parameters.dcomp = varargin{1};
    shear_parameters.dsize = varargin{2};
    
    coeffs = nsst_dec2(delta,shear_parameters,'maxflat');
    for j = 1:size(coeffs,2)
        for k = 1:size(coeffs{j},3)
            RMS(j,k) = sqrt(sum(sum(abs(fft2(coeffs{j}(:,:,k))).^2))/(X*Y));
        end
    end
end


if strcmp(transform,'SWT')
    N = varargin{1};
    name = varargin{2};
    
    coeffs = swt2(delta,N,name);
    for j = 1:size(coeffs,3)
        RMS(j) = sqrt(sum(sum(abs(fft2(coeffs(:,:,j))).^2))/(X*Y));
    end
end

if strcmp(transform,'FDCT')
    isreal = varargin{1};
    finest = varargin{2};
    nbscales = varargin{3};
    nbangles = varargin{4};
    
    coeffs = fdct_wrapping(delta*sqrt(X*Y),isreal,finest,nbscales,nbangles);
    for j = 1:length(coeffs)
        for k = 1:length(coeffs{j})
            RMS(j,k) = sqrt(sum(sum(abs(coeffs{j}{k}).^2))/(numel(coeffs{j}{k})));
        end
    end
end
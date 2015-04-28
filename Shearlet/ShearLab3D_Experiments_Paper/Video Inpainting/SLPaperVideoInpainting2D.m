%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Shear Inpainting Demo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

useGPU = 1;
iterations = 500;

load coastguard_sequence.mat;
X = double(X);
mask = mask1; 

if useGPU
    X = gpuArray(X);
    mask = gpuArray(mask); 
end
Xmasked = X.*mask;

shearletSystem = SLgetShearletSystem2D(useGPU,size(X,1),size(X,2),4);

if useGPU
    Xinpainted = gpuArray.zeros(size(X));
else
    Xinpainted = zeros(size(X));
end
for i = 1:size(X,3)
    tic;
    Xinpainted(:,:,i) = real(SLinpaint2D(squeeze(Xmasked(:,:,i)),squeeze(mask(:,:,i)),shearletSystem,iterations));
    toc;
    fprintf(['PSNR: ', num2str(SLcomputePSNR(X(:,:,i),Xinpainted(:,:,i)))]);
end
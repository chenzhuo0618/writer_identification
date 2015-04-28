clear;
%% setup
nExperiments = 1;
iterations = 300;
stopFactor = 0.005;
sizeX = 512;
sizeY = 512;



images = {'data_inpainting_2d/lena.jpg','data_inpainting_2d/barbara.jpg','data_inpainting_2d/flinstones.png'};
masks = {'data_inpainting_2d/mask_rand.png','data_inpainting_2d/mask_squares.png','data_inpainting_2d/mask_text.png'};
testSL2D1 = 1;
testSL2D2 = 1;
testNSST = 1;
testSWT = 1;
testFDCT = 1;

useGPU = 0;

saveImage = 0;
savePSNR = 0;

results = zeros(size(images,2),length(masks),5);
timeElapsed = zeros(2,5);
if useGPU
    g = gpuDevice;
    wait(g);
end;
%SL2D1
if testSL2D1
    tic;
    sl2d1 = SLgetShearletSystem2D(useGPU,sizeX,sizeY,4,[0 0 1 1]);
    if useGPU
        wait(g);
    end;
    timeElapsed(1,1) = toc;   
end
%SL2D2
if testSL2D2
    tic;
    sl2d2 = SLgetShearletSystem2D(useGPU,sizeX,sizeY,4,[1 1 2 2]);
    if useGPU
        wait(g);
    end;
    timeElapsed(2,1) = toc;
end
%NSST
if testNSST
    shear_parameters.dcomp = [3 3 4 4];
    shear_parameters.dsize = [32 32 16 16];
    rmsnsst = SLPaperImageDenoisingGetRMS( sizeX,sizeY,'NSST', shear_parameters.dcomp,shear_parameters.dsize);
end

%SWT
if testSWT
    swtN = 4;
    swtName = 'sym4';
    rmsswt = SLPaperImageDenoisingGetRMS(sizeX,sizeY,'SWT',swtN,swtName);
end

%FDCT
if testFDCT
    isreal = 1;
    finest = 2;
    nbscales = 5;
    nbangles = 8;
    rmsfdct = SLPaperImageDenoisingGetRMS(sizeX,sizeY,'FDCT',isreal,finest,nbscales,nbangles);
end 

%% expriment
for i_n = 1:nExperiments
    for i_img = 1:size(images,2)
        img = double(imread(images{i_img}));
        for i_mask = 1:size(masks,2)
            mask = (imread(masks{i_mask}) > 254); 

            imgMasked = img.*mask;
            
            if useGPU
                wait(g);
            end;
                
            %SL2D1
            if testSL2D1
                tic;
                if useGPU
                    imgInpainted = gather(real(SLinpaint2D(gpuArray(imgMasked),gpuArray(mask),iterations,stopFactor,'SL2D1',sl2d1)));
                    wait(g);
                else
                    imgInpainted = real(SLinpaint2D(imgMasked,mask,iterations,stopFactor,'SL2D1',sl2d1));
                end;
                timeElapsed(2,1) = toc;
                if saveImage
                    save results/sl2d1_text imgInpainted;
                end;
                results(i_img,i_mask,1) = results(i_img,i_mask,1) + SLcomputePSNR(imgInpainted,img);
            end
            display('Sl2D1');
            %SL2D2
            if testSL2D2
                tic;
                if useGPU
                    imgInpainted = gather(real(SLinpaint2D(gpuArray(imgMasked),gpuArray(mask),iterations,stopFactor,'SL2D2',sl2d2)));
                    wait(g);
                else
                    imgInpainted = real(SLinpaint2D(imgMasked,mask,iterations,stopFactor,'SL2D2',sl2d2));  
                end;
                timeElapsed(2,2) = toc;
                if saveImage
                    save results/sl2d2_text imgInpainted;
                end;
                results(i_img,i_mask,2) = results(i_img,i_mask,2) + SLcomputePSNR(imgInpainted,img);
            end
            display('Sl2D2');
            %NSST
            if testNSST
                tic;
                imgInpainted = real(SLinpaint2D(imgMasked,mask,iterations,stopFactor,'NSST',shear_parameters.dcomp,shear_parameters.dsize,rmsnsst));
                timeElapsed(2,3) = toc;
                if saveImage
                    save results/nsst_text imgInpainted;
                end;
                results(i_img,i_mask,3) = results(i_img,i_mask,3) + SLcomputePSNR(imgInpainted,img);
            end
            display('NSST');
            %SWT
            if testSWT
                tic;
                imgInpainted = real(SLinpaint2D(imgMasked,mask,iterations,stopFactor,'SWT',swtN,swtName,rmsswt));
                timeElapsed(2,4) = toc;
                if saveImage
                    save results/swt_text imgInpainted;
                end;
                results(i_img,i_mask,4) = results(i_img,i_mask,4) + SLcomputePSNR(imgInpainted,img);                        
            end
            display('SWT');

            %FDCT
            if testFDCT
                tic;
                imgInpainted = real(SLinpaint2D(imgMasked,mask,iterations,stopFactor,'FDCT',isreal,finest,nbscales,nbangles,rmsfdct));
                timeElapsed(2,5) = toc;
                if saveImage
                    save results/fdct_text imgInpainted;
                end;
                results(i_img,i_mask,5) = results(i_img,i_mask,5) + SLcomputePSNR(imgInpainted,img);
            end
            display('FDCT');
            if saveImage
                save results/img img;
                save results/imgMasked imgMasked;
            end;                
        end
    end  
end

if savePSNR
    save results_inpainting_2d_neu results;
    save results_inpainting_2d_time_neu timeElapsed;
end;
disp(results)

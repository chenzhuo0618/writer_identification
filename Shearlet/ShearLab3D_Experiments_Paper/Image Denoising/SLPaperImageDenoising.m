clear;
%% setup
nExperiments = 1;
sigmas = [10,20,30,40,50];
thresholdingFactor = [0 2.5 2.5 2.5 3.8];
thresholdingFactor2 = [0 3 3 4 4];
images = {'data_denoising_2d/lena.jpg','data_denoising_2d/barbara.jpg','data_denoising_2d/boat.png','data_denoising_2d/peppers.png'};
testSL2D1 = 1;
testSL2D2 = 1;
testNSST = 1;
testNSCT = 1;
testSWT = 1;
testFDCT = 1;

useGPU = 0;
if useGPU
    g = gpuDevice;
end

results = zeros(size(images,2),length(sigmas),6);
noisypsnr = zeros(size(images,2),length(sigmas));
timeElapsed = zeros(2,6);

saveImage = 0;
savePSNR = 0;

%% expriment
for i_n = 1:nExperiments
    for i_img = 1:size(images,2)

        %% initialize dictionaries
        image = images{i_img};

        X = imread(image);
        X = double(X);

        if useGPU
            wait(g);
        end;
        
        %SL2D1        
        if testSL2D1
            tic;
            sl2d1 = SLgetShearletSystem2D(useGPU,size(X,1),size(X,2),4,[0 0 1 1]);
            if useGPU
                wait(g)
            end;
            timeElapsed(1,1) = toc;
        end        
        %SL2D2
        if testSL2D2
            tic;
            sl2d2 = SLgetShearletSystem2D(useGPU,size(X,1),size(X,2),4,[1 1 2 2]);
            if useGPU
                wait(g);
            end;
            timeElapsed(1,2) = toc;
        end
        %NSST
        if testNSST
            tic;
            shear_parameters.dcomp = [3 3 4 4];
            shear_parameters.dsize = [32 32 16 16];
            timeElapsed(1,3) = toc;
            rmsnsst = SLPaperImageDenoisingGetRMS( size(X,1),size(X,2),'NSST', shear_parameters.dcomp,shear_parameters.dsize);
        end
        %NSCT
        if testNSCT
            tic;
            levels = [3,3,4,4];
            dfilt = 'dmaxflat7';
            pfilt = 'maxflat';
            timeElapsed(1,4) = toc;
            rmsnsct = SLPaperImageDenoisingGetRMS( size(X,1),size(X,2),'NSCT', levels,dfilt,pfilt);
        end

        %SWT
        if testSWT
            tic;
            swtN = 4;
            swtName = 'sym4';
            timeElapsed(1,5) = toc;
            rmsswt = SLPaperImageDenoisingGetRMS(size(X,1),size(X,2),'SWT',swtN,swtName);
        end

        %FDCT
        if testFDCT
            tic;
            isreal = 1;
            finest = 2;
            nbscales = 5;
            nbangles = 8;
            timeElapsed(1,6) = toc;
            rmsfdct = SLPaperImageDenoisingGetRMS(size(X,1),size(X,2),'FDCT',isreal,finest,nbscales,nbangles);
        end
        
        %% do experiments
        for i_sigma = 1:length(sigmas)
            
            sigma = sigmas(i_sigma);

            %add noise
            Xnoisy = X + sigma*randn(size(X));
            noisypsnr(i_img,i_sigma) = SLcomputePSNR(X,Xnoisy);
            
            if useGPU
                wait(g);
            end;
            
            %% SL2D1        
            if testSL2D1
                tic;       
                if useGPU
                    coeffssl2d1 = SLsheardec2D(gpuArray(Xnoisy),sl2d1);
                else
                    coeffssl2d1 = SLsheardec2D(Xnoisy,sl2d1);
                end;
                for j = 1:sl2d1.nShearlets
                    idx = sl2d1.shearletIdxs(j,:);
                    coeffssl2d1(:,:,j) = coeffssl2d1(:,:,j).*(abs(coeffssl2d1(:,:,j)) >= thresholdingFactor(idx(2)+1)*sigma*sl2d1.RMS(j));
                end
                Xrec = SLshearrec2D(coeffssl2d1,sl2d1);
                if useGPU
                    Xrec = gather(Xrec);
                    wait(g);
                end;
                timeElapsed(2,1)= toc;
                if saveImage
                    save results/sl2d1 Xrec;
                end;
                results(i_img,i_sigma,1) = results(i_img,i_sigma,1) + SLcomputePSNR(Xrec,X);
            end
            disp('SL2D1');
            %% SL2D2
            if testSL2D2
                tic;
                if useGPU
                    coeffssl2d2 = SLsheardec2D(gpuArray(Xnoisy),sl2d2);
                else
                    coeffssl2d2 = SLsheardec2D(Xnoisy,sl2d2);
                end;                
                
                for j = 1:sl2d2.nShearlets
                    idx = sl2d2.shearletIdxs(j,:);
                    coeffssl2d2(:,:,j) = coeffssl2d2(:,:,j).*(abs(coeffssl2d2(:,:,j)) >= thresholdingFactor(idx(2)+1)*sl2d2.RMS(j)*sigma);
                end
                Xrec = SLshearrec2D(coeffssl2d2,sl2d2);
                if useGPU
                    Xrec = gather(Xrec);
                    wait(g);
                end;
                timeElapsed(2,2)= toc;
                if saveImage
                    save results/sl2d2 Xrec;
                end;
                results(i_img,i_sigma,2) = results(i_img,i_sigma,2)+ SLcomputePSNR(Xrec,X);
            end;
            disp('SL2D2');

            %% NSST
            if testNSST
                tic;
                [coeffsnsst, filters] = nsst_dec2(Xnoisy,shear_parameters,'maxflat');
                for j = 1:size(coeffsnsst,2)
                    for k = 1:size(coeffsnsst{j},3)
                        coeffsnsst{j}(:,:,k) = coeffsnsst{j}(:,:,k).*(abs(coeffsnsst{j}(:,:,k)) >= thresholdingFactor(j)*sigma*rmsnsst(j,k));
                    end                
                end
                Xrec = nsst_rec2(coeffsnsst,filters,'maxflat');      
                timeElapsed(2,3) = toc;
                if saveImage
                    save results/nsst Xrec;
                end;
                results(i_img,i_sigma,3) = results(i_img,i_sigma,3) + SLcomputePSNR(Xrec,X);
            end
            disp('NSST');
            %% NSCT
            if testNSCT
                tic;
                coeffsnsct = nsctdec(Xnoisy, levels,dfilt,pfilt);
                for j = 1:size(coeffsnsct,2)
                    if iscell(coeffsnsct{j})                
                        for k = 1:size(coeffsnsct{j},2)
                            coeffsnsct{j}{k} = coeffsnsct{j}{k}.*(abs(coeffsnsct{j}{k}) >= thresholdingFactor(j)*sigma*rmsnsct(j,k));
                        end
                    else
                        coeffsnsct{j} = coeffsnsct{j}.*(abs(coeffsnsct{j}) >= thresholdingFactor(j)*sigma*rmsnsct(j,1));

                    end
                end
                Xrec = nsctrec(coeffsnsct,dfilt,pfilt);
                timeElapsed(2,4)= toc;
                if saveImage
                    save results/nsct Xrec;
                end;
                results(i_img,i_sigma,4) = results(i_img,i_sigma,4) + SLcomputePSNR(Xrec,X);
            end
            disp('NSCT');

            %% SWT
            if testSWT
                tic;
                coeffsswt = swt2(Xnoisy,swtN,swtName);
                for j = 1:size(coeffsswt,3)
                    scale = (size(coeffsswt,3)-1)/3+1 - floor((j-1)/3);
                    coeffsswt(:,:,j) = coeffsswt(:,:,j).*(abs(coeffsswt(:,:,j)) >= thresholdingFactor2(scale)*sigma*rmsswt(j));
                end
                Xrec = iswt2(coeffsswt,swtName);
                timeElapsed(2,5)= toc;
                if saveImage
                    save results/swt Xrec;
                end;
                results(i_img,i_sigma,5) = results(i_img,i_sigma,5) + SLcomputePSNR(Xrec,X);
            end
            disp('SWT');

            %% FDCT
            if testFDCT
                tic;
                coeffsfdct = fdct_wrapping(Xnoisy,isreal,finest,nbscales,nbangles);
                for j = 2:length(coeffsfdct)
                    thresh = 3*sigma + sigma*(j == length(coeffsfdct));
                    for k = 1:length(coeffsfdct{j})
                        coeffsfdct{j}{k} = coeffsfdct{j}{k}.*(abs(coeffsfdct{j}{k}) > thresh*rmsfdct(j,k));
                    end
                end
                Xrec = real(ifdct_wrapping(coeffsfdct,isreal,size(X,1),size(X,2)));
                timeElapsed(2,6)= toc;
                if saveImage
                    save results/fdct Xrec;
                end;
                results(i_img,i_sigma,6) = results(i_img,i_sigma,6)+ SLcomputePSNR(Xrec,X);
            end
            disp('FDCT');
            
            disp([i_img, i_sigma]);
        end
    end  
end
if saveImage
    save results/Xnoisy Xnoisy;
    save results/X X;
end;

if savePSNR
    save results_denoising_2d results;
    save results_denoising_2d_time timeElapsed;
end;
disp(results)

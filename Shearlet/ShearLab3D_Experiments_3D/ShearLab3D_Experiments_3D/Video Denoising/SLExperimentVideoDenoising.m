clear;
%% setup
thresholdingFactor = [3 3 3 3 4]; %factors associated with the thresholds on different scales of the shearlet transform
sigmas = [30,40];  %different standard deviations of Gaussian white noise  used in the experiment
videos = {'data_denoising_3d/mobile2_sequence.mat'};%the videos used in the experiment
testSL3D1 = 1; %test shearlet system SL3D1 (3 scales, redundancy 76)
testSL3D2 = 0; %test shearlet system SL3D2 (3 scales, redundancy 292)
testSL2D2 = 0; %test shearlet system SL2D2 (4 scales, redundancy 49), only 2d denoising
useGPU = 0; %use CUDA

savePSNR = 0;  %save PSNR results on hard disk
saveVideo = 0; %save denoised videos on hard disk




results = zeros(size(videos,2),length(sigmas),3);
timeElapsed = zeros(3);



for i_video = 1:size(videos,2)

    video = videos{i_video};
    load(video);
    X = double(X);

    %SL3D1
    if testSL3D1
        scales1 = 3;
        shearLevels1 = [0, 0, 1];        
    end

    %SL3D2
    if testSL3D2
        scales2 = 3;
        shearLevels2 = [1, 1, 2];       
    end


    %SL2D2
    if testSL2D2
        sl2d2 = SLgetShearletSystem2D(useGPU,size(X,1),size(X,2),4,[1 1 2 2]);
    end

    if useGPU
        g = gpuDevice;
        wait(g);
    end;
    for i_sigma = 1:length(sigmas)
        sigma = sigmas(i_sigma);

        Xnoisy = X + sigma*randn(size(X));

        %% SL3D1
        if testSL3D1
            tic;
            Xrec = SLExperimentDenoise3D(Xnoisy,sigma,thresholdingFactor,'SL3D1',useGPU,scales1,shearLevels1);
            if useGPU
                wait(g);
            end;
            timeElapsed(1) = toc;
            if saveVideo
                save results/sl3d1 Xrec;
            end
            results(i_video,i_sigma,1) = results(i_video,i_sigma,1) + SLcomputePSNR(Xrec,X);
        end
        disp('SL3D1');

        %% SL3D2
        if testSL3D2

            tic;
            Xrec = SLExperimentDenoise3D(Xnoisy,sigma,thresholdingFactor,'SL3D2',useGPU,scales2,shearLevels2);
            if useGPU 
                wait(g);
            end;
            timeElapsed(2) = toc;

            if saveVideo
                save results/sl3d2 Xrec
            end;
            results(i_video,i_sigma,2) = results(i_video,i_sigma,2) + SLcomputePSNR(Xrec,X);
        end
        disp('SL3D2');

        %% SL2D2
        if testSL2D2

            tic;
            Xrec = SLExperimentDenoise3D(Xnoisy,sigma,thresholdingFactor2,'SL2D2',sl2d2);

            timeElapsed(5) = toc;
            if saveVideo
                save results/sl2d2 Xrec;
            end;
            results(i_video,i_sigma,3) = results(i_video,i_sigma,3) + SLcomputePSNR(Xrec,X);
        end
        disp('SL2D2');

        disp([i_video,i_sigma]);
    end
end

display(results);
if savePSNR
    save results_denoising_3d results;
end;




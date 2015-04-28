%% setup

iterations = 10; %number of iterations during iterative thresholding
stopFactor = 1.0e-02; % the highest coefficent times stopFactor is the lowest threshold used during iterative thresholding
sizeX = 192;sizeY = 192;sizeZ = 192; %size of videos
masks = {'data_inpainting_3d/mask_rand'}; %masks used in the experiment
videos = {'data_denoising_3d/mobile2_sequence.mat'}; %videos used in the experiment
testSL3D1 = 1; %test shearlet system SL3D1 (3 scales, redundancy 76)
testSL3D2 = 0; %test shearlet system SL3D2 (3 scales, redundancy 292)
testSL2D2 = 0; %test shearlet system SL2D2 (4 scales, redundancy 49), only 2d denoising
useGPU = 0; %use CUDA

savePSNR = 0;  %save PSNR results on hard disk
saveVideo = 0; %save denoised videos on hard disk




results = zeros(size(videos,2),size(masks,2),3);

timeElapsed = zeros(3);

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
    sl2d2 = SLgetShearletSystem2D(useGPU,sizeX,sizeY,4,[1 1 2 2]);
end


if useGPU
    g = gpuDevice();
    wait(g);
end;

for i_video = 1:size(videos,2);        
    load(videos{i_video});        
    video = double(X);
    for i_mask = 1:size(masks,2)
        load(masks{i_mask});

        mask = double(mask > 254);

        videoMasked = video.*mask;

        %SL3D1
        if testSL3D1
            tic;
            videoInpainted = real(SLExperimentInpaint3D(videoMasked,mask,iterations,stopFactor,'SL3D1',useGPU,scales1,shearLevels1));
            if useGPU
                wait(g);
            end;
            timeElapsed(1) = toc;
            if saveVideo
                save results/sl3d1 videoInpainted;
            end;
            results(i_video,i_mask,1) = results(i_video,i_mask,1) + SLcomputePSNR(videoInpainted,video);
        end
        disp('SL3D1');

        %SL3D2
        if testSL3D2
            tic;
            videoInpainted = real(SLExperimentInpaint3D(videoMasked,mask,iterations,stopFactor,'SL3D2',useGPU,scales2,shearLevels2));
            if useGPU
                wait(g);
            end;
            timeElapsed(2) = toc;
            if saveVideo
                save results/sl3d2 videoInpainted;
            end;
            results(i_video,i_mask,2) = results(i_video,i_mask,2) + SLcomputePSNR(videoInpainted,video);
        end
        disp('SL3D2');

        %SL2D2
        if testSL2D2
            tic;
            videoInpainted = real(SLExperimentInpaint3D(videoMasked,mask,iterations,stopFactor,'SL2D2',sl2d2));
            if useGPU
                wait(g);
            end;
            timeElapsed(4) = toc;
            if saveVideo
                save results/sl2d2 videoInpainted;
            end;
            results(i_video,i_mask,3) = results(i_video,i_mask,3) + SLcomputePSNR(videoInpainted,video);
        end
        disp('SL2D2');
    end
end


disp(results);
if savePSNR
    save results_inpainting_3d results;
end;

if saveVideo
    save results/video video;
    save results/videoMasked videoMasked;
end;
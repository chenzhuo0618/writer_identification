%% setup

nExperiment = 1;
iterations = 10;
stopFactor = 1.0e-02;
sizeX = 192;
sizeY = 192;
sizeZ = 192;

masks = {'data_inpainting_3d/mask_rand','data_inpainting_3d/mask_cubes'};
videos = {'data_denoising_3d/mobile2_sequence.mat','data_denoising_3d/coastguard_sequence.mat'};

testSL3D1 = 1;
testSL3D2 = 1;
testSURF = 1;
testSL2D2 = 1;

savePSNR = 0;
saveVideo = 0;

useGPU = 0;


results = zeros(size(videos,2),size(masks,2),4);

timeElapsed = zeros(4);

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

%SURF
if testSURF
    Pyr_mode = 1;
    Lev_array = {[-1 3 3; 3 -1 3; 3 3 -1],[-1 3 3; 3 -1 3; 3 3 -1],[-1 2 2; 2 -1 2; 2 2 -1],[-1 1 1; 1 -1 1; 1 1 -1]};
    bo = 8;
    if exist('surfscalars.mat', 'file')
        load surfscalars.mat;
    else
        surfscalars = SLPaperGetRMS3D(size(X,1),size(X,2),size(X,3),'SURF',Pyr_mode,Lev_array,bo);
        save surfscalars surfscalars;
    end
end


%SL2D2
if testSL2D2
    sl2d2 = SLgetShearletSystem2D(useGPU,sizeX,sizeY,4,[1 1 2 2]);
end


if useGPU
    g = gpuDevice();
    wait(g);
end;

for i_n = 1:nExperiment
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
                videoInpainted = real(SLPaperInpaint3D(videoMasked,mask,iterations,stopFactor,'SL3D1',useGPU,scales1,shearLevels1));
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
                videoInpainted = real(SLPaperInpaint3D(videoMasked,mask,iterations,stopFactor,'SL3D2',useGPU,scales2,shearLevels2));
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
        
            
            %SURF
            if testSURF
                tic;
                videoInpainted = real(SLPaperInpaint3D(videoMasked,mask,iterations,stopFactor,'SURF',Pyr_mode,Lev_array,bo,surfscalars));                
                timeElapsed(3) = toc;
                if saveVideo
                    save results/surf videoInpainted;
                end;
                results(i_video,i_mask,3) = results(i_video,i_mask,3) + SLcomputePSNR(videoInpainted,video);
            end
            disp('SURF');            
           
            %SL2D2
            if testSL2D2
                tic;
                videoInpainted = real(SLPaperInpaint3D(videoMasked,mask,iterations,stopFactor,'SL2D2',sl2d2));
                if useGPU
                    wait(g);
                end;
                timeElapsed(4) = toc;
                if saveVideo
                    save results/sl2d2 videoInpainted;
                end;
                results(i_video,i_mask,4) = results(i_video,i_mask,4) + SLcomputePSNR(videoInpainted,video);
            end
            disp('SL2D2');
        end
    end
end

disp(results);
if savePSNR
    save results_inpainting_3d_neu results;
    save results_inpainting_3d_time_neu timeElapsed;
end;

if saveVideo
    save results/video video;
    save results/videoMaske videoMasked;
end;
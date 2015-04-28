clear;
%% setup
nExperiments = 1;
thresholdingFactor = [3 3 3 4];
thresholdingFactor2 = [0 2.5 2.5 3.8];
sigmas = [10,20,30,40,50];
videos = {'data_denoising_3d/mobile2_sequence.mat','data_denoising_3d/coastguard_sequence.mat','data_denoising_3d/tennis.mat'};


testSL3D1 = 1;
testSL3D2 = 1;
testSURF = 1;
testNSST3D = 1;
testSL2D2 = 1;

savePSNR = 0;
saveVideo = 0;

useGPU = 0;



results = zeros(size(videos,2),length(sigmas),5);
timeElapsed = zeros(5);



for i_n = 1:nExperiments
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
        
        %SURF
        if testSURF
            Pyr_mode = 1;
            Lev_array = {[-1 3 3; 3 -1 3; 3 3 -1],[-1 3 3; 3 -1 3; 3 3 -1],[-1 2 2; 2 -1 2; 2 2 -1],[-1 1 1; 1 -1 1; 1 1 -1]};
            bo = 8;
            if exist('rmsscalars.mat', 'file')
                load rmsscalars.mat;
            else
                rmsscalars = SLPaperGetRMS3D(size(X,1),size(X,2),size(X,3),'SURF',Pyr_mode,Lev_array,bo);
                save rmsscalars rmsscalars;
            end
        end
        
                
        %testNSST3D
        if testNSST3D
            dataClass = 'double';
            filterDilationType = '422';
            filterType = 'meyer';
            level = 3;            
            dBand={{[ 8  8]}, ... %%%%for level =1
                   {[8 8 ],[6 6]}, ...  %%%% for level =2
                   {[8 8 ], [4 4],[4 4]}, ...   %%%% for level =3
                   {[8 8],[8 8],[4 4],[4 4]}}; %%%%% for level =4                 
            filterSize=[24 24 24 24];
            load(['nsstScalarsData' regexprep( num2str( [level dBand{level}{:}]) ,'[^\w'']','') '.mat']);            
            rmsnsst = nsstScalars;
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
                Xrec = SLPaperDenoise3D(Xnoisy,sigma,thresholdingFactor,'SL3D1',useGPU,scales1,shearLevels1);
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
                Xrec = SLPaperDenoise3D(Xnoisy,sigma,thresholdingFactor,'SL3D2',useGPU,scales2,shearLevels2);
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
            
            %% SURF
            if testSURF
                tic;
                Xrec = SLPaperDenoise3D(Xnoisy,sigma,thresholdingFactor,'SURF',Pyr_mode,Lev_array,bo,rmsscalars);
                timeElapsed(3) = toc;
                if saveVideo
                    save results/surf Xrec;
                end
                results(i_video,i_sigma,3) = results(i_video,i_sigma,3) + SLcomputePSNR(Xrec,X);
            end
            disp('SURF');
            
            %% NSST3D
            if testNSST3D
                tic;
                Xrec = SLPaperDenoise3D(Xnoisy,sigma,thresholdingFactor,'NSST3D',dataClass,filterDilationType,filterType,level,dBand,filterSize,rmsnsst);
                timeElapsed(4) = toc;
                if saveVideo
                    save results/nsst3d Xrec;
                end;
                results(i_video,i_sigma,4) = results(i_video,i_sigma,4) + SLcomputePSNR(Xrec,X);
            end
            disp('NSST3D');
            
            %% SL2D2
            if testSL2D2
                
                tic;
                Xrec = SLPaperDenoise3D(Xnoisy,sigma,thresholdingFactor2,'SL2D2',sl2d2);
                
                timeElapsed(5) = toc;
                if saveVideo
                    save results/sl2d2 Xrec;
                end;
                results(i_video,i_sigma,5) = results(i_video,i_sigma,5) + SLcomputePSNR(Xrec,X);
            end
            disp('SL2D2');
            
            disp([i_video,i_sigma]);
        end
    end
end
display(results);
if savePSNR
    save results_denoising_3d_2 results;
    save results_denoising_3d_time_2 timeElapsed;
end;




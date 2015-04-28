
N = 150; % the number of random points
iterations = 100;
scales = 4;
gamma = 3;
stopFactor = 3;
freqWeights = [.1, .1, 2, 2];
nExperiments = 1;
sizeX = 256;
sizeY = 256;

testSL2D1 = 1;
testSL2D2 = 1;
testNSST = 1;
testFDCT = 1;

saveImages = 0;
saveResults = 0;




results = zeros(sizeX,2,4);

timeElapsed = zeros(1,4);

%SL2D1
if testSL2D1
    sl2d1 = SLgetShearletSystem2D(0,sizeX,sizeY,4,[0 0 1 1]);
end
%SL2D2
if testSL2D2
    sl2d2 = SLgetShearletSystem2D(0,sizeX,sizeY,4,[1 1 2 2]);
end
%NSST
if testNSST
    shear_parameters.dcomp = [3 3 4 4];
    shear_parameters.dsize = [32 32 16 16];
    rmsnsst = SLPaperImageDenoisingGetRMS( sizeX,sizeY,'NSST', shear_parameters.dcomp,shear_parameters.dsize);
end

%FDCT
if testFDCT
    isreal = 1;
    finest = 1;
    nbscales = 5;
    nbangles = 8;
    rmsfdct = SLPaperImageDenoisingGetRMS(sizeX,sizeY,'FDCT',isreal,finest,nbscales,nbangles);
end

for i = 1:nExperiments
    %generate test image
    %[img,imgCurves,imgPoints] = SLgetSeparationTestImage(N);
    load imgCurves;
    load imgPoints;
    load imgSeparation;
    %SL2D1
    if testSL2D1
        tic;
        [imgCurvesRec, imgPointsRec] = SLseparate(img,scales,iterations,stopFactor,gamma,freqWeights,'SL2D1',sl2d1);
        timeElapsed(1) = toc;
        
        imgPointsRec = (imgPointsRec - min(imgPointsRec(:)))*(255/max(max(imgPointsRec - min(imgPointsRec(:)))));
        imgCurvesRec = (imgCurvesRec - min(imgCurvesRec(:)))*(255/max(max(imgCurvesRec - min(imgCurvesRec(:)))));
        

        
        [mPoints,mCurves,thresholds] = SLPaperImageSeparationMeasure(imgPointsRec,imgCurvesRec,imgPoints,imgCurves);

        results(:,1,1) = mPoints;
        results(:,2,1) = mCurves;
        
        [C,idxPoints] = min(mPoints);
        [C,idxCurves] = min(mCurves);
        
        imgPointssl2d1 = 255*(imgPointsRec > thresholds(idxPoints));
        imgCurvessl2d1 = 255*(imgCurvesRec > thresholds(idxCurves));

        if saveImages
            save results/sl2d1_curves imgCurvessl2d1;
            save results/sl2d1_points  imgPointssl2d1;
        end;
    end
    %SL2D2
    if testSL2D2
        tic;
        [imgCurvesRec, imgPointsRec] = SLseparate(img,scales,iterations,stopFactor,gamma,freqWeights,'SL2D2',sl2d2);

        timeElapsed(2) = toc;
        
        imgPointsRec = (imgPointsRec - min(imgPointsRec(:)))*(255/max(max(imgPointsRec - min(imgPointsRec(:)))));
        imgCurvesRec = (imgCurvesRec - min(imgCurvesRec(:)))*(255/max(max(imgCurvesRec - min(imgCurvesRec(:)))));

        
        [mPoints,mCurves,thresholds] = SLPaperImageSeparationMeasure(imgPointsRec,imgCurvesRec,imgPoints,imgCurves);
        
        results(:,1,2) = mPoints;
        results(:,2,2) = mCurves;    
        
        [C,idxPoints] = min(mPoints);
        [C,idxCurves] = min(mCurves);
        
        imgPointssl2d2 = 255*(imgPointsRec > thresholds(idxPoints));
        imgCurvessl2d2 = 255*(imgCurvesRec > thresholds(idxCurves));

        if saveImages
            save results/sl2d2_curves imgCurvessl2d2;
            save results/sl2d2_points  imgPointssl2d2;
        end;
    end
    %NSST
    if testNSST
        tic;
        [imgCurvesRec, imgPointsRec] = SLseparate(img,scales,iterations,stopFactor,gamma,freqWeights,'NSST',shear_parameters.dcomp,shear_parameters.dsize,rmsnsst);
        timeElapsed(3) = toc;
        
        imgPointsRec = (imgPointsRec - min(imgPointsRec(:)))*(255/max(max(imgPointsRec - min(imgPointsRec(:)))));
        imgCurvesRec = (imgCurvesRec - min(imgCurvesRec(:)))*(255/max(max(imgCurvesRec - min(imgCurvesRec(:)))));

        [mPoints,mCurves,thresholds] = SLPaperImageSeparationMeasure(imgPointsRec,imgCurvesRec,imgPoints,imgCurves);
        
        results(:,1,3) = mPoints;
        results(:,2,3) = mCurves;    
        
        [C,idxPoints] = min(mPoints);
        [C,idxCurves] = min(mCurves);
        
        imgPointsnsst = 255*(imgPointsRec > thresholds(idxPoints));
        imgCurvesnsst = 255*(imgCurvesRec > thresholds(idxCurves));

        if saveImages
            save results/nsst_curves imgCurvesnsst;
            save results/nsst_points  imgPointsnsst;
        end;
    end

    %FDCT
    if testFDCT
        tic;
        [imgCurvesRec, imgPointsRec] = SLseparate(img,scales,iterations,stopFactor,gamma,freqWeights,'FDCT',isreal,finest,nbscales,nbangles,rmsfdct);
        timeElapsed(4) = toc;
        
        imgPointsRec = (imgPointsRec - min(imgPointsRec(:)))*(255/max(max(imgPointsRec - min(imgPointsRec(:)))));
        imgCurvesRec = (imgCurvesRec - min(imgCurvesRec(:)))*(255/max(max(imgCurvesRec - min(imgCurvesRec(:)))));

        [mPoints,mCurves,thresholds] = SLPaperImageSeparationMeasure(imgPointsRec,imgCurvesRec,imgPoints,imgCurves);
        
        results(:,1,4) = mPoints;
        results(:,2,4) = mCurves;  
        
        [C,idxPoints] = min(mPoints);
        [C,idxCurves] = min(mCurves);
        
        imgPointsfdct = 255*(imgPointsRec > thresholds(idxPoints));
        imgCurvesfdct = 255*(imgCurvesRec > thresholds(idxCurves));

        if saveImages
            save results/fdct_curves imgCurvesfdct;
            save results/fdct_points  imgPointsfdct;
        end;
    end     
end

figure;
hold on;
plot(squeeze(results(:,1,1)),'Color','green');
plot(squeeze(results(:,1,2)),'Color','red');
plot(squeeze(results(:,1,3)),'Color','black');
plot(squeeze(results(:,1,4)),'Color','blue');

figure;
hold on;
plot(squeeze(results(:,2,1)),'Color','green');
plot(squeeze(results(:,2,2)),'Color','red');
plot(squeeze(results(:,2,3)),'Color','black');
plot(squeeze(results(:,2,4)),'Color','blue');

if saveResults
    save results_separation_2d results;
    save results_separation_2d_time timeElapsed;
end

sizeX=512;
sizeY=512;
data=randn(sizeX,sizeY);
useGPU=0;

%prepare serial processing
[Xfreq,Xrec,preparedFilters,dualFrameWeightsCurr,shearletIdxs]=SLprepareSerial2D(useGPU,data,4);

for j=1:size(shearletIdxs,1)
    shearletIdx=shearletIdxs(j,:);
    
    %shearlet decomposition
    [coefficients,shearlet,dualFrameWeightsCurr,RMS]=SLsheardecSerial2D(Xfreq,shearletIdx,preparedFilters,dualFrameWeightsCurr);
    
    %add process here
end
system=SLgetShearletSystem2D(useGPU,sizeX,sizeY,4);
shearletCoefficients=SLsheardec2D(data,system);

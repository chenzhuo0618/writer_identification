function [wedge, bandpass, lowpass] = SLgetWedgeBandpassAndLowpassFilters2D(rows,cols,shearLevels,directionalFilter,quadratureMirrorFilter)
%GET_WEDGE_AND_BANDPASS_FILTERS Summary of this function goes here
%   Detailed explanation goes here

%% check number of input parameters and assign default values
if nargin < 3
    error('Not enough input parameters!');
end

if nargin < 5
    quadratureMirrorFilter = [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,...
                              0.276348304703363,0.582566738241592,0.276348304703363,...
                              -0.0517766952966369,-0.0263483047033631,0.0104933261758408];
    if nargin < 4
        % load directional filter
        directionalFilter = modulate2(dfilters('dmaxflat4','d')./sqrt(2),'c');
        %directionalFilter = modulate2(dfilters('cd','d')./sqrt(2),'c');
    end
end

%% initialise variables

%get number of scales
NScales = length(shearLevels);

%allocate filters
bandpass = zeros(rows,cols,NScales);
wedge = cell(1,max(shearLevels)+1);



%% compute 1D high and lowpass filters at different scales for wavelet part
%normalize directional filter
directionalFilter = directionalFilter/sum(abs(directionalFilter(:)));

%Note that qmf filters are needed both for computing the bandpass filters and
%the wedge filters. max(NScales, max(shearLevels)+1) determines the highest scale
%for which qmf filters have to be computed.
qmfHigh = cell(1,max(NScales, max(shearLevels)+1));
qmfLow = cell(1,size(qmfHigh,2));

qmfLow{size(qmfLow,2)} = quadratureMirrorFilter;
qmfHigh{size(qmfHigh,2)} = MirrorFilt(qmfLow{size(qmfLow,2)});       

for j = size(qmfHigh,2)-1:-1:1
    qmfLow{j} = conv(qmfLow{size(qmfLow,2)},dyadup(qmfLow{j+1},2));
    qmfHigh{j} = conv(qmfLow{size(qmfLow,2)},dyadup(qmfHigh{j+1},2));
end

%% compute bandpass filters for all scales
for j = (size(qmfHigh,2)-NScales+1):size(qmfHigh,2)
    if length(qmfHigh{j}) > cols
        error(['The specified Shearlet system is not available for data of size ', num2str(rows) ,'x',num2str(cols), '. You can decrease the number of scales and shearings or specify a different directional filter and or quadrature mirror filter.']);
    end
    bandpass(ceil(rows/2),floor((cols - length(qmfHigh{j}))/2+1):(floor((cols - length(qmfHigh{j}))/2)+length(qmfHigh{j})),j-(size(qmfHigh,2)-NScales)) = qmfHigh{j};
    bandpass(:,:,j-(size(qmfHigh,2)-NScales))= fftshift(fft2(bandpass(:,:,j-(size(qmfHigh,2)-NScales))));
end


%% compute wedge filter for each shearing
for shearLevel = unique(shearLevels)
    %preallocate wedge filters at scale j
    wedge{shearLevel+1} = zeros(rows,cols,floor(2^(shearLevel+1)+1)); %plus one for one unsheared shearlet per cone
     
    %vertically upsample diamond filter
    %2^(shearLevelCone) shearings per cone require shearLevelCone
    %upsamplings of the diamondFilter
    diamondFilterHelp = zeros((length(directionalFilter)-1)*2^(shearLevel+1)+1,length(directionalFilter));
    diamondFilterHelp(1:2^(shearLevel+1):size(diamondFilterHelp,1),:) = directionalFilter;

    %remove high horizontal frequencies
    %only the central wedge in the frequency domain of the upsampled
    %diamond filter is required
    wedgeHelp = conv2(diamondFilterHelp,qmfLow{size(qmfLow,2)-shearLevel}','same');
    if size(wedgeHelp,1) > rows ||  size(wedgeHelp,2) > cols 
        error(['The specified Shearlet system is not available for data of size ', num2str(rows) ,'x',num2str(cols), '. You can decrease the number of scales and shearings or specify a different directional filter and or quadrature mirror filter.']);
    end
    wedgeHelp = padarray(wedgeHelp,[floor((rows-size(wedgeHelp,1))/2),floor((cols-size(wedgeHelp,2))/2)]);
    wedgeHelp = padarray(wedgeHelp,[rows-size(wedgeHelp,1),cols-size(wedgeHelp,2)],'post');


    %% compute different shearings

    %upsample wedge horizontally according to current scale
    wedgeUpsampled = zeros(rows,2^shearLevel*cols);
    wedgeUpsampled(:,1:2^shearLevel:2^shearLevel*cols) = wedgeHelp;        

    %construct and apply 2d lowpass filter for sheared wedges to ensure compact
    %support in the time domain        
    lowpassWedges = ones(rows,1)*psf2otf(qmfLow{size(qmfLow,2)-max(shearLevel-1,0)},[1 2^shearLevel*cols]);       

    if shearLevel >= 1
        wedgeUpsampled = ifft2(conj(lowpassWedges).*fft2(wedgeUpsampled));
    end

    %traverse shearings of the upper part of the cone
    for k = -2^shearLevel:2^shearLevel        
        %shear upsampled wedge filter
        %wedgeUpsampledSheared = dshear(wedgeUpsampled,k,0,0,0);
        wedgeUpsampledSheared = SLdshear(wedgeUpsampled,k,2);
        if shearLevel >= 1
            wedgeUpsampledSheared = ifft2(lowpassWedges.*fft2(wedgeUpsampledSheared));
        end
        %obtain downsampled renormalized and sheared wedge filter in the
        %frequency domain
        wedge{shearLevel+1}(:,:,fix(2^shearLevel)+1-k) = fftshift(fft2(2^shearLevel*wedgeUpsampledSheared(:,1:2^shearLevel:2^shearLevel*cols)));            
    end    
end

%% compute low pass filter of shearlet system
lowpass = fftshift(psf2otf(qmfLow{1}'*qmfLow{1},[rows cols]));

end

%
%  Copyright (c) 2013. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.0
%  Built Fri, 30/08/2013
%  This is Copyrighted Material
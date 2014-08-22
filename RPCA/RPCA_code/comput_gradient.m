
function [I_gradx,I_grady,I] = comput_gradient(input_image)

I = double(input_image);
% Imax = max(max(I));
% Imin = min(min(I));
% I = (I-Imin)./(Imax-Imin); % 归一化到[0,1]

[I_gradx,I_grady] = gradient(I); % x,y方向梯度图

I = sqrt((I_gradx).^2 + (I_grady).^2); % 梯度幅值图

% figure
% imshow(I,[])


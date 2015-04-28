function out = SLdshear(in,k,axis)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if k == 0
        out = in;
        return;
    end
    rows = size(in,1);
    cols = size(in,2);

    out = zeros(size(in));
    if axis == 1
        for col = 1:cols
            out(:,col) = circshift(in(:,col),[k * ceil(cols/2-col) 0]);
        end
    else        
        for row = 1:rows
            out(row,:) = circshift(in(row,:),[0 k * ceil(rows/2-row)]);
        end
    end
end

%
%  Copyright (c) 2013. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.0
%  Built Fri, 30/08/2013
%  This is Copyrighted Material
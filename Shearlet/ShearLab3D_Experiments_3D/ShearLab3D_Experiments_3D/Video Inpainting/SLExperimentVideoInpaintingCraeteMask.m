L = 192;

mask = 255*(rand(L,L,L) > 0.8);

save mask_rand mask;

stepsize = 20;


mask = 255*ones(L,L,L);

idx_curr = [stepsize,stepsize,stepsize];

while idx_curr(3) + stepsize < L
    sizeX = floor(rand(1)*5 + 1);
    sizeY = floor(rand(1)*5 + 1);
    sizeZ = floor(rand(1)*5 + 1);

    mask((idx_curr(1)-sizeX):1:(idx_curr(1)+sizeX),(idx_curr(2)-sizeY):1:(idx_curr(2)+sizeY),(idx_curr(3)-sizeZ):1:(idx_curr(3)+sizeZ)) = 0;
    if idx_curr(1) + stepsize < L
        idx_curr(1) = idx_curr(1) + stepsize;
    else
        if idx_curr(2) + stepsize < L
            idx_curr(1) = stepsize;
            idx_curr(2) = idx_curr(2) + stepsize;
        else
            idx_curr(1) = stepsize;
            idx_curr(2) = stepsize;
            idx_curr(3) = idx_curr(3) + stepsize;
        end
    end
end

save mask_cubes mask;
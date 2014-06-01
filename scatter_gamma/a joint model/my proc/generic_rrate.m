function rr = generic_rrate(D,ns,method)
    nimages = size(D,1);
    ii = 1:nimages;
    for q=1:nimages
        [sd,si] = sort(D(q,:),method);
        r(si) = ii;%%图片所对应的位置数组，这个位置是由KL距离决定，升序，距离越小，位置越前，si为图片本来的位置，ii将分配给r产生排序后的位置 
        c = floor((q-1) / ns);%%%% floor向下取整，决定类别
        rr(:, q) = r((c*ns+1):((c+1)*ns))';%% rr前16列，取r的前16个数；rr后16列，取r的后16个数
    end
end
        

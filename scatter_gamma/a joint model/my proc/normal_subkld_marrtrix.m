%%Function normal subband KL distance marrtrix
function NorKLMarrtrix=normal_subkld_marrtrix(KLMarrtrix)

[m,n]=size(KLMarrtrix);
[msize,featurenum]=size(KLMarrtrix(1,1).kld);
maxvetcor=zeros(1,featurenum);

for i=1:m
    for j=1:n
        
        for k=1:featurenum
            if(maxvetcor(k)<KLMarrtrix(i,j).kld(k))
                maxvetcor(k)=KLMarrtrix(i,j).kld(k);
            end
        end
        
    end
end

for i=1:m
    for j=1:n
        
        for k=1:featurenum
            NorKLMarrtrix(i,j).kld(k)=KLMarrtrix(i,j).kld(k)/maxvetcor(k);
            NorKLMarrtrix(i,j).cid=KLMarrtrix(i,j).cid;
        end
        
    end
end


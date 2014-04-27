%%%Function sort the retriveal distance result
function SortingResult=sort_KLDvalue(KLDArray)

[m,n]=size(KLDArray);

for i=1:m
    for j=1:n
        KLD(i,j)=0;
    end
end

for i=1:m
    for j=1:n
        KLD(i,j)=KLD(i,j)+KLDArray(i,j).kld;
    end
end

[TempResult,IX]=sort(KLD,2);
SX=IX(:,1:20);
SortingResult=SX;
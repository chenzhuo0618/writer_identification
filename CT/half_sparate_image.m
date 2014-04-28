%%%
%%%Function half sparate image 
%%%
function [imageA,imageB,imageC,imageD]=half_sparate_image(image)

[m,n]=size(image);

A=zeros(m/2,n/2);
B=zeros(m/2,n/2);
C=zeros(m/2,n/2);
D=zeros(m/2,n/2);

for i=1:m/2
    for j=1:n/2
        A(i,j)=image(i,j);
    end
end

for i=(m/2+1):m
    for j=1:n/2
        p=i-m/2;
        q=j;
        B(p,q)=image(i,j);
    end
end

for i=1:m/2
    for j=(n/2+1):n
        p=i;
        q=j-n/2;
        C(p,q)=image(i,j);
    end
end

for i=(m/2+1):m
    for j=(n/2+1):n
        p=i-m/2;
        q=j-n/2;
        D(p,q)=image(i,j);
    end
end


imageA=A;
imageB=B;    
imageC=C;
imageD=D;
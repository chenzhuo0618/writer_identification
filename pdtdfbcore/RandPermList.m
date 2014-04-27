function [List]=RandPermList(SouceList)

T=[];
D=randperm(8);

for i=1:8
    B=SouceList((D(i)-1)*64+1:D(i)*64,1:64);
    T=[T;B];
end

List=T;
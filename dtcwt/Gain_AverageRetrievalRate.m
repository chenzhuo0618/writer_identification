%%%Function get the average retrieval rate
function [AverRetrievalRate,RR]=Gain_AverageRetrievalRate(SortingResult)

SR=SortingResult(:,1:20);
[m,n]=size(SR);
globe_count=0;
count=[];

for i=1:m  
    rcount=0;
    for j=1:n
        if(20*(i-1)<SR(i,j)&&SR(i,j)<=20*i)
           globe_count=globe_count+1; 
           rcount=rcount+1;
        end
    end  
    count=[count;rcount/20];
end

AverRetrievalRate=globe_count/(m*20);
RR=count;


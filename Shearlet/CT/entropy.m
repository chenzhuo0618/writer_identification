 imagedata=imread('zoneplate.png');
 pfilt='pkva';
 dfilt='pkva';

 x=double(imagedata);
 y=pdfbdec(x, pfilt, dfilt, [2,2,2]);

 %归一化处理，求的归一化后的矩阵
 m=[];M=[];
  for i=1:length(y{1,2})
      m1=min(min(y{1,2}{1,i}));
      M1=max(max(y{1,2}{1,i}));
      m=[m,m1];
      M=[M,M1];
 end  
 
for i=1:length(y{1,3})
      m1=min(min(y{1,3}{1,i}));
      M1=max(max(y{1,3}{1,i}));
      m=[m,m1];
      M=[M,M1];
end  
 
for i=1:length(y{1,4})
      m1=min(min(y{1,4}{1,i}));
      M1=max(max(y{1,4}{1,i}));
      m=[m,m1];
      M=[M,M1];
end 

B=max(M)-min(m);
C=min(m);

A=[];

for i=1:length(y{1,2})
     [m,n]=size(y{1,2}{1,i});
         for j=1:m
             for k=1:n
                A{1,2}{1,i}(j,k)=round(255*((y{1,2}{1,i}(j,k)-C)./B));
             end
         end
end  
 
for i=1:length(y{1,3})
     [m,n]=size(y{1,3}{1,i});
         for j=1:m
             for k=1:n
                A{1,3}{1,i}(j,k)=round(255*((y{1,3}{1,i}(j,k)-C)./B));
             end
         end
end  
 
for i=1:length(y{1,4})
     [m,n]=size(y{1,4}{1,i});
         for j=1:m
             for k=1:n
                A{1,4}{1,i}(j,k)=round(255*((y{1,4}{1,i}(j,k)-C)./B));
             end
         end
end  

%按照熵的定义，求各子带的熵值
a1=0;
 for i=1:length(A{1,2})
     [m,n]=size(A{1,2}{1,i});
     temp=zeros(1,256);
         for j=1:m
             for k=1:n
                 %对图像的灰度值在[0,255]上做统计 
                   if A{1,2}{1,i}(j,k)==0; 
                        p=1; 
                   else 
                        p=A{1,2}{1,i}(j,k); 
                   end 
                   temp(p)=temp(p)+1; 
              end  
         end
         temp=temp./(m*n); 
         %由熵的定义做计算 
         result=0; 
         for q=1:length(temp) 
              if temp(q)==0; 
                result=result; 
              else 
              result=result-temp(q)*log2(temp(q));
              end 
         end
         a1=a1+result;
 end

%按照熵的定义，求各子带的熵值
a2=0;
 for i=1:length(A{1,2})
     [m,n]=size(A{1,2}{1,i});
     temp=zeros(1,256);
         for j=1:m
             for k=1:n
                 %对图像的灰度值在[0,255]上做统计 
                   if A{1,2}{1,i}(j,k)==0; 
                        p=1; 
                   else 
                        p=A{1,2}{1,i}(j,k); 
                   end 
                   temp(p)=temp(p)+1; 
              end  
         end
         temp=temp./(m*n); 
         %由熵的定义做计算 
         result=0; 
         for q=1:length(temp) 
              if temp(q)==0; 
                result=result; 
              else 
              result=result-temp(q)*log2(temp(q));
              end 
         end
         a2=a2+result;
 end
 
 %按照熵的定义，求各子带的熵值
a3=0;
 for i=1:length(A{1,2})
     [m,n]=size(A{1,2}{1,i});
     temp=zeros(1,256);
         for j=1:m
             for k=1:n
                 %对图像的灰度值在[0,255]上做统计 
                   if A{1,2}{1,i}(j,k)==0; 
                        p=1; 
                   else 
                        p=A{1,2}{1,i}(j,k); 
                   end 
                   temp(p)=temp(p)+1; 
              end  
         end
         temp=temp./(m*n); 
         %由熵的定义做计算 
         result=0; 
         for q=1:length(temp) 
              if temp(q)==0; 
                result=result; 
              else 
              result=result-temp(q)*log2(temp(q));
              end 
         end
         a3=a3+result;
 end
 
sum1=a1+a2+a3
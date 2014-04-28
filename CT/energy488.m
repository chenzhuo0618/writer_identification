imagedata=imread('zoneplate.png');
 pfilt='pkva';
 dfilt='pkva';

 x=double(imagedata);
 y=pdfbdec(x, pfilt, dfilt, [2,3,3]);
 
 a1=0;
 for i=1:length(y{1,2})
     [m,n]=size(y{1,2}{1,i});
         for j=1:m
             for k=1:n
                a1=a1+y{1,2}{1,i}(j,k)^2;
             end
         end
 end  
 
a2=0;
for i=1:length(y{1,3})
     [m,n]=size(y{1,3}{1,i});
         for j=1:m
             for k=1:n
                a2=a2+y{1,3}{1,i}(j,k)^2;
             end
         end
end  

a3=0;
for i=1:length(y{1,4})
     [m,n]=size(y{1,4}{1,i});
         for j=1:m
             for k=1:n
                a1=a1+y{1,4}{1,i}(j,k)^2;
             end
         end
 end  

sum3=a1+a2+a3
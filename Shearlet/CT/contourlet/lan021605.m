close all
im=imread('circle.gif');
x=double(im);
pfilt='9-7';
[h, g] = pfilters(pfilt);
for level=1:3
[xlo,xhi]=lpdec(x, h, g);
yhi{level}=xhi;
figure,imshow(xhi,[]);
x=xlo;
end
ylo=xlo
figure,imshow(xlo,[]);
y=[yhi,ylo]
%������Contourlet�е�LP�ֽ�
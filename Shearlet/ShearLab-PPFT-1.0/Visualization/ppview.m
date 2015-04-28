function ppview(s)
%% PPVIEW display data in pp form
%
%% DESCRIPTION
%    PPVIEW(s);
%    display image on a pp grid. 
%    INPUT 
%        s - absolute value of image on a pp grid
%
%% EXAMPLE
%     X = zeros(256);
%     X(129,:) = 1;
%     X = imShear(X,0.5);
%     Y = ppFT(X,2);
%     figure(1);
%     subplot(1,2,1),imshow(X);
%     subplot(1,2,2),ppview(abs(Y));
%
%% See also DISPLAYSHX, PLOTSHEARLETIMAGE


%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

s = round(10^10*s)/10^10; %to scale down the details

[K,M,N]=size(s);

k     = (-M+1)/2:1/2:(M-1)/2;
l     = (-N+1)/2:1/2:(N-1)/2;
[l,k] = meshgrid(l,k);

x(1,:,:) = -2*l.*k/(N-1);
x(2,:,:) = -k;
y(1,:,:) = x(2,:,:);
y(2,:,:) = x(1,:,:);

for sector = 1:2
    
    s2 = squeeze(s(sector,:,:));
    s2 = upsample(s2,2)+upsample(s2,2,1);
    s2 = upsample(s2',2)+upsample(s2',2,1);
    s2 = s2';

    s2(1,:) = [];
    %s2(end,:)=[];
    s2(:,1) = [];
    %s2(:,end)=[];

    pcolor(squeeze(x(sector,:,:)),squeeze(y(sector,:,:)),squeeze(s2));
    shading flat
    hold on
    
end
colorbar
hold off
shg 
return





ss=zeros(K,M+1,N+1);
ss(:,1:M,1:N)=s;

k=(-M+1)/2:(M-1)/2;
l=(-N+1)/2:(N-1)/2;

s(:,1:end-1,1:end-1)=s(:,1:end-1,1:end-1)+s(:,1:end-1,2:end)+s(:,2:end,1:end-1)+s(:,2:end,2:end);
s=s/4;
s(:,(M+1)/2-1,:)=s(:,(M+1)/2-1,:)*2;
s(:,(M+1)/2,:)=s(:,(M+1)/2,:)*2;

[l,k]=meshgrid(l,k);

%r(1,:,:)=k.*sqrt(1+4*l.^2/N.^2);
%r(2,:,:)=k.*sqrt(1+4*l.^2/N.^2);

%t(1,:,:)=pi/2-atan(2*l/N);
%t(1,:,:)=atan(2*l/N);

x(1,:,:)=-2*l.*k/(N-1);
x(2,:,:)=k;

y(1,:,:)=x(2,:,:);
y(2,:,:)=x(1,:,:);


pcolor(squeeze(x(1,:,:)),squeeze(y(1,:,:)),squeeze(s(1,:,:)));
shading flat
hold on
pcolor(squeeze(x(2,:,:)),squeeze(y(2,:,:)),squeeze(s(2,:,:)));
shading flat
axis square
colorbar
hold off
shg
end
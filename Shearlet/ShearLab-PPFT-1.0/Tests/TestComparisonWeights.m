
%% TEST Random Image
for k = 1:0
    R = 8;
    basisSet = 12;%[8,9,10,11];    
    Ns=512;%[32 64 128 256 512];
    n1 = length(basisSet);
    n2 = length(Ns);
    Misom = zeros(n1,n2);
    for b = 1:n1
        basisChoice = basisSet(b);
        for j = 1:length(Ns)
            N = Ns(j);
            Wstr = ['WeightN' num2str(N) 'R' num2str(R) 'P' num2str(basisChoice)];
            load(Wstr); 
            P = basisFunction(N,R,basisChoice);
            avgErr = zeros(1,5);       
            for it = 1:5    
                img = rand(N);
                %disp(['img No.= ' num2str(it)]);
                W1 = WeightGenerate(N,P,W(:,3));
                ppImg = ppFT(img,R);
                timg1 = AdjppFT(W1.*ppImg,R);
                %disp(['smoothwt error1:'
                %num2str(norm(timg1-img,'fro')/norm(img,'fro'))]);
                err0 = norm(timg1-img,'fro')/norm(img,'fro');
                avgErr(it) = err0;
            end
            Misom(b,j) = mean(avgErr);
            disp(['ave error = ' num2str(mean(avgErr))]);
        end
    end
end

%% Test a Real Image
for k = 1:1
    
    R = 8;
    basisSet = 12;% [8,9,10,11];    
    Ns=512;%[32 64 128 256 512];
    n1 = length(basisSet);
    n2 = length(Ns);
    Misom = zeros(n1,n2);
    
    for b = 1:length(basisSet);
        basisChoice = basisSet(b);
        for j = 1:length(Ns)
            N = Ns(j);
            Wstr = ['WeightN' num2str(N) 'R' num2str(R) 'P' num2str(basisChoice)];
            load(Wstr); 
            P = basisFunction(N,R,basisChoice);
            % Real Image Barbara
            img = imread('barbara.gif');
            img = double(img(:,:,1));
            N0 = size(img,1);
            h = N0/N;
            img = img(1:h:end,1:h:end);
            img = img(:,:,1);
            img = double(img);
            
            W1 = WeightGenerate(N,P,W(:,3));
            ppImg = ppFT(img,R);

            timg1 = AdjppFT(W1.*ppImg,R);
            err0 = norm(timg1-img,'fro')/norm(img,'fro');

            Misom(b,j) = mean(err0);
            disp(['ave error = ' num2str(mean(err0))]);
        end
    end
end


clear P;
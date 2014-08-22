
function [traindata,testdata,gnd,tgnd] = genFold(dataset,label,idx,expopt)

% dataset  数据矩阵，行是维数，列是样本
% label    类别标签，比如：label = [1,1,1,1,2,2,2,2,3,3,3,3......]
% idx      每一类用于训练的样本编号
% idy      每一类用于测试的样本编号
% expopt   结构体，expopt.nClass 类别数 ；expopt.nFace 每一类的样本数

nClass = expopt.nClass; % 类别数
nFace = expopt.nFace; % 每一类的样本数
% nTrain = expopt.nTrain;
nTrain = size(idx,2); % 每一类的训练样本数
nTest = nFace - nTrain; % 每一类的测试样本数

idy = [1:nFace];
for i = 1:nTrain
    [ix] = find(idy(:) == idx(i));
    idy(ix) = [];  
end

traindata = [];
testdata = [];
gnd = [];
tgnd = [];

for i = 1:nClass
    for j = 1:nTrain
        traindata = [traindata dataset(:,(i-1)*nFace+idx(j))];
        gnd = [gnd;label((i-1)*nFace + idx(j))];
    end
    
    for j = 1:nTest
        testdata = [testdata dataset(:,(i-1)*nFace+idy(j))];
        tgnd = [tgnd;label((i-1)*nFace + idy(j))];
    end
end


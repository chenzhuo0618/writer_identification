
load spiral.mat
patterns = patterns';
N = length(targets);             % Number of patterns
Original_dim = size(patterns,2); % Number of original features
dim = size(patterns,2);          % Data dimenionality

% divNum =  sqrt(sum(patterns.^2,1));
% patterns = bsxfun(@rdivide, patterns,divNum);
[MIN,I] = min(patterns,[],1);
[MAX,I] = max(patterns,[],1);
for n=1:dim
    if (MAX(n)-MIN(n))==0
        patterns(:,n)=0;
    else
        patterns(:,n) = (patterns(:,n)-MIN(n))/(MAX(n)-MIN(n));
    end
end

%parameters
Para.lambda =0.01;         % regularization parameter
Para.perplexity = 15;
s = cputime;
Weight= FldlByGradient(patterns, Para);
Weight;

CPUTime = cputime-s;
disp(['>>> The total CPU time is ' num2str(CPUTime) ' seconds.'])
figure;
semilogx(Weight/max(Weight),'-o','LineWidth',1,'MarkerFaceColor','w','MarkerSize',10)
hold on
plot([Original_dim,Original_dim],[0,1],'r--', 'LineWidth',2);
xlabel('Features')
ylabel('Feature Weights')
boldify1
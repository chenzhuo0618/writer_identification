function ydata= FldlByGradient(X,para)

perplexity = para.perplexity;
lambda = para.lambda;
% Initialize some variables
[n,dim] = size(X);                                     % number of instances
momentum = 0.1;                                     % initial momentum
final_momentum = .4;                               % value to which momentum is changed
mom_switch_iter = 200;                              % iteration at which momentum is changed
max_iter = 300;                                    % maximum number of iterations
epsilon = 100;                                      % initial learning rate
min_gain = .01;

P = xx2p(X,perplexity, 1e-5);                                               % compute affinities using fixed perplexity
P = 0.5 * (P + P');
P(1:n+1:end) = 0;  % make symmetric
Pcount = sum(P(:));
P = P ./ Pcount;                                                        % obtain estimation of joint probabilities
P = max(P, eps);
P = P * 4;                                                                  % prevent local minima by lying about P-vals

% Initialize the solution
ydata =1*rand(dim,1);

y_incs  = zeros(size(ydata));
gains = ones(size(ydata));
for iter=1:max_iter
    [Q, y_grads] = computeMidV(X,P, ydata,lambda);
    % Update the solution
    gains = (gains + .4) .* (sign(y_grads) ~= sign(y_incs)) ...            % note that the y_grads are actually -y_grads
        + (gains * .6) .* (sign(y_grads) == sign(y_incs));
    gains(gains < min_gain) = min_gain;
    y_incs = momentum * y_incs- epsilon * (gains .* y_grads);
    ydata = ydata + y_incs
    
    % Update the momentum if necessary
    if iter == mom_switch_iter
        momentum = final_momentum;
    end
    if iter == 100
        P = P ./4;
    end
    ydata = abs(ydata);
    
    if ~rem(iter, 10)
        rowsum = sum(P .* log((P + eps) ./ (Q + eps)));
        cost2 = sum(rowsum);
        disp(['Iteration2 ' num2str(iter) ': error is ' num2str(cost2)]);
        [va, pointX] = max(rowsum);
        disp(['Iteration ' num2str(iter) ': max error at point is: ' num2str(pointX) 'and error is:' num2str(va)]);
    end
end
ydata = ydata.^2;



function P = xx2p(X, u, tol)

if ~exist('u', 'var') || isempty(u)
    u = 30;
end
if ~exist('tol', 'var') || isempty(tol)
    tol = 1e-4;
end

% Initialize some variables
n = size(X, 1);                     % number of instances
P = zeros(n, n);                    % empty probability matrix
beta = ones(n, 1);                  % empty precision vector
logU = log(u);                      % log of perplexity (= entropy)


% Compute pairwise distances
disp('Computing pairwise distances...');

sum_X = sum(X .^ 2, 2);
D = bsxfun(@plus, sum_X, bsxfun(@plus, sum_X', -2 * X * X'));
D(1:n+1:end) = 0;

% Run over all datapoints
disp('Computing P-values...');
for i=1:n
    
    if ~rem(i, 500)
        disp(['Computed P-values ' num2str(i) ' of ' num2str(n) ' datapoints...']);
    end
    
    % Set minimum and maximum values for precision
    betamin = -Inf;
    betamax = Inf;
    
    % Compute the Gaussian kernel and entropy for the current precision
    Di = D(i, [1:i-1 i+1:end]);
    [H, thisP] = Hbetaa(Di, beta(i));
    %         i
    %         H
    % Evaluate whether the perplexity is within tolerance
    Hdiff = H - logU;
    tries = 0;
    
    while abs(Hdiff) > tol&& tries < 150
        %             Hdiff
        % If not, increase or decrease precision
        if Hdiff > 0
            betamin = beta(i);
            if isinf(betamax)
                beta(i) = beta(i) * 2;
            else
                beta(i) = (beta(i) + betamax) / 2;
            end
        else
            betamax = beta(i);
            if isinf(betamin)
                beta(i) = beta(i) / 2;
            else
                beta(i) = (beta(i) + betamin) / 2;
            end
        end
        
        % Recompute the values
        [H, thisP] = Hbetaa(Di, beta(i));
        Hdiff = H - logU;
        tries = tries + 1;
    end
    % Set the final row of P
    P(i, [1:i - 1, i + 1:end]) = thisP;
end
disp(['Mean value of sigma: ' num2str(mean(sqrt(1 ./ beta)))]);
disp(['Minimum value of sigma: ' num2str(min(sqrt(1 ./ beta)))]);
disp(['Maximum value of sigma: ' num2str(max(sqrt(1 ./ beta)))]);



function [H, P] = Hbetaa(D, beta)
P = exp(-D *beta);
sumP = sum(P);
H = log(sumP) + beta * sum(D .* P) / sumP;
% H =  beta * sum(D .* P)/log(2);
P = P / sumP;

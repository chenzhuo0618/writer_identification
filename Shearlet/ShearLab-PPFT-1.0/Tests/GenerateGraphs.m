clear
close all
clc

% Test 1
%load output_TestAlgExact
%str=sprintf('M_{exact} = %d for N = %d \n',output_TestAlgExact(2,1),output_TestAlgExact(1,1));
%disp(str);

% Test 3
%load output_TestTightness
%str=sprintf('M_{tight} = %d for N = %d \n',output_TestTightness(2,1),output_TestTightness(1,1));
%disp(str);

% Test 5
%load output_TestSpeed
%figure(1)
%plot(output_TestSpeed(1,:),output_TestSpeed(2,:))
%xlabel('N')
%ylabel('Speed in seconds')
%title('Test Speed Shearlet Transform')

% Test 7
load output_TestRobustness
N=output_TestRobustness(1,1);
str=sprintf('The following graphs are for N = %d \n',N);
disp(str);

%figure(2)
%plot(output_TestRobustness(2,:),output_TestRobustness(3,:))
%xlabel('epsilon')
%ylabel('Monte Carlo Estimate for ||T^t(T x + eps z) - z||_2/||x||_2 for random image x')
%title('Test Noisy Coefficients')

figure(1) 

subplot(2,2,1);
plot(output_TestRobustness(2,:),output_TestRobustness(3,:))
xlabel('Percentage of coefficients discarded')
ylabel('||T^t thres T x - x||_2/||x||_2, x Gaussian')
title('Test Thresholding I')

subplot(2,2,2);
plot(output_TestRobustness(4,:),output_TestRobustness(5,:))
xlabel('Threshold')
ylabel('||T^t thres T x - x||_2/||x||_2, x Gaussian')
title('Test Thresholding II')

subplot(2,2,3);
plot(output_TestRobustness(6,:),output_TestRobustness(7,:))
xlabel('q')
ylabel('||T^t quant T x - x||_2/||x||_2, x Gaussian')
title('Test Quantization')

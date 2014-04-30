X = imread('lena.png');
X = double(X);
dfilt = 'pkva';
nlev_SD = [2 3];
smooth_func = @rcos;
Pyr_mode = 1; 
y = ContourletSDDec(X, nlev_SD, Pyr_mode, smooth_func, dfilt)
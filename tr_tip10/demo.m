setuppath;

% Path to directory where all matlab files reside
%basedir = '~/remote/texture/online/Kwitt09g';
basedir='d:\Downloads\tr_tip10';

% Directory where to dump the features
%dumpdir = '/tmp/dumpdir';
dumpdir = 'd:\Downloads\tr_tip10\tmp\dumpdir';

% Load sample textures (from VisTex dataset)
data = texload('Testset','basedir', ...
    fullfile(basedir,'testimages'),...
    'debug',true,'from',1,'to',2);


% Compute Weibull features, using moment estimation via the Gumbel dist.
features = dtcwtfe(data,'debug',true,'method','wblgmom');

% Dump features to harddisk directory
[info] = mkdir(dumpdir);

% Dump features
dump_wbldata(features,dumpdir,0);

% Now, run the C code to generate the distance matrix

% Next, load the distance matrix and evaluate (uncomment)
fid = fopen(fullfile(dumpdir,'dist.bin'));
distmat = fread(fid,'double');
distmat = reshape(distmat,[32 32])';
rr = generic_rrate(distmat,16,'ascend');
recog_acc = evalir(rr);
function [numImage] = cluster_strollr2D(jobid)
%%%%%%%%%%%%%%%%% loading directory %%%%%%%%%%%%%%%%%%%%%%%
method          =   'strollr2D';
% root            =   'F:/scratch';
root            =   '~/scratch';
direct          =   'imageDataset';
resultDir       =   'statsResult';
format          =   '.mat';
datatype        =   '*.mat';
databaseList    =   {'Set5', ...
    'Set14', ...
    'SIPImisc', ...
    'kodak'};  
% numDatabase     =   numel(databaseList);
NoiseLevel      =   [5; 10; 15; 20; 25; 50; 75; 100];
numNoiseLevel   =   numel(NoiseLevel);
% % translate jobID
% variableTuning.databaseList = databaseList;
% idxList = jobID_translate(jobid, variableTuning);
% (special case) assign each thread one image + one sigma
remaining       =   jobid;
idxDatabase     =   0;
while remaining > 0
    idxDatabase     =   idxDatabase + 1;
    curDatabase     =   databaseList{idxDatabase};
    imList          =   dir(fullfile(root, direct, curDatabase, datatype));
    numImage        =   numel(imList);
    if remaining > numImage * numNoiseLevel
        remaining   =   remaining - numImage * numNoiseLevel;
    else
        idxImage    =   ceil(remaining / numNoiseLevel);
        idxSigma    =   rem(remaining - 1, numNoiseLevel) + 1;
        break;
    end
end
curData             =   imList(idxImage).name;
curName             =   curData(1 : end - length(format));
sigma               =   NoiseLevel(idxSigma);
load(fullfile(root, direct, curDatabase, curData));        % load clean
load(fullfile(root, direct, curDatabase, curName, ...   
    ['sigma', num2str(sigma), format]));                   % load noisy
% check if the result has been completed
targetDir   =   fullfile(root, resultDir, curDatabase, [curName, '_', method]);
targetfile  =   fullfile(targetDir, ['sigma', num2str(sigma), format]);
if exist(targetfile)
    return;
else
    %%%%%%%%%%%%%%%%%%% WNNM denoising %%%%%%%%%%%%%%%%%%%%%
    param.sig       =   sigma;
    param           =   getParam_icassp2017(param);
    data.noisy      =   I1;
    data.oracle     =   I7;
    [Xr, psnrXr]    =   strollr2d_imagedenoising(data, param);
%     psnrXr              =   PSNR(Xr - I7);
    ssimXr               =   ssim(Xr, I7);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mkdir(targetDir);
    save(targetfile, 'NoiseLevel', 'databaseList', ...
        'psnrXr', 'ssimXr', 'Xr');
end
end

function param = getParam_icassp2017(param)
%%%%%%%%%%%%%%%%% shared %%%%%%%%%%%%%%%%%%%%%%%
param.dim               =   8;
param.n                 =   param.dim * param.dim;
param.stride            =   1; 
param.BMstride          =   1;
%%%%%%%%%%%%%%%%% TL %%%%%%%%%%%%%%%%%%%%%%%
param.TLthr0            =   2.5;
param.isMeanRemoved     =   true;
param.zeroWeight        =   0.2;
param.learningIter      =   40;            % number of learning iterations

% optional
param.lambda0           =   0.031;
       
%%%%%%%%%%%%%%%%% LR %%%%%%%%%%%%%%%%%%%%%%%
param.searchWindowSize       =   35;
param.csim              =   5;
param.tensorSize        =   param.csim * param.n;
param.thr0              =   1.5;
% optional
% param.maxTensorPatch    =   25;

%%%%%%%%%%%%%%%%%% fusion %%%%%%%%%%%%%%%%%%
param.numIter           =   1; 
param.gamma_f           =   1e-6;
param.gamma_l           =   0.01;
param.iterx             =   5;
end
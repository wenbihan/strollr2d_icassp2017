function [Xr, psnrXr] = strollr2d_imagedenoising(data, param)
%Function for denoising the gray-scale image using STROLLR-based denoising
%algorithm.
%
%Note that all input parameters need to be set prior to simulation. We
%provide some example settings using function getParam_icassp2017.
%However, the user is advised to carefully choose optimal values for the
%parameters depending on the specific data or task at hand.
%
% The strollr2d_imagedenoising algorithm denoises an gray-scale image based
% on STROLLR 2D learning. Detailed discussion on the algorithm can be found in
%
% (1)  "When Sparsity Meets Low-Rankness: Transform Learning With Non-Local 
%      Low-Rank Constraint for Image Restoration,”, written by B. Wen, Y.
%      Li, and Y Bresler, in Proc. IEEE Int. Conf. on Acoustics, Speech and
%      Signal Processing (ICASSP), pp. 2297-2301, March. 2017. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs -
%       1. data : Image data. The fields are as follows -
%                   - noisy: a*b size gray-scale matrix for denoising
%                   - oracle (optional): a*b size gray-scale matrix as
%                   ground-true, which is used to calculate PSNR
%
%       2. param: Structure that contains the parameters of the
%       OCTOBOS_imagedenoising algorithm. The various fields are as follows
%       -
%                   - dim: Patch size
%                   - stride: stride of overlapping patches
%                   - BMstride: stride of patches for block matching
%                   - TLthr0: sparsity penalty coefficient
%                   - learningIter: number of iterations of transform
%                           learning
%                   - searchWindowSize: size of the local search window
%                   - tensorSize: tensor (matrix) size for low-rank approximation
%                   - thr0: rank penalty term coefficient
%
% Outputs -
%       1. Xr - Image reconstructed with OCTOBOS_imagedenoising algorithm.
%       2. psnrXr - PSNR value of the denoised image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%% program %%%%%%%%%%%%%%%%
noisy   = data.noisy;
oracle  = data.oracle;

sig                         =   param.sig;
dim                         =   param.dim;
W                           =   kron(dctmtx(dim), dctmtx(dim));
threshold                   =   param.TLthr0 * sig;
param.threshold             =   threshold;
thr                         =   param.thr0 * sig;
param.thr                   =   thr;

[noisy, param]              =   module_imageEnlarge_forTLonly(noisy, param);

patchNoisy                  =   module_im2patch(noisy, dim);
patches                     =   patchNoisy;
numTensorPatch              =   size(patchNoisy, 2);
param.numTensorPatch        =   numTensorPatch;
% TL
[W, sparseCode, nonZeroTable]   =   module_TLapprox(patches, W, param);
nonZeroTable(nonZeroTable == 0) =   param.zeroWeight;
TLsparsityWeight                =   1 ./ nonZeroTable;
% % optional for statistics
% patch_TL                        =   W' * sparseCode;
% Xr_TL                           =   ...
%     module_aggreagtion(patch_TL, TLsparsityWeight, param);
% psnrTL                          =   PSNR(Xr_TL - oracle);

% LR
[blk_arr, ~, blk_pSize] = module_BM_fix(patches, param);
[LRpatch, LRweights, LRrankWeight] = ...
    module_LRapprox(patches, blk_arr, blk_pSize, param);
nonZerosLR = LRweights > 0;
LRrankWeight(nonZerosLR) = LRrankWeight(nonZerosLR) ./ LRweights(nonZerosLR);
% % optional
% patchLR = zeros(size(LRpatch));
% patchLR(:, nonZerosLR) = bsxfun(@rdivide, ...
%     LRpatch(:, nonZerosLR),LRweights(nonZerosLR));
% Xr_LR                   =   module_aggreagtion(patchLR, LRrankWeight, param);
% psnrLR                  =   PSNR(Xr_LR - oracle);

% fusion
patchRecon     = module_f1Reconstruction(sparseCode, W, ...
    LRpatch, LRweights, patches, param, TLsparsityWeight, LRrankWeight);
%         combinedWeight = TLsparsityWeight + LRrankWeight;
Xr          = module_aggreagtion(patchRecon, TLsparsityWeight, param);
psnrXr      = PSNR(Xr - oracle);

% Output
% outputParam.psnrXr                    =     psnrXr;
% % optional
% outputParam.psnrTL                    =     psnrTL;
% outputParam.psnrLR                    =     psnrLR;

end


function [denoisedPatch, Weights, rankWeightTable] = ...
    module_LRapprox(patchNoisy, blk_arr, blk_pSize, param)
%MODULE_LRAPPROX Summary of this function goes here
%   Detailed explanation goes here
% Goal: Apply Low-rank approximation by hard SVD thresholding
% Inputs:
%   1. patchNoisy       : [aa0, bb0] size image
%   2. blk_arr          : BM patch indices in each tensor
%   3. blk_pSize        : tensor size
%   4. param            : parameters for BM
%       - numTensorPatch    : #patch in each tensor
%       - thr               : Singular value threshold, = thr0 * sigma
%       - n                 : spatial dimension
% Outputs:
%   1. denoisedPatch    : denoised patch (with weights) after LR approx.
%   2. Weight           : weights (#times that appears in tensor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   paramters
numTensorPatch      =   param.numTensorPatch;
n                   =   param.n;
thr                 =   param.thr;

%   initialization
denoisedPatch       =   zeros(n, numTensorPatch );
% Weights             =   zeros(n, numTensorPatch );
Weights             =   zeros(1, numTensorPatch );
rankWeightTable           =   zeros(1, numTensorPatch );
numRef              =   size(blk_arr, 2);

%   LR
for  k  =  1 : numRef
    curTensorSize   =   blk_pSize(:, k);
    curTensorInd    =   blk_arr(1 : curTensorSize, k);
    Scenter         =   patchNoisy(:, curTensorInd);
%     % ref patch
%     Refcenter       =   patchOracle(:, curTensorInd);
    %/// de-mean
%     mB              =   repmat(mean( B, 2 ), 1, size(B, 2));
%     B               =   B-mB;
    mB              =   mean(Scenter, 2);
    Scenter         =   double(bsxfun(@minus, Scenter, mB));
    %/// LR tensor approximation
%     [ys] =   denoise( double(B), thr,mB );
    % Eigen Value
    [bas, eigenVal] =   eig((Scenter*Scenter'));
    diat            =   diag(eigenVal)/(curTensorSize);
%     diat            =   diag(tmp)/(curTensorSize + n);
    thr2            =   thr^2;
    diatthr         =   (diat>thr2);
    diatthr(end)    =   true;                   % at least rank-1
    rankWeightTable(:, curTensorInd) = rankWeightTable(:, curTensorInd) ...
        + 1 / sum(diatthr(:));
    ys              =   bas * diag(diatthr) * bas' * Scenter;
    ys              =   bsxfun(@plus, ys, mB);
    %/// 
    denoisedPatch(:, curTensorInd) =   denoisedPatch(:, curTensorInd) +   ys;
    Weights(:, curTensorInd)  =   Weights(:, curTensorInd) + 1;
end


end
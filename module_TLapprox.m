function [W, sparseCode, nonZeroTable] = ...
    module_TLapprox(extractPatchAll, W, TLparam)
%MODULE_TLAPPROX Summary of this function goes here
%   generate the sparse codes and learn transform
%   Inputs:
%       1. W                    : initial Transform
%       2. extractPatchAll      : the n * N data
%       3. TLparam              : transform learning parameters
%   Outputs:
%       1. W                    : learned transform
%       2. sparseCode           : generated sparse codes
%       3. nonZeroTable         : #non-zeros for each patch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%
learningIter                =   TLparam.learningIter;
threshold                   =   TLparam.threshold;
%%%%%%%%%%%%%%% Main Program %%%%%%%%%%%%%%%
W           = TLORTHOpenalty(W, extractPatchAll, learningIter, threshold);
sparseCode  = W * extractPatchAll;
[sparseCode, nonZeroTable] = sparse_l0(sparseCode, threshold);
end


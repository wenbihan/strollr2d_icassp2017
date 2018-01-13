function patchRecon = module_f1Reconstruction(sparseCode, W, ...
    LRpatch, LRweights, patchNoisy, param, TLsparsityWeight, LRrankWeight)
%MODULE_F1RECONSTRUCTION Summary of this function goes here
%   Goal:   Reconstruction patch using both TL and LR results
%   Inputs:
%       1. sparseCode           : sparse codes under W
%       2. W                    : learned transform
%       3. LRpatch              : denoised patch after LR approx.
%       4. LRweights            : weights for LRpatch
%       5. patchNoisy           : noisy patches
%       6. param                : parameters for reconstruction
%   Outputs:
%       1. patchRecon           : reconstructed patches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%
sig                         =   param.sig;
gamma_f                     =   param.gamma_f / sig;
gamma_l                     =   param.gamma_l * sig; 
LRvsRLcoef                  =   LRrankWeight ./ (TLsparsityWeight)';

%%%%%%%%%%%%%%%%%%%%% Reconstruction %%%%%%%%%%%%%%%%%%%%%%%
TLrecon     = W' * sparseCode;
patchRecon  = TLrecon + gamma_f * patchNoisy + ...
    bsxfun(@times, LRpatch * gamma_l,  LRvsRLcoef);
% patchRecon  = patchRecon ./ (1 + gamma_f + gamma_l * LRweights);
patchRecon  = bsxfun(@rdivide, patchRecon, ...
    (1 + gamma_f + gamma_l * LRweights .* LRvsRLcoef));

end


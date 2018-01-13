function Xr = module_aggreagtion(patches, weights, param)
%MODULE_AGGREAGTION Summary of this function goes here
%   Goal:   Aggregate the patches back to the images (shrinking) with weights
%   Inputs:
%       1. patches              : reconstructed patches
%       2. weights              : weights for LRpatch
%       3. param                : parameters for reconstruction
%   Outputs:
%       1. Xr                   : reconstructed image by patch aggregation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%
aa                  =   param.aa;
bb                  =   param.bb;
aa0                 =   param.aa0;
bb0                 =   param.bb0;
frontPadSize        =   param.frontPadSize;
dim                 =   param.dim;
Mimage              =   aa - dim + 1;
Nimage              =   bb - dim + 1;
r                   =   1 : Mimage;
c                   =   1 : Nimage;
im_out              =   zeros(aa, bb);
im_wei              =   zeros(aa, bb);
k                   =   0;
%%%%%%%%%%%%%%% Aggregation %%%%%%%%%%%%%%
for i  = 1 : dim
    for j  = 1 : dim
        k    =  k + 1;
%         im_out(r-1+i, c-1+j)  =  im_out(r-1+i,c-1+j) + ...
%             reshape( patches(k,:)', [Mimage Nimage]);
%         im_wei(r-1+i,c-1+j)  =  im_wei(r-1+i,c-1+j) + ...
%             reshape( weights(k,:)', [Mimage Nimage]);
        im_out(r-1+i, c-1+j)  =  im_out(r-1+i,c-1+j) + ...
            reshape( patches(k,:)', [Mimage Nimage]) .* reshape( weights', [Mimage Nimage]);
        im_wei(r-1+i,c-1+j)  =  im_wei(r-1+i,c-1+j) + ...
            reshape( weights', [Mimage Nimage]);
    end
end
%%%%%%%%%%%%%%% Image Shrinking %%%%%%%%%%%%%%
 im_out     =   im_out./(im_wei + eps);
 Xr         =   im_out(frontPadSize + 1 : frontPadSize + aa0, ...
     frontPadSize + 1 : frontPadSize + bb0);
end


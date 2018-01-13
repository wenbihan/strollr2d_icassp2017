function [pos_arr, error_arr, numPatch_arr] = ...
    module_BM_fix(extractPatch, BMparam)
%MODULE_BM_FIX Summary of this function goes here
%   Detailed explanation goes here
% Goal: perform block matching (BM)
% Inputs:
%   1. image            : [aa0, bb0] size image
%   2. BMparam          : parameters for BM
%       - dim               : patch width
%       - n                 : n patch spatial dimension (vectorized)
%       - stride            : patch extraction stride
%       - searchWindowSize  : BM search window size
% Outputs:
%   1. pos_arr          : [tensorSize, Nimage, Mimage] BM indexing
%   2. error_arr        : [tensorSize, Nimage, Mimage] BM errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

aa                  =   BMparam.aa;
bb                  =   BMparam.bb;
dim                 =   BMparam.dim;
searchWindowSize    =   BMparam.searchWindowSize;
stride              =   BMparam.BMstride;
tensorSize          =   BMparam.tensorSize;


% row / col index size in noisy image
Nimage          =   aa-dim+1;               
Mimage          =   bb-dim+1;               
% reference patch row / col indexing
r               =   1:stride:aa-searchWindowSize+1; 
c               =   1:stride:bb-searchWindowSize+1; 
% #patchs in search window
swidth          =   searchWindowSize - dim + 1;
swidth2         =   swidth^2;
% Index image
%/// noisy all possible patch indexing
L               =   Nimage*Mimage;
I               =   (1:L);
I               =   reshape(I, Nimage, Mimage);
%/// reference patch indexing
N1              =   length(r);
M1              =   length(c);
%/// BM result indexing table
pos_arr         =   zeros(tensorSize, N1*M1);
error_arr       =   zeros(tensorSize, N1*M1);
numPatch_arr    =   ones(1, N1*M1) * tensorSize;        % for fixed Tensor Size     
% middle index (refernce patch index), wihtin the search window
mid             =   mod(swidth, 2) * ((swidth2+1)/2) + ...
                    mod(swidth+1, 2) * (swidth2+swidth)/2;  
for  i  =  1 : N1
    for  j  =  1 : M1
        %// noisy row / col
        row                     =   r(i);
        col                     =   c(j);
        %// neighborhood region of size (2S+1)^2 for non-boundary pixel (patch)
        %// search window range <--> all searchable patch indices
        idx                     =   I(row: row+swidth-1,col:col+swidth-1); 
        idx                     =   idx(:);
        %// all the patches in the region
        B                       =   extractPatch(:,idx);  
        %// central patch
        v                       =   extractPatch(:, idx(mid)); 
        %// distance: Euclidean & sorting
        dis                     =   B-v(:,ones(1,swidth2)); 
        metric                  =   mean(dis.^2);
        [BMerror, ind]          =   sort(metric); 
%         %// distance: Correlation & sorting
%         interProduct            = sum(bsxfun(@times, B, v));
%         normTotal               = norm(v) * sqrt(sum(B.^2));
%         metric                  = abs(bsxfun(@rdivide, interProduct, normTotal));
%         [BMerror, ind]          = sort(metric, 'descend');   
 
        %// take tensorSize-largest
        pos_arr(:, (j-1)*N1 + i)    =  idx( ind(1:tensorSize) );     
        error_arr(:, (j-1)*N1 + i)  =  BMerror(ind(1:tensorSize));
    end
end


end


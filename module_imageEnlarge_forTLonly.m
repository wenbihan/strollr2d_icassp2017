function [enlargedImage, BMparam] = ...
    module_imageEnlarge_forTLonly(image, BMparam)
%MODULE_IMAGEENLARGE Summary of this function goes here
% Goal: enlarge the image by symmetry for BM purpose
% Inputs:
%   1. image            : [aa0, bb0] size image
%   2. BMparam          : parameters for BM
%       - dim               : patch width
%       - n                 : n patch spatial dimension (vectorized)
%       - BMstride            : patch extraction stride
%       - searchWindowSize  : BM search window size
% Outputs:
%   1. enlargedImage    : [aa, bb] enlarged image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters
[aa0, bb0]          = size(image);
dim                 = BMparam.dim;

frontPadSize        = dim - 1;      
endRowPadSize       = frontPadSize;    
endColPadSize       = frontPadSize;  
% enlarge by symmertry
enlargedImage       = enlarge(image, frontPadSize, endRowPadSize, endColPadSize);
BMparam.aa0         = aa0;
BMparam.bb0         = bb0;
BMparam.aa          = aa0+frontPadSize+endRowPadSize;
BMparam.bb          = bb0+frontPadSize+endColPadSize;
BMparam.frontPadSize    = frontPadSize;
end

function y = enlarge(x, frontPadSize, endRowPadSize, endColPadSize)
% enlarge matrix 
% Inputs:
%   x               : orig. image, size = nlin * ncol
%   a, b            : 
[nlin,ncol]=size(x);
y=x(:,[frontPadSize:-1:1 1:ncol ncol:-1:ncol-endColPadSize+1]);
y=y([frontPadSize:-1:1 1:nlin nlin:-1:nlin-endRowPadSize+1],:);
end
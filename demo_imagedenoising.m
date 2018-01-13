clear;
load('demo_data/noisy_Barbara_sigma20.mat');

%%%%%%%%%%%%%%%% strollr2D image denoising demo %%%%%%%%%%%%%%%%%%%%%
data.noisy      =   noisy;
data.oracle     =   oracle;
param.sig       =   sig;                % sig = 20
param           =   getParam_icassp2017(param);
[Xr, psnrXr]= strollr2d_imagedenoising(data, param);
imshow(uint8(Xr));
fprintf( 'STROLLR-2D denoising completes! \n Denoised PSNR = %2.2f \n', psnrXr);  

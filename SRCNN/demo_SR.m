% =========================================================================
% Test code for Super-Resolution Convolutional Neural Networks (SRCNN)
%
% Reference
%   Chao Dong, Chen Change Loy, Kaiming He, Xiaoou Tang. Learning a Deep Convolutional Network for Image Super-Resolution, 
%   in Proceedings of European Conference on Computer Vision (ECCV), 2014
%
%   Chao Dong, Chen Change Loy, Kaiming He, Xiaoou Tang. Image Super-Resolution Using Deep Convolutional Networks,
%   arXiv:1501.00092
%
% Chao Dong
% IE Department, The Chinese University of Hong Kong
% For any question, send email to ndc.forward@gmail.com
% =========================================================================

close all;
clear all;
% addpath('/fred/oz138/COS80024/SRCNN/model/9-5-5(ImageNet)')
% addpath('Set14')
%% read ground truth image
%im  = imread('Set5\urban_crop1_patch_100x2.png');
im  = imread('urban_crop1_patch_91x2.png');
height = size(im,1);
width = size(im,2);
%% set parameters
up_scale = 2;
model = 'model\9-5-5(ImageNet)\x2.mat';
% up_scale = 3;
% model = 'model\9-3-5(ImageNet)\x3.mat';
% up_scale = 3;
% model = 'model\9-1-5(91 images)\x3.mat';
% up_scale = 2;
% model = 'model\9-5-5(ImageNet)\x2.mat'; 
% up_scale = 4;
% model = 'model\9-5-5(ImageNet)\x4.mat';

%% work on illuminance only
if size(im,3)>1
    im = rgb2ycbcr(im);
    y = im(:, :, 1);
    cb = im(:,:,2);
    cr = im(:,:,3);
end
im_gnd = modcrop(y, up_scale);
im_gnd = single(im_gnd)/255;

%% bicubic interpolation
im_l = imresize(im_gnd, 1/up_scale, 'bicubic');
im_b = imresize(im_l, up_scale, 'bicubic');

%% SRCNN
im_h = SRCNN(model, im_b);

%% remove border
im_h = shave(uint8(im_h * 255), [up_scale, up_scale]);
im_gnd = shave(uint8(im_gnd * 255), [up_scale, up_scale]);
im_b = shave(uint8(im_b * 255), [up_scale, up_scale]);

%% compute PSNR
psnr_bic = compute_psnr(im_gnd,im_b);
psnr_srcnn = compute_psnr(im_gnd,im_h);
y_height = size(im_h,1);
y_width = size(im_h,2);
cb = imresize(cb, [y_height, y_width]);
cr = imresize(cr, [y_height, y_width]);
sr_image = uint8(zeros(y_height, y_width,3));
for i = 1:3
    sr_image(:,:,1) = im_h;
    sr_image(:,:,2) = cb;
    sr_image(:,:,3) = cr;
end

sr_image = ycbcr2rgb(sr_image);

%% show results
fprintf('PSNR for Bicubic Interpolation: %f dB\n', psnr_bic);
fprintf('PSNR for SRCNN Reconstruction: %f dB\n', psnr_srcnn);

figure, imshow(im_b); title('Bicubic Interpolation');
figure, imshow(im_h); title('SRCNN Reconstruction');
figure, imshow(sr_image); %title('color aSRCNN Reconstruction');

imwrite(im_h, ['Y Reconstruction' '.png']);
imwrite(sr_image, ['color Reconstruction' '.png']);



%imwrite(im_b, ['Bicubic Interpolation' '.png']);
%imwrite(im_h, ['SRCNN Reconstruction' '.png']);

function out = PL_simCHAIN(I0,GSD0,GSD1,GSD2,psf,SNR50,bits,gamma)
%% simple simulation of imaging chain
% out = PL_simCHAIN(I0,GSD0,GSD1,GSD2,fwhm)
%
%   inputs -->
%       I0      : template image sampled at high resolution in counts
%       GSD0    : sampling resolution of template image (in meters)
%       GSD1    : sampling resolution of sensor (projected pixel pitch, in meters)
%       GSD2    : sampling resolution final product
%       fwhm    : full-width-half max of system at the template resolution
%       SNR50   : SNR at 50% of dynamic range
%       bits    : number of bits encoding original image (usually 8 or 16)
%
%   outputs -->
%       out.Iblur   : blurred intermediate image at template resolution
%       out.Isensor : average image at the sensor
%       out.sample  : Poisson-sampled image at the sensor
%       out.Iout    : final product

%% Implementation
% compute the equivalent well capacity
W=2*SNR50^2;   % compute the equivalent well capacity
% blur the image for each color

for i=1:3
    out.Iblur(:,:,i)=conv2(double(I0(:,:,i)),psf,'same'); % blur each image
end
% downsample to sensor
out.Isensor = imresize(out.Iblur,GSD0/GSD1,'Antialiasing',false);
% count photons
out.Isample = poissrnd((double(out.Isensor)/(2^bits))*W)/W*2^16;
% downsample to product
out.Iout = uint16(imresize(out.Isample,GSD1/GSD2,'Antialiasing',false));
% apply display gamma
out.Iout = uint16(((double(out.Iout)/2^16).^(1./gamma))*2^16);

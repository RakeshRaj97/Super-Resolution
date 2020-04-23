%%
I=imread('/fred/oz138/COS80024/EO_Degradation/Image_Chips/Rural/rural_crop1.png'); % load NAIP 1m image

%%
GSD_lim=6;
GSD0=1;             % set GSD (scale) of input image
GSD1=1:GSD_lim;          % set GSD of target system (init = 1:5 (10))
GSD2=3;             % set final resolution of the product (3m or 5m) (init = 3)
SNR50=50:10:100;           % set SNR50 (init = 80)
SZ=1000;            % set size of the image chip
I0=I;  % crop SZ pixels in the center of the image
bits=8;             % select number of bits
gamma=1;            % display gamma
H=500e3;            % distance to object
lambda=560e-9;      % wavelength
D0=0.4;             % size of obscuration
F=0.7;              % focal length

%% compute PSF for different apertures
flt = PL_tele_mtf(D0,10);
MTF = flt.T;
delta = 10e-6;
for i=1:10
    pd = 3*(i-1);   
    D(i) = (10/(10+pd))*lambda*H;
    GRD(i) = 1.22*lambda*H/D(i);
    disp(GRD(i))
    psf{i}=abs(fftshift(fft2(fftshift(padarray(MTF,[pd pd])))));
    psf{i}=double(psf{i})/sum(sum(double(psf{i})));
end

%% Plot PSFs
%for i=1:10
%    subplot(2,5,i);
%    imagesc(PL_ccrop(psf{i},21));
%    axis square;
%    colormap bone;
%    set(gca,'XTick',[],'YTick',[]);
%    title(['D=' num2str(D(i)*100,'%.1f') 'cm']);
%end

%% simulate imagery
clear Iout Ids      % clear variables
for l=1:length(GSD1)
    for k=1:length(psf)
        for s=1:length(SNR50)
            out = PL_simCHAIN(I0,GSD0,GSD1(l),GSD2,psf{k},SNR50(s),bits,gamma);
            Iout{k,l,s}=out.Iout(1:200,1:200,:);
        end
    end
end

%% plot all MTFs
%figure
%for i=1:10
%    for j=1:GSD_lim %change to 5 in case of bug
%        subplot(10,10,(i-1)*10 +j);
%        %imagesc(log10(imresize(abs(fftshift(fft2(Iout{i,j}(:,:,2)-mean(mean(Iout{i,j}(:,:,2))))./fft2(Iout{1,1}(:,:,2)-mean(mean(Iout{1,1}(:,:,2)))))),0.1)));
%        imagesc(log10(imresize(abs(fftshift(fft2(Iout{i,j}(:,:,2)-mean(mean(Iout{i,j}(:,:,2))))./fft2(Iout{1,1}(:,:,2)-mean(mean(Iout{1,1}(:,:,2)))))),0.1))>-.3);
%        axis image tight;
%        set(gca,'XTick',[],'YTick',[]);
%    end
%end

%% prepare images for test
for l=1:length(GSD1)
    for k=1:length(psf)
        for s=1:length(SNR50)
            gamma = 0.5;
            img0= uint16(((double(Iout{8,3,1})/2^16).^(1./gamma))*2^16);
            img = uint16(((double(Iout{k,l,s})/2^16).^(1./gamma))*2^16);
            %fn=sprintf('./Image_Output/IMAGE_GSD%d_D%d_SNR%d.png',l,k,s);
            fn_=sprintf('./Image_Chips/Rural/rural1/rural1_GSD%d_D%d_SNR%d.png',l,k,s);
            %imwrite(cat(2,img0,img),fn);
            imwrite(img, fn_);
        end
    end
end

%% make IQ trade
%for i=1:10
%    for j=1:GSD_lim %change to 5 in case of bug
%        iq(i,j)=sum(sum(log10(imresize(abs(fftshift(fft2(Iout{i,j}(:,:,2)-mean(mean(Iout{i,j}(:,:,2))))./fft2(Iout{1,1}(:,:,2)-mean(mean(Iout{1,1}(:,:,2)))))),0.1))>-.3));
%    end
%end


%% Dynamic range study
%for i=1:30
%    I0=imresize(conv2(mean(double(I),3),ones(i),'same'),1/i,'nearest');
%    DR{i}=20*log10(I0(:)./min(I0(:)));
%    DR_hist(:,i)=hist(DR{i},[0:1:25]);
%    M(i)=max(DR{i});
%end
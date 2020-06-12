function generate_LR_HR_pairs(input_dir)  
   %%
    files = dir(sprintf('%s/*.png', input_dir)); % input_dir: directory containing original HR landmass images
    len = length(files);
    for k = 1:len
        %I=imread('/fred/oz138/COS80024/EO_Degradation/Image_Chips/Beach/beach3_crop1.png'); % load original HR image, please change filename to get different HR images
        filename = files(k).name;
        filepath = sprintf('%s/%s', input_dir, filename);
        fprintf('===========================================================\n');
        fprintf('processing image:%s\n',filename);
        I=imread(filepath);
        filename = filename(1:end-4);
        height = size(I,1);
        width = size(I,2);
        if ~exist('LR-HR', 'dir')
            mkdir('LR-HR');
        end
        if ~exist('LR-HR/LR', 'dir')
            mkdir('LR-HR/LR');
        end
        if ~exist('LR-HR/HR', 'dir')
            mkdir('LR-HR/HR');
        end
        %% simulate imagery
        patch_sz=96;            % set size of the HR patch
        stride_x = int32(patch_sz*0.8);    % stride parameter horizontally
        stride_y = int32(patch_sz*0.8);    % stride parameter vertically
        i = 1;
        t = 1;
        while((i - 1)*stride_y+patch_sz+1 <= height)
            j = 1;
            while((j - 1)*stride_x+patch_sz+1 <= width)
                fprintf('sampling %dth image patch, i=%d, j=%d\n', t, i, j);
                patch = I((i - 1)*stride_y+1:(i - 1)*stride_y+patch_sz,(j - 1)*stride_x+1:(j - 1)*stride_x+patch_sz,:);
                %fn=sprintf('/fred/oz138/COS80024/EO_Degradation/EO_Data/Beach/beach1/HR/HR_urban%d_patch.png',t);
                fn=sprintf('LR-HR/HR/%s_patch_%d.png',filename, t);
                imwrite(patch, fn);
                %out = imgaussfilt(patch,1.5); % blur HR patch with a Gaussian kernel sized 1.5
                %out = imnoise(out,'speckle');
                %out = imnoise(out,'gaussian', 0, 0.01);
                out = imresize(patch,0.5,'Antialiasing',false);
                %fn=sprintf('/fred/oz138/COS80024/EO_Degradation/EO_Data/Beach/beach1/LR/LR_urban%d_patch.png',t);
                fn=sprintf('LR-HR/LR/%s_patch_%dx2.png',filename, t);
                imwrite(out, fn);
                j = j + 1;
                t = t + 1;
            end
            i = i + 1;
        end
        fprintf('generated %d LR-HR patch pairs for %s\n', t, filename);
    end
end
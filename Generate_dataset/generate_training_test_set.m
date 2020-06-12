function generate_training_test_set(HR_data_dir, LR_data_dir, trainingset_ratio)
%==========================================================================
%
% usage example:
% generate_training_test_set('LR-HR/HR', 'LR-HR/LR', 0.8)
%
%==========================================================================
    imagename = sprintf('%s/*.png', HR_data_dir);
    files = dir(imagename);
    len = length(files);
    train_num = int32(len*trainingset_ratio);
    p = randperm(len); % generate random numbers between [1,len]
    train_idx = p(1:train_num); % return the first train_num random number as training index
    test_idx = p(train_num+1:end);
    if ~exist('LR-HR/Landmass_train_HR', 'dir')
            mkdir('LR-HR/Landmass_train_HR');
    end
    if ~exist('LR-HR/Landmass_test_HR', 'dir')
            mkdir('LR-HR/Landmass_test_HR');
    end
    if ~exist('LR-HR/Landmass_train_LR', 'dir')
            mkdir('LR-HR/Landmass_train_LR/X2');
    end
    if ~exist('LR-HR/Landmass_test_LR', 'dir')
            mkdir('LR-HR/Landmass_test_LR/X2');
    end
    fprintf('generating training set....\n');
    for i=1:length(train_idx)
        filename = files(train_idx(i)).name;
        filepath = sprintf('%s/%s', HR_data_dir, filename);
        fprintf('extract HR patch:%s\n', filename);
        copyfile(filepath, 'LR-HR/Landmass_train_HR');
        lr_filename = sprintf('%sx2.png', filename(1:end-4));
        lr_filepath = sprintf('%s/%s', LR_data_dir, lr_filename);
        fprintf('extract LR patch:%s\n', lr_filename);
        copyfile(lr_filepath, 'LR-HR/Landmass_train_LR/X2');
    end
    fprintf('generated %d training pairs\n', length(train_idx));
    fprintf('generating test set....\n');
    for i=1:length(test_idx)
        filename = files(train_idx(i)).name;
        filepath = sprintf('%s/%s', HR_data_dir, filename);
        copyfile(filepath, 'LR-HR/Landmass_test_HR');
        lr_filename = sprintf('%sx2.png', filename(1:end-4));
        lr_filepath = sprintf('%s/%s', LR_data_dir, lr_filename);
        fprintf('extract LR patch:%s\n', lr_filename);
        copyfile(lr_filepath, 'LR-HR/Landmass_test_LR/X2');
    end
    fprintf('generated %d test pairs\n', length(test_idx));
end
        
    
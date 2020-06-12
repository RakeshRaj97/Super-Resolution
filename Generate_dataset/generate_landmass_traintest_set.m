function generate_landmass_traintest_set()
    %input_dir = 'fred/oz138/COS80024/Landmass_HR_images' %directory to store original HR images
    input_dir = 'HR_Images';
    generate_LR_HR_pairs(input_dir);
    train_size = 0.8;
    generate_training_test_set('LR-HR/HR', 'LR-HR/LR', train_size);
end
    

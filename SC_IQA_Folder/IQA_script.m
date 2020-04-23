function IQAs = IQA_script(load_path, save_path)
% This script is intended to be used on a batch of 
% images to assess their image quality using the 
% PSNR and SSIM metrics. 

% NOTE: this script depends on the natsortfiles.m script
%       and the NTIRE2017 IQA scripts for SSIM/PSNR.

% Extract filenames from directory in load path containing
% images to be assessed.
inp = strcat(load_path, '*.*');
filenames = dir(inp);
fnames_cell = struct2cell(filenames);
crop_cell = fnames_cell(1, :);
files_sort = natsortfiles(crop_cell);
clean_files = files_sort(3:end);

% Define the baseline image that other images will
% be compared to.
path_to_file = load_path;
base_img_path = clean_files{1};
baseline_path = strcat(path_to_file, base_img_path);
baseline_img = imread(baseline_path);

% Transpose to turn rows into columns before entering loop:
clean_files = transpose(clean_files);

% Loop over all image files in path and generate
% SSIM and PSNR values for each file.
for i=1:length(clean_files)
	comp_img_fname = clean_files{i, 1};
	comp_img_pname = strcat(path_to_file, comp_img_fname);
	comp_img =imread(comp_img_pname);
	clean_files{i, 2} = NTIRE_PeakSNR_imgs(baseline_img, comp_img);
    clean_files{i, 3} = NTIRE_SSIM_imgs(baseline_img, comp_img);
end

% Write out the built cell object as a .txt or .csv
% file containing columns showing image filenames, PSNR
% and SSIM values for each image.
writecell(clean_files, save_path)
# Performance-Measurement-of-AI-Assisted-Satellite-Imagery
Performance measurement of AI assisted Satellite Imagery_COS80024
This repository is an implementation of EDSR model using PyTorch, Memnet using Tensorflow and SRCNN using Matlab
**EDSR:** Check the official [code](https://github.com/thstkdgus35/EDSR-PyTorch) and [paper](http://openaccess.thecvf.com/content_cvpr_2017_workshops/w12/papers/Lim_Enhanced_Deep_Residual_CVPR_2017_paper.pdf)
**Memnet:** Check the official [code](https://github.com/lyatdawn/MemNet-Tensorflow) and [paper](http://cvlab.cse.msu.edu/pdfs/Image_Restoration%20using_Persistent_Memory_Network.pdf)
**SRCNN:** Check the official [code](http://mmlab.ie.cuhk.edu.hk/projects/SRCNN.html) and [paper](http://personal.ie.cuhk.edu.hk/~ccloy/files/eccv_2014_deepresolution.pdf)

The **EDSR_baseline_x2** model was trained on NVIDIA P100 with ~4500 annotated satellite Low Resolution image pathches which were obtained by Image degradation and Image downsampling of the High Resolution images. You can download the dataset and the models [here](https://drive.google.com/drive/folders/1dbqh0lo5YAKhuPBXOlcUGsew5pL0T33O?usp=sharing)

# Required Dependencies
## EDSR
Run the bash script `project4_env_script_.sh` to install all the required dependencies. 

## Memnet
Run the bash script `memnet_env_script(1).sh` to install all the required dependencies. 

# Testing the models
## EDSR
Activate the virtual environment `p4` using `source activate p4`

Create a new directory `\test` under `\edsr` to test your own images. Create a new directory `\models` under `\edsr` and place the downloaded models

Uncomment the line 35 in `demo.sh` under `\src`. Change the `--dir_data` argument to the path where the pretrained models are located. Use `--n_feats 64` for testing the edsr_baseline_x2 (model_best.pt) model and `--n_feats 256` for testing the edsr_x2 (EDSR_x2.pt) model.

Run `demo.sh` using the command `sh demo.sh`

The output SR images can be found under `\experiment\test\results` folder

## Memnet

Activate the virtual environment `memnet` using `source activate memnet`

Download the pre-trained model [here](https://drive.google.com/drive/folders/1JTneCiIZfITyg_Z2T96WY0hA84BnRDSk). Place the images to test in `MemNet_N\Set12` folder. 

Run `test.sh` to test the model. By default `test.sh` is written to support png files. In order to check jpeg files change the `testing_set` variable to `.jpeg` in line 7 under `test.sh` 

The output images can be found under `\results` folder.

## SRCNN

This program requires Matlab >= 2017

Place your test image in `\SRCNN`. Replace the path and the image name in line 22 of `demo_SR.m`

Run `demo_SR.m` by replacing the image name. The output image can be found under `\SRCNN` folder

# Evaluation - Image Quality Assessment
## Calculation of PSNR, SSIM & MSE

Create two new directories `\HR_Images` and `\Output_Images` under the `\IQA` folder to place the ground-truth HR images and the output SR images. Edit the lines 14 and 26 to the path of the HR/SR image folders

Run the file `IQA.py` using the command `python IQA.py`. The output is stored as `mydata.csv` file which stores the PSNR, SSIM and MSE values.

## Calculation of MTF

Create two new directories `\MTF_Images` and `\MTF_Output` under the `\IQA` folder. Place the images to compute MTF50 values in the `\MTF_Images` folder.

Run the file `mtf_to_compute_directory.py` using the command `python mtf_to_compute_directory.py`. The output graphs are stored in `\MTF_Output`folder

# Training the EDSR Model

Uncomment line 3 in `demo.sh` under `\edsr\src`. Change the `--dir_data` argument to the path where the dataset is located. 

Run `demo.sh` using the command `sh demo.sh`


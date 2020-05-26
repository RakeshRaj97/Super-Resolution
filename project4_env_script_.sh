#!/bin/bash

## script for building virtual environment for project 4
## https://github.com/thstkdgus35/EDSR-PyTorch

module load anaconda3/5.1.0
module load gcc/6.4.0

conda create -n p4 python=3.6
source activate p4
conda install pytorch==1.2.0 torchvision==0.4.0 cudatoolkit=10.0 -c pytorch
conda install pillow=6.2.1 -y
pip install matplotlib
pip install utility
pip install imageio
pip install tqdm
pip install scikit-image
#pip install opencv-python (only for video input/output)
conda install ipykernel
python -m ipykernel install --user --name p4 --display-name p4env
source deactivate
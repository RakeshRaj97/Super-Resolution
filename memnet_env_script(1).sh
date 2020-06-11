#!/bin/bash

## script for building virtual environment for memnet
## https://github.com/lyatdawn/MemNet-Tensorflow

module load anaconda3/5.1.0
module load cudnn/7.0.5-cuda-9.0.176 

conda create -n memnet python=2.7
source activate memnet
pip install tensorflow-gpu==1.5.0
pip install scikit-image
pip install seaborn
pip install opencv-python
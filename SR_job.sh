#!/bin/bash
#
#SBATCH --job-name=super_res_EDSRx2
#
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --mem-per-cpu=20gb
#SBATCH --gres=gpu:1

module load cudnn/7.0.5-cuda-9.0.176

cp -a ~/../../fred/oz138/COS80024/EO_Degradation/EO_Data/Beach/beach1/. ~/../../fred/oz138/COS80024/torch/NTIRE2017/demo/img_input/

th test.lua -model EDSR_x2 -selfEnsemble true

mv -v ~/../../fred/oz138/COS80024/torch/NTIRE2017/demo/img_output/EDSR_x2/myImages/X2/* ~/../../fred/oz138/COS80024/EO_Degradation/EO_Data/Beach/beach1_SR/

cd ~/../../fred/oz138/COS80024/torch/NTIRE2017/demo/img_input

rm *.png

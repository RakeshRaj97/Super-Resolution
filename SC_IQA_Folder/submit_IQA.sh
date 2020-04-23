#!/bin/bash
#
#SBATCH --job-name=super_res_EDSRx2
#
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=2gb
#SBATCH --gres=gpu:1

module load matlab/2019b

matlab -nodisplay -r "IQA_script /fred/oz138/COS80024/EO_Degradation/Image_Chips/Urban_v2/img_output/crop5_2/  ./IQA_Files/IQA_v3/urban5_IQAs.txt; quit force"

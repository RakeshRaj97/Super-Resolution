#!/bin/bash
#
#SBATCH --job-name=srcnn
#SBATCH --output=srcnn.log
#SBATCH --error=srcnn.log
##SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --mem=64GB

module load anaconda3/5.1.0
module load python/3.7.4
module load cudnn/7.6.2-cuda-10.0.130
module load tensorflow/2.1.0-python-3.7.4
module load scipy/1.4.1-python-3.7.4
module load h5py/2.7.1-python-3.7.4
module load numpy/1.18.2-python-3.7.4
module load opencv/3.4.1

cd /fred/oz138/COS80024/SRCNN/SRCNN/

python use_SRCNN.py


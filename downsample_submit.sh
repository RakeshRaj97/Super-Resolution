#!/bin/bash
#
#SBATCH --job-name=data_degradation
#
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --mem-per-cpu=4gb

module load matlab/2017b

matlab -nodisplay -r generate_LR_HR 

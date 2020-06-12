#!/bin/bash

output_dir="model_output_20180115112852"
phase="test"
# modify testing_set. Image has already added noise.
# testing_set="./datasets/test/*.jpg" # single image.
testing_set="Set12/*.png" # multiple images.
checkpoint="model-74000"

python main.py --output_dir="$output_dir" \
               --phase="$phase" \
               --testing_set="$testing_set" \
               --checkpoint="$checkpoint"

# -*- coding:utf-8 -*-
"""
An implementation of acGAN using TensorFlow (work in progress).
"""

import tensorflow as tf
import numpy as np
from model import MemNet
import os
import glob
import cv2



def main(_):
    tf_flags = tf.app.flags.FLAGS
    # gpu config.
    config = tf.ConfigProto()
    config.gpu_options.per_process_gpu_memory_fraction = 0.9

    if tf_flags.phase == "train":
        with tf.Session(config=config) as sess: 
            # sess = tf.Session(config=config) # when use queue to load data, not use with to define sess
            train_model = MemNet.MemNet(sess, tf_flags)
            train_model.train(tf_flags.training_steps, tf_flags.summary_steps, 
                tf_flags.checkpoint_steps, tf_flags.save_steps)
    else:
        with tf.Session(config=config) as sess:
            test_model = MemNet.MemNet(sess, tf_flags)
            test_model.load(tf_flags.checkpoint)
            # test Set12
            # get psnr and ssim outside
            save_path = "/fred/oz138/COS80024/SOFTWARE/Performance-Measurement-of-AI-Assisted-Satellite-Imagery/Memnet_N/results/"
            for image_file in glob.glob(tf_flags.testing_set):
                print("testing {}...".format(image_file))
                # testing_set is path/*.jpg.
                img = cv2.imread(image_file)
                ycrcb = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)
                y, cr, cb = cv2.split(ycrcb)
                c_image = np.reshape(cv2.resize(y, (tf_flags.img_size, tf_flags.img_size)),
                    (1, tf_flags.img_size, tf_flags.img_size, 1)) / 255.
                # In Caffe, Tensorflow, might must divide 255.?
                recovery_image = test_model.test(c_image)
                width = int(recovery_image.shape[2])
                height = int(recovery_image.shape[1])
                cr = cv2.resize(cr, (width, height), interpolation=cv2.INTER_CUBIC)
                cb = cv2.resize(cb, (width, height), interpolation=cv2.INTER_CUBIC)
                sr_image = np.zeros((width,height, 3),dtype=np.uint8)
                sr_image[:,:, 0]= np.uint8(recovery_image[0, :, :, 0].clip(0., 1.) * 255.)
                sr_image[:,:, 1] = cr
                sr_image[:,:, 2] = cb
                sr_image = cv2.cvtColor(sr_image, cv2.COLOR_YCrCb2BGR)
                # save image
                cv2.imwrite(os.path.join(save_path, image_file.split("/")[1]), sr_image)
                # recovery_image[0, :], 3D array.
            print("Testing done.")

if __name__ == '__main__':
    tf.app.flags.DEFINE_string("output_dir", "model_output", 
                               "checkpoint and summary directory.")
    tf.app.flags.DEFINE_string("phase", "train", 
                               "model phase: train/test.")
    tf.app.flags.DEFINE_string("training_set", "", 
                               "dataset path for training.")
    tf.app.flags.DEFINE_string("testing_set", "", 
                               "dataset path for testing.")
    tf.app.flags.DEFINE_integer("img_size", 256, 
                                "testing image size.")
    tf.app.flags.DEFINE_integer("batch_size", 64, 
                                "batch size for training.")
    tf.app.flags.DEFINE_integer("training_steps", 100000, 
                                "total training steps.")
    tf.app.flags.DEFINE_integer("summary_steps", 100, 
                                "summary period.")
    tf.app.flags.DEFINE_integer("checkpoint_steps", 1000, 
                                "checkpoint period.")
    tf.app.flags.DEFINE_integer("save_steps", 100, 
                                "checkpoint period.")
    tf.app.flags.DEFINE_string("checkpoint", None, 
                                "checkpoint name for restoring.")
    tf.app.run(main=main)

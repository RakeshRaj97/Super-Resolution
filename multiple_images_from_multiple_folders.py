#LIBRARIES

import cv2
import numpy as np
from scipy.ndimage import gaussian_filter
from PIL import Image
import glob
import os
import math
#-----------------------------------------
#multiple images from multiple folders
img_dir = r"C:\Users\ramesh\Desktop\New folder (2)" # Enter Directory of all images 
data_path = os.path.join(img_dir,'*g')
files = glob.glob(data_path)
data=[]
for f1 in files:
    img = cv2.imread(f1)
    data.append(img)

img_dir1 = r"C:\Users\ramesh\Desktop\lr" # Enter Directory of all images 
data_path1 = os.path.join(img_dir1,'*g')
files1 = glob.glob(data_path1)
data1 = []
for f2 in files1:
    img1 = cv2.imread(f2)
    data1.append(img1)


original=data

edited=data1


 
#FUNCTIONS

#Mean square error
def MSE(imgA,imgB):
    a=np.array(imgA)
    b=np.array(imgB)
    mse = np.mean( (a - b) ** 2 )
    if mse == 0:
        return 100
    else: 
        return mse
    
  
 #Peak signal to noise ratio
def PSNR(imgA,imgB):
    a=np.array(imgA)
    b=np.array(imgB)
    mse = np.mean( (a - b) ** 2 )
    if mse == 0:
        return 100
    const=255**2
    frac=float(const/mse)
    return 10*math.log10(frac)
    


#SSIM Structural SIMilarity Index (SSIM).
def ssim(imgA,imgB):
    def __get_kernels():
        k1, k2, l = (0.01, 0.03, 255.0)
        kern1, kern2 = map(lambda x: (x * l) ** 2, (k1, k2))
        return kern1, kern2

    def __get_mus(i1, i2):
        mu1, mu2 = map(lambda x: gaussian_filter(x, 1.5), (i1, i2))
        m1m1, m2m2, m1m2 = (mu1 * mu1, mu2 * mu2, mu1 * mu2)
        return m1m1, m2m2, m1m2

    def __get_sigmas(i1, i2, delta1, delta2, delta12):
        f1 = gaussian_filter(i1 * i1, 1.5) - delta1
        f2 = gaussian_filter(i2 * i2, 1.5) - delta2
        f12 =gaussian_filter(i1 * i2, 1.5) - delta12
        return f1, f2, f12

    def __get_positive_ssimap(C1, C2, m1m2, mu11, mu22, s12, s1s1, s2s2):
        num = (2 * m1m2 + C1) * (2 * s12 + C2)
        den = (mu11 + mu22 + C1) * (s1s1 + s2s2 + C2)
        return num / den

    def __get_negative_ssimap(C1, C2, m1m2, m11, m22, s12, s1s1, s2s2):
        (num1, num2) = (2.0 * m1m2 + C1, 2.0 * s12 + C2)
        (den1, den2) = (m11 + m22 + C1, s1s1 + s2s2 + C2)
        ssim_map = __n.ones(img1.shape)
        indx = (den1 * den2 > 0)
        ssim_map[indx] = (num1[indx] * num2[indx]) / (den1[indx] * den2[indx])
        indx = __n.bitwise_and(den1 != 0, den2 == 0)
        ssim_map[indx] = num1[indx] / den1[indx]
        return ssim_map

    #(img1, img2) = (imgA.astype('double'), imgB.astype('double'))
    img1 = np.array(imgA, dtype=np.double)
    img2 = np.array(imgB, dtype=np.double)
    (m1m1, m2m2, m1m2) = __get_mus(img1, img2)
    (s1, s2, s12) = __get_sigmas(img1, img2, m1m1, m2m2, m1m2)
    (C1, C2) = __get_kernels()
    if C1 > 0 and C2 > 0:
        ssim_map = __get_positive_ssimap(C1, C2, m1m2, m1m1, m2m2, s12, s1, s2)
    else:
        ssim_map = __get_negative_ssimap(C1, C2, m1m2, m1m1, m2m2, s12, s1, s2)
    ssim_value = ssim_map.mean()
    return ssim_value
for (i,j) in zip(original,edited):
    MSE_k=MSE(i,j)
    PSNR_k=PSNR(i,j)
    SSIM_k=ssim(i,j)
    print("MSE=",MSE_k)
    print("PSNR=",PSNR_k)
    print("SSIM=",SSIM_k)
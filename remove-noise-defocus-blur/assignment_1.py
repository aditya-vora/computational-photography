
# coding: utf-8

# #Programming Assignment 1
# 
# 1. Capture a normal image and noisy image of a scene. Add noise to the normal image so that it looks the same as the noisy image (Use PSNR to check).
# 
# 2. Capture a normal image and a defocus blurred image of a planar scene. Blur the normal image so that it looks the same as the defocus blurred image (Use average gradient magnitude measure to check).
# 
# 3. Capture a normal image and a motion blurred image of a dynamic scene. Blur the normal image so that it looks the same as the motion blurred image (Use average gradient magnitude measure to check).

# In[42]:

# Import the libraries
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as img
from PIL import Image
import os,os.path
import sys
import cv2
import math


# In[43]:

# Define the root directory
# Change the root directory as per the machine.
root = '/home/aditya/Documents/Documents and Data/Semester_2_M.Tech/computationalPhotography/assignment1/'
# Define the path of image directory
image_root = root + '/images'


# # Question-1
# 
# We have a normal image of a scene and a scene with some sort of noise. We have to introduce noise to the normal image so that it looks same as the noisy one. We need to use PSNR as a metric of comparision.

# In[44]:

# Read and Plot the original image without noise of a planar scene and another image with 
# noise taken under high ISO condition of camera.
im_wo_noise = img.imread(image_root + '/IMG_wo_noise.JPG')
im_wo_noise_rs = cv2.resize(im_wo_noise,None,fx=0.1, fy=0.1, interpolation = cv2.INTER_CUBIC)
im_w_noise = img.imread(image_root + '/IMG_with_noise.JPG')
im_w_noise_rs = cv2.resize(im_w_noise,None,fx=0.1, fy=0.1, interpolation = cv2.INTER_CUBIC)
plt.subplot(121),plt.imshow(im_wo_noise_rs),plt.title('Original without Noise')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(im_w_noise_rs),plt.title('Image with Noise')
plt.xticks([]), plt.yticks([])
plt.show()


# In[45]:

def psnr(im1, im2):
    im1 = np.asarray(im1)
    im2 = np.asarray(im2)
    error = im1 - im2
    # Calculate the mean square error
    MSE = np.sqrt((np.sum(error * error))/im1.size)
    # Formula to calculate Signal to noise ratio.
    psnr = 20*math.log10(255.0/MSE)
    return psnr

# Normalize the image without noise to scale the pixel intensities between 0-1.
im_norm = cv2.normalize(im_wo_noise_rs, alpha=0.0, beta=1.0, norm_type=cv2.cv.CV_MINMAX, dtype=cv2.cv.CV_64F)
size = np.shape(im_norm)

# Generate random Gaussian noise.
noise = np.random.randint(0,255,size)  

# Normalize the noise intensity values between 0-1.
noise_norm = cv2.normalize(noise, 0.0, 1.0,  norm_type=cv2.cv.CV_MINMAX, dtype=cv2.cv.CV_64F)

# Initialization
i=0
psnr1 = 0
psnr2 = 0
while psnr1>=psnr2:
    
    # Weighted addition between the image and noise.
    im_w_gn = (1-i)*im_norm + i*noise_norm
    im_w_gn_norm = cv2.normalize(im_w_gn, 0.0, 1.0,  norm_type=cv2.cv.CV_MINMAX, dtype=cv2.cv.CV_64F)
    im_w_gn_us = np.uint8(255*im_w_gn_norm)
    
    # Calculating the PSNR between the Image after addition of Gaussian noise and image 
    # without noise. 
    psnr1 = psnr(im_w_gn_us, im_wo_noise_rs)
    
    # Calculating the PSNR between the Image with noise and image without noise. 
    psnr2 = psnr(im_w_noise_rs, im_wo_noise_rs)
    i = i + 0.1

print "PSNR between the Image after addition of Gaussian noise and image without noise ",round(psnr1,3)
print "PSNR between the Image with noise and image without noise ",round(psnr2,3)

plt.subplot(121),plt.imshow(im_w_gn_us),plt.title('Original with Gaussian Noise')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(im_w_noise_rs),plt.title('Image with Captured Noise')
plt.xticks([]), plt.yticks([])
plt.show()


# # Question-2
# We have a normal image without defocus blur of a planar scene. We have another image with defocus blur of the same scene. We need to blur the original image untill we get the defocus blured image by applying filtering operation. We will use average gradient magnitude to check for similiarity between two images.  

# In[46]:

# Read and Plot the original image of a planar scene with/without defocus blur.
im_wo_blur = img.imread(image_root + '/IMG_wo_blur.JPG')
im_wo_blur_rs = cv2.resize(im_wo_blur,None,fx=0.1, fy=0.1, interpolation = cv2.INTER_CUBIC)
im_w_blur = img.imread(image_root + '/IMG_with_blur.JPG')
im_w_blur_rs = cv2.resize(im_w_blur,None,fx=0.1, fy=0.1, interpolation = cv2.INTER_CUBIC)
plt.subplot(121),plt.imshow(im_wo_blur_rs),plt.title('Original without Defocus blur')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(im_w_blur_rs),plt.title('Image with Defocus Blur')
plt.xticks([]), plt.yticks([])
plt.show()


# In[47]:

# This loop iteratively changes the kernel size of the averaging filter and applies 
# on the original image without defocus blur and then compares with defocus blurred image 
# using average gradient measure as a metric of comparison.

# Initialize the kernel size, average gradient of original image and the blurred image.
kernel_size = 3
avg_ori = 0
avg_blur = 0
while avg_ori >= avg_blur:
    # Applying the averaging filter. 
    oriblur = cv2.blur(im_wo_blur_rs,(kernel_size,kernel_size))
    # Using a sobel filter in order to compute the gradient.
    sobelx64f = cv2.Sobel(oriblur,cv2.CV_64F,1,0,ksize=3)
    abs_sobelx64f = np.absolute(sobelx64f)
    sobelx_8u = np.uint8(abs_sobelx64f)
    sobely64f = cv2.Sobel(oriblur,cv2.CV_64F,0,1,ksize=3)
    abs_sobely64f = np.absolute(sobely64f)
    sobely_8u = np.uint8(abs_sobely64f)
    # Taking weighted average of both the gradient images of X and Y direction.
    grad_ori = cv2.addWeighted( sobelx_8u, 0.5, sobely_8u, 0.5, 0 );
    # Computing the average gradient. 
    avg_ori = np.mean(grad_ori)
    # Using a sobel filter in order to compute the gradient of the defocus blured Image.
    sobelx64f_1 = cv2.Sobel(im_w_blur_rs,cv2.CV_64F,1,0,ksize=3)
    abs_sobelx64f_1 = np.absolute(sobelx64f_1)
    sobelx_8u_1 = np.uint8(abs_sobelx64f_1)
    sobely64f_1 = cv2.Sobel(im_w_blur_rs,cv2.CV_64F,0,1,ksize=3)
    abs_sobely64f_1 = np.absolute(sobely64f_1)
    sobely_8u_1 = np.uint8(abs_sobely64f_1)
    gradient_1 = cv2.addWeighted( sobelx_8u_1, 0.5, sobely_8u_1, 0.5, 0 )
    # Computing the average gradient.
    avg_blur = np.mean(gradient_1)
    kernel_size = kernel_size+2

k_final = kernel_size - 2    
print 'Kernel Size =',k_final
print 'Average Gradient Score of Original Image without Defocus Blur after filtering =',round(avg_ori,3)
print 'Average Gradient Score of Defocus Blurred Image =',round(avg_blur,3)


# In[48]:

plt.subplot(121),plt.imshow(oriblur),plt.title('Original Image after bluring ')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(im_w_blur_rs),plt.title('Original Defocus Blured Image')
plt.xticks([]), plt.yticks([])
plt.show()


# #Question 3
# 
# We have a normal image without motion blur of a dynamic scene. We have another image with motion blur of the same scene. We need to blur the original image untill we get the motion blured image by applying filtering operation. We will use average gradient magnitude to check for similiarity between two images.

# In[62]:

# Read and Plot the original image of a dynamic scene with/without defocus blur.
im_wo_mblur = img.imread(image_root + '/flowerwoMB.JPG')
im_wo_mblur_rs = cv2.resize(im_wo_mblur,None,fx=0.1, fy=0.1, interpolation = cv2.INTER_CUBIC)
im_w_mblur = img.imread(image_root + '/flowerwithMB.JPG')
im_w_mblur_rs = cv2.resize(im_w_mblur,None,fx=0.1, fy=0.1, interpolation = cv2.INTER_CUBIC)
plt.subplot(121),plt.imshow(im_wo_mblur_rs),plt.title('Original without Motion blur')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(im_w_mblur_rs),plt.title('Image with Motion Blur')
plt.xticks([]), plt.yticks([])
plt.show()


# In[63]:

# This loop iteratively changes the kernel size of the averaging filter and applies 
# on the original image without motion blur and then compares with motion blurred image 
# using average gradient measure as a metric of comparison.

# Initialize the kernel size, average gradient of original image and the blurred image.

kernel_size = 3


avg_ori = 0
avg_blur = 0


# In[64]:

oriblur = im_wo_mblur_rs
while avg_ori >= avg_blur:
    # Here the kernel is Identity since the motion blur seems to be in 45 degrees of angle.
    kernel = np.identity(kernel_size, np.float32)/kernel_size
    
    
    # Applying the averaging filter. 
    oriblur = cv2.filter2D(oriblur,-1,kernel)
    # Using a sobel filter in order to compute the gradient.
    sobelx64f = cv2.Sobel(oriblur,cv2.CV_64F,1,0,ksize=3)
    abs_sobelx64f = np.absolute(sobelx64f)
    sobelx_8u = np.uint8(abs_sobelx64f)
    sobely64f = cv2.Sobel(oriblur,cv2.CV_64F,0,1,ksize=3)
    abs_sobely64f = np.absolute(sobely64f)
    sobely_8u = np.uint8(abs_sobely64f)
    # Taking weighted average of both the gradient images of X and Y direction.
    grad_ori = cv2.addWeighted( sobelx_8u, 0.5, sobely_8u, 0.5, 0 );
    # Computing the average gradient. 
    avg_ori = np.mean(grad_ori)
    # Using a sobel filter in order to compute the gradient of the defocus blured Image.
    sobelx64f_1 = cv2.Sobel(im_w_mblur_rs,cv2.CV_64F,1,0,ksize=3)
    abs_sobelx64f_1 = np.absolute(sobelx64f_1)
    sobelx_8u_1 = np.uint8(abs_sobelx64f_1)
    sobely64f_1 = cv2.Sobel(im_w_mblur_rs,cv2.CV_64F,0,1,ksize=3)
    abs_sobely64f_1 = np.absolute(sobely64f_1)
    sobely_8u_1 = np.uint8(abs_sobely64f_1)
    gradient_1 = cv2.addWeighted( sobelx_8u_1, 0.5, sobely_8u_1, 0.5, 0 )
    # Computing the average gradient.
    avg_blur = np.mean(gradient_1)
    kernel_size = kernel_size+2

k_final = kernel_size - 2    
print 'Kernel Size =',k_final
print 'Average Gradient Score of Original Image without motion Blur after filtering =',round(avg_ori,3)
print 'Average Gradient Score of Motion Blurred Image =',round(avg_blur,3)


# In[65]:


plt.subplot(121),plt.imshow(oriblur),plt.title('Original Image after Bluring ')
plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(im_w_mblur_rs),plt.title('Original Motion Blured Image')
plt.xticks([]), plt.yticks([])
plt.show()


# In[ ]:




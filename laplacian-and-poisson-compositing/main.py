
# coding: utf-8

# #Assignment 5 Question 1
#  Given two images, create a seamless composite image using Laplacian compositing 

# In[1]:

# Loading the required libraries
import numpy as np
import sys
import cv2
import matplotlib.image as img
import matplotlib.pyplot as plt
from numpy import linalg as LA


# In[2]:

# Reading the two images to be blended
img_1 = img.imread('apple.jpg')            # RGB color image
img_2 = img.imread('orange.jpg')           # RGB color image
print "The size of first image is : {}x{}".format(img_1.shape[0], img_1.shape[1])
print "The size of second image is : {}x{}".format(img_2.shape[0], img_2.shape[1])


# In[3]:

# Plotting the two images
plt.subplot(121),plt.imshow(img_1),plt.title('Original Image 1')
plt.xticks([]), plt.yticks([])

plt.subplot(122),plt.imshow(img_2),plt.title('Original Image 2')
plt.xticks([]), plt.yticks([])
plt.show()


# In[4]:

# generate Gaussian pyramid for Image 1
G = img_1.copy()      # Copy image 1 into array G
gpimg_1 = [G]         # Create a list gpimg_1 of array G
for i in xrange(6):   # Create Gaussian pyramid upto level 6
    G = cv2.pyrDown(G)# Creates a Gaussian pyramid by downsampling the array G by a factor 
                      # of 2
    gpimg_1.append(G) # Append the pyramid to the list 


# In[5]:

# generate Gaussian pyramid for Image 2
G = img_2.copy()          # Copy the Image 2 into array G
gpimg_2 = [G]             # Create a list gpimg_2 of array G             
for i in xrange(6):       # Create a Gaussian pyramid upto level 6
    G = cv2.pyrDown(G)    # Creates a Gaussian pyramid by downsampling the array G 
                          # by a factor of 2

    gpimg_2.append(G)     # Append the pyramid to the list


# In[6]:

# generate Laplacian Pyramid for Image 1
lpimg_1 = [gpimg_1[5]]                  # list of Gaussian pyramid
for i in xrange(5,0,-1):                  
    GE = cv2.pyrUp(gpimg_1[i])          # Upsample the current image in the gaussian pyramid
    L = cv2.subtract(gpimg_1[i-1],GE)       
                                        # Obtain laplacian pyramid from difference of 
                                        # Gaussian pyramid
    lpimg_1.append(L)                   # Append the obtained laplacian image to the 
                                        # Laplacian pyramid 


# In[7]:

# generate Laplacian Pyramid for Image 2
lpimg_2 = [gpimg_2[5]]
for i in xrange(5,0,-1):
    GE = cv2.pyrUp(gpimg_2[i])
    L = cv2.subtract(gpimg_1[i-1],GE)
    lpimg_2.append(L)


# In[8]:

# Now add left and right halves of images in each level
LS = []
for la,lb in zip(lpimg_1,lpimg_2):
    rows,cols,dpt = la.shape
    # At each level left part is frm image 1 and right part is from image 2
    ls = np.hstack((la[:,0:cols/2], lb[:,cols/2:]))
    # Append the image to pyramid
    LS.append(ls)


# In[9]:

# Now reconstruct the blended image by upsampling the image of each level once and then
# adding it to the blended image.
ls_ = LS[0]
for i in xrange(1,6):
    ls_ = cv2.pyrUp(ls_)
    ls_ = cv2.add(ls_, LS[i])
    
print "Size of the final blended image is : {}x{}".format(ls_.shape[0],ls_.shape[1])    


# In[10]:


# Plot the final blended image 
plt.imshow(ls_),plt.title('Blended Image')
plt.xticks([]),plt.yticks([])
plt.show()


# In[ ]:




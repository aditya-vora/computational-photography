
# coding: utf-8

# #Assignment 4
# 
# Capture 10 overlapping photographs of a static scene which is far from your camera. Stitch them to make a panorama/mosaic of the scene to depict extended field of view in a single photograph.

# In[1]:

# Importing the libraries
import numpy as np
import cv2
from matplotlib import pyplot as plt
import matplotlib.image as img
from numpy import linalg as LA


# In[2]:

# Reading all the 10 images
img1 = img.imread('IMG_1.jpg')
img2 = img.imread('IMG_2.jpg')
img3 = img.imread('IMG_3.jpg')
img4 = img.imread('IMG_4.jpg')
img5 = img.imread('IMG_5.jpg')
img6 = img.imread('IMG_6.jpg')
img7 = img.imread('IMG_7.jpg')
img8 = img.imread('IMG_8.jpg')
img9 = img.imread('IMG_9.jpg')
img10 = img.imread('IMG_10.jpg')

print "All 10 images are of sizes {}x{}".format(img1.shape[1],img1.shape[0])
plt.subplot(251),plt.imshow(img1),plt.title('Image 1')
plt.xticks([]),plt.yticks([])
plt.subplot(252),plt.imshow(img2),plt.title('Image 2')
plt.xticks([]),plt.yticks([])
plt.subplot(253),plt.imshow(img3),plt.title('Image 3')
plt.xticks([]),plt.yticks([])
plt.subplot(254),plt.imshow(img4),plt.title('Image 4')
plt.xticks([]),plt.yticks([])
plt.subplot(255),plt.imshow(img5),plt.title('Image 5')
plt.xticks([]),plt.yticks([])
plt.subplot(256),plt.imshow(img6),plt.title('Image 6')
plt.xticks([]),plt.yticks([])
plt.subplot(257),plt.imshow(img7),plt.title('Image 7')
plt.xticks([]),plt.yticks([])
plt.subplot(258),plt.imshow(img8),plt.title('Image 8')
plt.xticks([]),plt.yticks([])
plt.subplot(259),plt.imshow(img9),plt.title('Image 9')
plt.xticks([]),plt.yticks([])
plt.subplot(250),plt.imshow(img10),plt.title('Image 10')
plt.xticks([]),plt.yticks([])
plt.show()


# In[3]:

def stitch(img1,img2):
    # Initializing the ORB detector
    orb = cv2.ORB()
    # Detecting the keypoints between the two images and finding the descriptor
    kp1, des1 = orb.detectAndCompute(img1,None)
    kp2, des2 = orb.detectAndCompute(img2,None)
    
    # Draws the keypoints
    img1_kp = cv2.drawKeypoints(img1, kp1, flags = 
                                cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    img2_kp = cv2.drawKeypoints(img2, kp2, flags = 
                                cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    # create BFMatcher object
    bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
    # Match descriptors.
    matches = bf.match(des1,des2)
    # Sort them in the order of their distance.
    matches = sorted(matches, key = lambda x:x.distance)
    pts1 = []
    pts2 = []
    # Picking best 10 keypoints
    for m in range(0,10):
        pts1.append(kp1[matches[m].queryIdx].pt)
        pts2.append(kp2[matches[m].trainIdx].pt)
    pts1 = np.asarray(pts1, dtype = np.float32)
    pts2 = np.asarray(pts2, dtype = np.float32)
    # Find the homography matrix and transform image 2 to image 1
    M_hom,inliers = cv2.findHomography(pts1, pts2, cv2.LMEDS)
    # Apply the homography matrix to image 2
    img_pano = cv2.warpPerspective(img2, np.linalg.inv(M_hom),(img1.shape[1] + 
                                                img2.shape[1], img1.shape[0]))
    img_pano[0:img1.shape[0], 0:img1.shape[1], :] = img1 # Past the image into the matrix
    img_pano_gray = cv2.cvtColor(img_pano, cv2.COLOR_BGR2GRAY)
    m,n = img_pano_gray.shape
    cols = n-1
    while img_pano_gray[0,cols] == 0 :
        cols = cols-1    
        
    img_pano_new = img_pano[:,0:cols-1,:]
    return img_pano_new


# In[4]:

img = stitch(img1,img2)
img = stitch(img,img3)
img = stitch(img,img4)
img = stitch(img,img5)
img = stitch(img,img6)
img = stitch(img,img7)
img = stitch(img,img8)
img = stitch(img,img9)
img = stitch(img,img10)


# In[5]:

plt.imshow(img),plt.title('Panorama Image')
plt.xticks([]), plt.yticks([])
plt.show()


# In[9]:

plt.imsave('Panorama.jpg',img)


# In[ ]:




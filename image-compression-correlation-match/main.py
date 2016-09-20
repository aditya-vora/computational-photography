
# coding: utf-8

# # Assignment 3_Q1
# 
# * Perform image compression using SVD and validate using appropriate measure.
# 

# In[60]:

# Problem statement 1: Perform image compression using SVD and validate the result using an
# appropriate measure.
# Loading the required libraries
import numpy as np
import cv2
import matplotlib.image as img
import matplotlib.pyplot as plt

from numpy import linalg as LA


# In[61]:

# Function converts RGB image to Gray scale image
def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])


# In[62]:

# Load an color image 
img = img.imread('image.jpg')
imGray = rgb2gray(img)        # Convert the colour image to gray scale
m,n = imGray.shape            # Get the shape of the image
# plot the image
plt.imshow(imGray, cmap = plt.get_cmap('gray')),plt.title('Original Full Rank image')
plt.xticks([]), plt.yticks([])
plt.show()



# * This section of the problem performs the **singular value decomposition** of the image. 
# * After the singular value decomposition of the image we shall obtain **two matrices** and a **vector**. 
# * For Eg. Here the size of the image is 298x298 so after the SVD of the image we shall obtain 2 matrices U and V of dimension 298x298 each and a vector S of 298x1 dimension. The vector contains all the singular values of the image while the matrices U and V contain the eigenvectors of the image. 
# * Here we are plotting a graph of the **rank of the image vs. the singular values**. We can observe that the singular value decreases as the rank of the matrix increases which is how it should be in the case of SVD.

# In[63]:

# Compute the Singular Value Decomposition
U, S, V = np.linalg.svd(imGray, full_matrices=True)
# Plot the rank of the image vs. Singular values
plt.plot(S,'ro')
plt.axis([0,50,0,40000])
plt.title('Rank of image vs. Singular values')
plt.xlabel('Rank of the image')
plt.ylabel('Singular Values')
plt.grid(True)
plt.show()


# In[64]:

# Converting the S vector of singular values into a diagnol matrix.
Sm = np.zeros(shape=(m,n))  # Zero matrix of size mxn = size of the image
U = np.mat(U)
Sm = np.mat(Sm)
V = np.mat(V)
tot = len(S)                
for i in range(0,tot):
    Sm[i,i] = S[i]          # Forming the diagnol matrix Sm


# * Here we are plotting a graph of **rank of the matrix vs. the error** between the **recovered image and the original image**. We are considering **Frobenius norm** between the recovered image and the original image in order compute the error. 
# * We can observe that the error decreases as the rank of the matrix increase. Thus as we consider higher and higher rank of the image we get closer and closer to the original image.

# In[65]:

error = []
for i in range(0,tot):
    imRec = U[:,0:i]*Sm[0:i,0:i]*V[0:i,:]
    error.append(LA.norm((imGray - imRec), 'fro'))
plt.plot(error,'go')
plt.axis([0,100,0,40000])
plt.title('Rank of the image vs. Frobenius norm')
plt.xlabel('Rank of the image')
plt.ylabel('Frobenius norm')
plt.grid(True)
plt.show()


# In[68]:

# Recovering images with different ranks and computing the frobenius norm.
imRec2 = U[:,0:1]*Sm[0:1,0:1]*V[0:1,:]
imRec2 = np.uint8(imRec2)
normR2 = LA.norm((imGray - imRec2), 'fro')

imRec4 = U[:,0:3]*Sm[0:3,0:3]*V[0:3,:]
imRec4 = np.uint8(imRec4)
normR4 = LA.norm((imGray - imRec4), 'fro')

imRec6 = U[:,0:5]*Sm[0:5,0:5]*V[0:5,:]
imRec6 = np.uint8(imRec6)
normR6 = LA.norm((imGray - imRec6), 'fro')

imRec8 = U[:,0:7]*Sm[0:7,0:7]*V[0:7,:]
imRec4 = np.uint8(imRec8)
normR8 = LA.norm((imGray - imRec8), 'fro')

imRec10 = U[:,0:9]*Sm[0:9,0:9]*V[0:9,:]
imRec10 = np.uint8(imRec10)
normR10 = LA.norm((imGray - imRec10), 'fro')

imRec20 = U[:,0:19]*Sm[0:19,0:19]*V[0:19,:]
imRec20 = np.uint8(imRec20)
normR20 = LA.norm((imGray - imRec20), 'fro')

 


# In[76]:

# Plotting the results.
plt.subplot(131),plt.imshow(imRec2,cmap = plt.get_cmap('gray')),plt.title('Image with Rank 2')
plt.xticks([]), plt.yticks([])
plt.subplot(132),plt.imshow(imRec4,cmap = plt.get_cmap('gray')),plt.title('Image with Rank 4')
plt.xticks([]), plt.yticks([])
plt.subplot(133),plt.imshow(imRec6,cmap = plt.get_cmap('gray')),plt.title('Image with Rank 6')
plt.xticks([]), plt.yticks([])
plt.show()

plt.subplot(131),plt.imshow(imRec8,cmap = plt.get_cmap('gray')),

plt.title('Image with Rank 8')
plt.xticks([]), plt.yticks([])

plt.subplot(132),plt.imshow(imRec10,cmap = plt.get_cmap('gray')),plt.title('Image with Rank 10')
plt.xticks([]), plt.yticks([])
plt.subplot(133),plt.imshow(imRec20,cmap = plt.get_cmap('gray')),plt.title('Image with Rank 20')
plt.xticks([]), plt.yticks([])
plt.show()

print 'Frobenius norm for rank 2 image ',normR2
print 'Frobenius norm for rank 4 image ',normR4
print 'Frobenius norm for rank 6 image ',normR6
print 'Frobenius norm for rank 8 image ',normR8
print 'Frobenius norm for rank 10 image ',normR10
print 'Frobenius norm for rank 20 image ',normR20


# In[ ]:




/*****************************************************************************************************************/

********************************** COMPUTATIONAL PHOTOGRAPHY ASSIGNMENT 5 *****************************************
NAME : 		ADITYA VORA
ROLL NUMBER :	14410006
DEPARTMENT :	ELECTRICAL ENGINEERING


PROBLEM	
------------------------------------------------------------------------------------------------------------------
Given two images, create a seamless composite image using Laplacian compositing and Poisson image editing.

IMAGES : 1) orange.JPG for Laplacian Blending
	 2) apple.JPG for Laplacian Blending
	 3) lena.png for poisson image editing
	 4) girl.png for poisson image editing
 

PROCEDURE:
------------------------------------------------------------------------------------------------------------------
LAPLACIAN COMPOSITING
1) Make gaussian pyramid for both the images
2) Generate Laplacian pyramid from gaussian pyramid by difference of gaussian. 
3) Add up all the images of the laplacian pyramid.

------------------------------------------------------------------------------------------------------------------
POISSON IMAGE BLENDING
1) Read two images.
2) Compute the horizontal and vertical gradient of both images.
3) Select the area of one of the image to be blended.
4) Replace the region of other image with the selected region.
5) Also replace the gradient of other image with the gradient of the selected region.
6) Mask the region to be blended.
7) Solve the second order partial differential equation using numerical methods such as Jacobi Method.



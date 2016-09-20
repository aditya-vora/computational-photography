/*****************************************************************************************************************/

**********************************COMPUTATIONAL PHOTOGRAPHY ASSIGNMENT 1******************************************
NAME : 		ADITYA VORA
ROLL NUMBER :	14410006
DEPARTMENT :	ELECTRICAL ENGINEERING

Note to Run the .py File : Kindly change the root path defined in the python script as per the location of the file in your laptop before running the program so that no error occurs.

PROBLEM-1
------------------------------------------------------------------------------------------------------------------
We have two images. One is the image without any noise, and the other is the image with some which was captured at high ISO. We were supposed to introduce noise to the noise free image till the peak signal to noise ratio of both the images, the original image with noise and noisy image have nearly are same.

IMAGES : 1) IMG_with_noise.JPG
	 2) IMG_wo_noise.JPG

RESULTS

PSNR :  PSNR between the Image after addition of Gaussian noise and Image without noise = 29.205
	PSNR between the Image with noise and Image without noise  29.228


PROBLEM-2
------------------------------------------------------------------------------------------------------------------
We have two images of a planar scene. One is the image without any defocus blur and the other is the image with some defocus blur obtained by adjusting the focus. We were suppose to filter the original image in order to blur it till it becomes similiar to the other one. We were suppose to compare both the images using average gradient magnitude.

IMAGES : 1) IMG_w_blur.JPG
	 2) IMG_wo_blur.JPG

RESULTS

Kernel Size of the averaging filter = 11

AVERAGE GRADIENT MAGNITUDE : 

Average Gradient Score of Original Image without Defocus Blur after filtering = 15.071
Average Gradient Score of Defocus Blurred Image = 15.682


PROBLEM-3
------------------------------------------------------------------------------------------------------------------
We have two images of a dynamic scene. One is the image without any motion blur and the other is the image with some motion blur obtained by decreasing the shutter speed. We were suppose to filter the original image in order to blur it till it becomes similiar to the other one. We were suppose to compare both the images using average gradient magnitude.

IMAGES : 1) IMG_w_MB.JPG
	 2) IMG_wo_MB.JPG

RESULTS

Kernel Size of the averaging filter = 5

AVERAGE GRADIENT MAGNITUDE : 

Average Gradient Score of Original Image without motion Blur after filtering = 27.467
Average Gradient Score of Motion Blurred Image = 28.308

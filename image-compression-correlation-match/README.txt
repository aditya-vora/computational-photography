/*****************************************************************************************************************/

**********************************COMPUTATIONAL PHOTOGRAPHY ASSIGNMENT 3******************************************
NAME : 		ADITYA VORA
ROLL NUMBER :	14410006
DEPARTMENT :	ELECTRICAL ENGINEERING


PROBLEM-1	
------------------------------------------------------------------------------------------------------------------
Perform image compression using SVD and validate the result using an appropriate measure.

IMAGES : 1) image.JPG
	 

RESULTS

In order to compare the results of the compressed image with the original image I have considered the FROBENIUS NORM between the 
low rank image and the original one. Here the low rank image is ontained by selecting appropriate number of singular values from the total 
singular values of the image. So we approximate original image by an image with less singular values provided the frobenius norm is within the limits. Below are frobenius norm for rank 2,4,6,8,10,20 images.

Frobenius norm for rank 2 image is 10364.3549245
Frobenius norm for rank 4 image is 7893.97561435
Frobenius norm for rank 6 image is 7158.80422976
Frobenius norm for rank 8 image is 6769.48098913
Frobenius norm for rank 10 image is 6506.75187786
Frobenius norm for rank 20 image is 5594.27305376

As we see a trend in the frobenius norm the norm continuosly drops as the rank of the image increases which should be the case as by increasing the rank of the image we are reaching to the original form of the image.



PROBLEM-2
------------------------------------------------------------------------------------------------------------------
Establish correspondences between the corners detected in three images of the same scene captured from different view points.

IMAGES : 1) IMG1.JPG
	 2) IMG2.JPG
	 3) IMG3.JPG

RESULTS

We have established the correspondence between different keypoints in all the three images as we can see from the figures. In order to 
find the keypoints we have used ORB detector. After getting the keypoints in order to do the keypoints matching we have used the brute 
force approch. The results after matching can be seen in the figures. Though we are not obtaining perfect match between image keypoints.



 

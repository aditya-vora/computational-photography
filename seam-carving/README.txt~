/*****************************************************************************************************************/

********************************** COMPUTATIONAL PHOTOGRAPHY ASSIGNMENT 6 *****************************************
NAME : 		ADITYA VORA
ROLL NUMBER :	14410006
DEPARTMENT :	ELECTRICAL ENGINEERING


PROBLEM-1
------------------------------------------------------------------------------------------------------------------------
Develop a gradient domain HDR compression technique to compress the dynamic range of a given HDR image. Display the 
final tone mapped LDR image and evaluate its quality using dynamic range independent quality metric available online.

IMAGES : Image.hdr

FILES:
assignment6_Q1.m = This is the main function which is used to obtain the Low Dynamic Range image from the High Dynamic
		    Range image. The function displays original HDR image and the final Low Dynamic Range image.
FUNCTION FILES: 
GScale.m = Finds the guassian pyramid given the image, number of levels in the pyramid, kernel size, and sigma as input.
gradPyr.m = Finds the gradient of all the levels in the pyramid.
Phi.m = Finds the attenuation function phi which attenuates large values of gradients and small gradient value remains
        unchanged.
poisson_solver_function_neumann.m = Solves the poisson equation.


PROBLEM-2
-------------------------------------------------------------------------------------------------------------------------
Develop an algorithm to perform matting from an image of a foreground captured with two different background colors (blue, green).

IMAGES: 1) blue.png = Blue Screen Image.
        2) green.png = Green Screen Image.
        3) background.png = Back Ground Image.

FILES:
assignment6_Q2.m = This is the main function to solve question 2. It takes two images Blue Screen and Green Screen image 
                   as input and applies matting on it.
matting.m = Takes two images as input and computes the matte Alpha.

--------------------------------------------------------------------------------------------------------------------------
REFERENCES:
1.  A. Agrawal, R. Raskar and R. Chellappa, "What is the Range of Surface Reconstructions from a Gradient Field? European Conference on
    Computer Vision (ECCV) 2006
 
2.  A. Agrawal, R. Chellappa and R. Raskar, "An Algebraic approach to surface reconstructions from gradient fields? Intenational Conference 
    on Computer Vision (ICCV) 2006

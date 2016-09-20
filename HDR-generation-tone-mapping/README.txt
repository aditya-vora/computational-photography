/*****************************************************************************************************************/

********************************** COMPUTATIONAL PHOTOGRAPHY ASSIGNMENT 9 *****************************************
NAME : 		ADITYA VORA
ROLL NUMBER :	14410006
DEPARTMENT :	ELECTRICAL ENGINEERING


PROBLEM
------------------------------------------------------------------------------------------------------------------------
Given a set of multi-exposure images of a static scene captured using a static camera, design an approach to generate HDR 
image of the scene and estimate the camera response function. Tone map the HDR image using bilateral filter for display.

IMAGES : Inbuilt exposure stack of images that is used to create HDR image in matlab

FILES:
assignment9.m = This is the main function that implements the debevec and Malik algorithm to get the HDR image from stack of 
		images obtained from different exposures.

FUNCTION FILES: 
bilateralFilter.m = This function implements the bilateral filter given the image and the spatial parameter and 
		    range parameter as input argument.

getsamples.m = This function samples the stack of images to get few pixels from the stack which are then used to solve a 
		optimization problem to get the camera response function.

gsolve.m = This function solves the optimization problem in order to get the camera response function.

GetHDR.m = This function uses the camera response function and the weights of the pixels to obtain the final HDR image.

bilateralToneMap.m = This function is used to perform the tone mapping of the HDR image using Bilateral Filter.
--------------------------------------------------------------------------------------------------------------------------


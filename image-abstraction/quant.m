function I = quant( I, level )
%% 
% Function performs the quantization on the image.
% SYNTAX: 
% I = The output argument I is the output image
% I = The input argument I is the input image
% level = input argument which defines the quantization level. 

%% 
% Different image levels thresolded to a particular thresold.
I(I>0 & I<=level) = level; 
I(I>level & I<=2*level) = 2*level;
I(I>2*level & I<=3*level) = 3*level;
I(I>3*level & I<=4*level) = 4*level;
I(I>4*level & I<=5*level) = 5*level;
I(I>5*level & I<=6*level) = 6*level;
I(I>6*level & I<=7*level) = 7*level;
I(I>7*level & I<=8*level) = 8*level;
I(I>8*level & I<=9*level) = 9*level;
I(I>9*level & I<=10*level) = 10*level;
end


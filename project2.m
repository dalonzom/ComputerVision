clear 
clc 
%% Read in images
dir = fullfile('/Users/marissadalonzo/Documents/MATLAB/ComputerVision/Lab4/DanaHallWay2');
files = imageDatastore(dir);
image1 = rgb2gray(readimage(files,1)); 
image2 = rgb2gray(readimage(files,2)); 

%% Harris detector 
Rs1 = harrisDetector(image1, 10, 3); 
Rs2 = harrisDetector(image2, 10, 3); 



        



clear 
clc 
%% Read in images
dir = fullfile('/Users/marissadalonzo/Documents/MATLAB/ComputerVision/Project2/DanaHallWay2');
files = imageDatastore(dir);
image1 = rgb2gray(readimage(files,1)); 
image2 = rgb2gray(readimage(files,2)); 

%% Harris detector 
Rs1 = harrisDetector(image1, 100, 10); 
Rs2 = harrisDetector(image2, 100, 10); 

%% NCC 
filter = ones(3,3); 
image1squared = Rs1 .* Rs1; 
image2squared = Rs2 .* Rs2; 

image1squared = imfilter(image1squared, filter, 'replicate'); 
image2squared = imfilter(image2squared, filter, 'replicate');

image1squared = image1squared.^0.5; 
image2squared = image2squared.^0.5; 

Rs1 = Rs1 ./image1squared; 
Rs2 = Rs2 ./image2squared; 


        



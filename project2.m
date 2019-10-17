clear 
clc 
%% Read in images
first = 285; 
%dir = fullfile('/Users/marissadalonzo/Documents/MATLAB/ComputerVision/Project2/DanaHallWay2');
image1 = rgb2gray(imread('DanaHallWay2/DSC_0285.JPG'));
image2 = rgb2gray(imread('DanaHallWay2/DSC_0286.JPG'));

%image1 = rgb2gray(readimage(files,1)); 
%image2 = rgb2gray(readimage(files,2)); 

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
Rs1(isnan(Rs1)) = 0; 
Rs1 = imfilter(Rs1, filter, 'replicate'); 

Rs2 = Rs2 ./image2squared;
Rs2(isnan(Rs2)) = 0;
Rs2 = imfilter(Rs2, filter, 'replicate'); 

ncc = []; 
for i = 1:size(Rs1,1)
    for j = 1:size(Rs1,2)
        for k = 1:size(Rs2,1)
            for l = 1:size(Rs2,2)
                ncc = [ncc; Rs1(i,j)* Rs2(k,l)]; 
            end 
        end 
    end 
end



        



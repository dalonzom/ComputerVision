imageOrig = imread('DanaHallWay2/DSC_0285.JPG');
imageGray = rgb2gray(imageOrig);
figure; 
Rs = harrisDetector(imageGray, 100);
image('CData', imageOrig,'XData',[1 512], 'YData', [-1 -340])
for i = 1:size(Rs,1)
    for j = 1:size(Rs,2)
        if(Rs(i,j)>=150)
            hold on
            plot(j,-i,'.','MarkerSize',40)
        end
    end
end
%%
shiftNum = size(image2Orig,1);
shift = [1 0 0; 0 1 0; 0 shiftNum 1];
shiftHP = affine2d(shift);
[image1Shift image1ShiftRef] = imwarp(image1Orig, shiftHP);
image2Ref = imref2d(size(image2Orig));

figure(25);
clf;
imshowpair(image2Orig, image2Ref, image1Shift, image1ShiftRef, 'blend','Scaling','joint');

hold on

for i = 1:size(pairs,2)
    plot([pairs(i).col1, pairs(i).col2], [pairs(i).row1 + shiftNum, pairs(i).row2], 'Linewidth', 2);
end

figure(35);
clf;
imshowpair(image2Orig, image2Ref, image1Shift, image1ShiftRef, 'blend','Scaling','joint');

hold on

for i = 1:size(bestInliers,2)
    plot([bestInliers(i).col1, bestInliers(i).col2], [bestInliers(i).row1 + shiftNum, bestInliers(i).row2], 'Linewidth', 2);
end
baseImageEC = imread('DanaOffice/DSC_0309.JPG');
ecImage = imread('driveway.jpg');

row1 = [1 1 size(ecImage,1) size(ecImage,1)];
col1 = [1 size(ecImage,2) size(ecImage,2) 1];

figure(51);
clf;
imshow(baseImageEC);

[col2, row2] = ginput(4);

A = zeros(8,8);
b = zeros(8,1);
for i = 1:4
    point1_0 = [col1(i) row1(i)];
    point1_1 = [col2(i) row2(i)];
    A(2*i-1,:) = [point1_0 1 0 0 0 (-point1_0*point1_1(1))];
    A(2*i,:) = [0 0 0 point1_0 1 (-point1_0*point1_1(2))];
    b(2*i-1,1) = point1_1(1);
    b(2*i,1) = point1_1(2);
    hFlat = A\b;
    
    totalH = [hFlat(1:3)'; hFlat(4:6)'; hFlat(7:8)' 1];
end

baseImageECRef = imref2d(size(baseImageEC));

totalHP = projective2d(totalH');
[tfImage tfImageRef] = imwarp(ecImage,totalHP);
startX = round(tfImageRef.XWorldLimits(1));
endX = round(tfImageRef.XWorldLimits(2));
startY = round(tfImageRef.YWorldLimits(1));
endY = round(tfImageRef.YWorldLimits(2));
for i=(startY+1):endY
    for j=(startX+1):endX
        if(tfImage(i-startY,j-startX) ~= 0)
            baseImageEC(i,j,:) = tfImage(i-startY,j-startX,:);
        end
    end
end
%output = imwarp(baseImageEC, baseImageECRef, tfImage, tfImageRef, 'blend', 'Scaling', 'joint');
% for i = 1:1
%     baseImageEC = imfuse(tfImage, tfImageRef, baseImageEC, baseImageECRef, 'blend');
% end
imshow(baseImageEC);
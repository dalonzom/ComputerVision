clear

background = imread('office.jpg');
drivewayGray = rgb2gray(background); 
inserted = imread('nabeel.png');

insertedX = [1 size(inserted,2) size(inserted,2) 1];
insertedY = [1 1 size(inserted,1) size(inserted,1) ];


figure; 
imshow(background);
[x,y] = ginput(4);
coveredSegment = background(y(3):y(1),x(1):x(2), :); 

A = zeros(2,8);
b = [1 1 x(2) - x(1) 1 x(2) - x(1) y(2) - y(3) 1 y(2) - y(3)];
A = [insertedX(1) insertedY(1) 1 0 0 0 -insertedX(1)*x(1) -insertedY(1)*x(1);
     0 0 0 insertedX(1) insertedY(1) 1 -insertedX(1)*y(1) -insertedY(1)*y(1); 
     insertedX(2) insertedY(2) 1 0 0 0 -insertedX(2)*x(2) -insertedY(2)*x(2);
     0 0 0 insertedX(2) insertedY(2) 1 -insertedX(2)*y(2) -insertedY(2)*y(2); 
     insertedX(3) insertedY(3) 1 0 0 0 -insertedX(3)*x(3) -insertedY(3)*x(3);
     0 0 0 insertedX(3) insertedY(3) 1 -insertedX(3)*y(3) -insertedY(3)*y(3); 
     insertedX(4) insertedY(4) 1 0 0 0 -insertedX(4)*x(4) -insertedY(4)*x(4);
     0 0 0 insertedX(4) insertedY(4) 1 -insertedX(4)*y(4) -insertedY(4)*y(4)];
hFlat = A\transpose(b); 
totalH = [hFlat(1:3)'; hFlat(4:6)'; hFlat(7:8)' 1];


image2Ref = imref2d(size(background));

totalHP = projective2d(totalH');

[tfImage tfImageRef] = imwarp(inserted,totalHP);
figure;
clf;
imshowpair(coveredSegment,image2Ref, tfImage, tfImageRef,'blend','Scaling','joint')


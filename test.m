imageOrig = imread('DanaHallWay2/DSC_0285.JPG');
imageGray = rgb2gray(imageOrig);
figure; 
Rs = harrisDetector(imageGray, 100, 100);
image('CData', imageOrig,'XData',[1 512], 'YData', [-1 -340])
for i = 1:size(Rs,1)
    for j = 1:size(Rs,2)
        if(Rs(i,j)>=150)
            hold on
            plot(j,-i,'o')
        end
    end
end
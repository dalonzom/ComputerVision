function [Rs] = harrisDetector(image, nonMaxThreshold, nonMaxRange)

% Calculate gradient masks
[Ix,Iy] = imgradientxy(image, 'prewitt');

% calculate gradient products
IxIx = Ix.*Ix;
IyIy = Iy.*Iy;
IxIy = Ix.*Iy;


% Sum in 3x3 window
filter = ones(3,3);
IxIx = imfilter(IxIx, filter, 'replicate');
IxIy = imfilter(IxIy, filter, 'replicate');
IyIy = imfilter(IyIy, filter, 'replicate');

% Compute C matrix and R matrix
k = .04;
Rs = zeros(size(Ix));
for i = 1:size(Ix,1)
    for j = 1:size(Ix,2)
        C = [IxIx(i,j) IxIy(i,j); IxIy(i,j) IyIy(i,j)];
        eigs = eig(double(C));
        R = eigs(1)*eigs(2) - (k * (eigs(1) + eigs(2))^2);
        Rs(i,j) = R;
    end
end

%% Nonmax suppression
% Calculate magnitude and direction of gradient
[Imag, Idir] = imgradient(image, 'prewitt');
directions = [-180, -135, -90, -45, 0, 45, 90, 135, 180];
for i = 1:size(Rs,1)
    for j = 1:size(Rs,2)
        % Find closest direction in magnitude of gradient
        [diff, index] = min(abs(Rs(i,j) - directions));
        direction = directions(index);
        for k = 1:nonMaxRange
            switch direction
                case -180
                    if i-k > 0 && (Rs(i-k,j) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case -135
                    if i-k > 0 && j-k > 0 && (Rs(i-k, j-k) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case -90
                    if j-k > 0 && (Rs(i, j-k) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case -45
                    if i+k <= size(Rs,1) && j-k > 0 && (Rs(i+k, j-k) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case 0
                    if  i+k <= size(Rs,1) && (Rs(i+k, j) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case 45
                    if  i+k <= size(Rs,1) &&  j+k <= size(Rs,2) && (Rs(i+k, j+k) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case 90
                    if  j+k <= size(Rs,2) && (Rs(i, j+k) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case 135
                    if i+k <= size(Rs,1) &&  j+k <= size(Rs,2) && (Rs(i+k, j+k) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
                case 180
                    if i-k > 0 && (Rs(i-k, j) > Rs(i,j))
                        Rs(i,j) = 0;
                        break
                    end
            end
        end
    end
    
end

for i = 1:size(Rs,1)
    for j = 1:size(Rs,2)
        if Rs(i,j) ~= 0 
            Rs(i,j) = Imag(i,j); 
        end
        if Rs(i,j)  < nonMaxThreshold
            Rs(i,j) = 0;
        end
    end
end
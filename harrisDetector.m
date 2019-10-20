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

% X = reshape(1:20,5,4)'
% C = mat2cell(X, [2 2], [3 2])
% celldisp(C) 
[Imag, Idir] = imgradient(image, 'prewitt');
Imagcells = mat2cell(Imag, [85 85 85 85], [128 128 128 128]);
cells = mat2cell(Rs, [85 85 85 85], [128 128 128 128]); 
for i = 1:4
    for j = 1:4
        vec = reshape(cells{i,j},1,[]); 
        [~, index] = sort(vec, 'descend'); 
        vec = zeros(85, 128); 
        vec(index(1:50)) = Imagcells{i,j}(index(1:50));
         for k = 50:-1:1
            if min(abs(index(1:k-1) - index(k))) < 10  
                vec(index(k)) = 0; 
            end 
         end 
        cells{i,j} = vec; 
    end 
end 
Rs = cell2mat(cells); 
%Calculate magnitude and direction of gradient
% [Imag, Idir] = imgradient(image, 'prewitt');
% directions = [-180, -135, -90, -45, 0, 45, 90, 135, 180];
% for i = 1:size(Rs,1)
%     for j = 1:size(Rs,2)
%         % Find closest direction in magnitude of gradient
%         [diff, index] = min(abs(Rs(i,j) - directions));
%         direction = directions(index);
%         for k = 1:nonMaxRange
%             switch direction
%                 case -180
%                     if i-k > 0 && (Rs(i-k,j) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case -135
%                     if i-k > 0 && j-k > 0 && (Rs(i-k, j-k) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case -90
%                     if j-k > 0 && (Rs(i, j-k) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case -45
%                     if i+k <= size(Rs,1) && j-k > 0 && (Rs(i+k, j-k) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case 0
%                     if  i+k <= size(Rs,1) && (Rs(i+k, j) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case 45
%                     if  i+k <= size(Rs,1) &&  j+k <= size(Rs,2) && (Rs(i+k, j+k) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case 90
%                     if  j+k <= size(Rs,2) && (Rs(i, j+k) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case 135
%                     if i+k <= size(Rs,1) &&  j+k <= size(Rs,2) && (Rs(i+k, j+k) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%                 case 180
%                     if i-k > 0 && (Rs(i-k, j) > Rs(i,j))
%                         Rs(i,j) = 0;
%                         break
%                     end
%             end
%         end
%     end
%     
% end
% 
% for i = 1:size(Rs,1)
%     for j = 1:size(Rs,2)
%         if Rs(i,j) ~= 0 
%             Rs(i,j) = Imag(i,j); 
%         end
%         if Rs(i,j)  < nonMaxThreshold
%             Rs(i,j) = 0;
%         end
%     end
% end
clc
clear
close all

% Image Reader (all formats)
path_dcm = '2.dcm';
path_not_dcm = '2.jpg';

g = UniversalImReader(path_dcm);
f = UniversalImReader(path_not_dcm,'double',false);

figure();
subplot(121);imshow(g);
subplot(122);imshow(f);

%%
x = 1:5;
y = 2:4;
[X Y] = meshgrid(x,y);

%%

clc
clear
% 1) Read and display your image
I = imread('cameraman.tif');
I = im2double(I);
[rows, cols] = size(I);
figure; imshow(I); title('Original Image'); hold on

% 2) Build coordinate grid
[x, y] = meshgrid(1:cols, 1:rows);

% 3) Define circle center & radius
cx = 100;   % column index of center
cy = 80;    % row index of center
r  = 50;    % radius in pixels

% 4) Create logical mask for pixels inside the circle/square
% mask = (x - cx).^2 + (y - cy).^2 <= r.^2; % Circle
mask = (abs(x - cx) <= r) & (abs(y - cy) <= r); % Square
% 5) Overlay the boundary of the mask
%    Requires Image Processing Toolbox
visboundaries(mask, 'Color', 'r', 'LineWidth', 0.2);

% (If you don’t have visboundaries, you can do:)
% [B,~] = bwboundaries(mask);
% plot(B{1}(:,2), B{1}(:,1), 'r', 'LineWidth', 1.5);



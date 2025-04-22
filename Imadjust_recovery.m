clc
clear

p = '2.jpg';
f = UniversalImReader(p,'double');

% --> J = imadjust(I, [low_in high_in], [low_out high_out], gamma);
a=0.2;
b=0.8;
c=0.4;
d=0.6;
gamma = 1;

g = imadjust(f, [a b], [c d], gamma);

% Imadjust:
g = ((f - a) / (b - a)).^gamma;
g = g .* (d - c) + c;

f_recovered = ((g - c) / (d - c)).^(1/gamma);
f_recovered = f_recovered .* (b - a) + a;

disp('-----------------------------------------------');
f_n_pixels_min = nnz(f == min(f(:)));
fprintf('f --> Number of pixels with minimum value: %d\n', f_n_pixels_min);
g_n_pixels_min = nnz(g == min(g(:)));
fprintf('g --> Number of pixels with minimum value: %d\n', g_n_pixels_min);
f_recovered_n_pixels_min = nnz(f_recovered == min(f_recovered(:)));
fprintf('f_recovered --> Number of pixels with minimum value: %d\n', f_recovered_n_pixels_min);
disp('-----------------------------------------------');
f_n_pixels_max = nnz(f == max(f(:)));
fprintf('f --> Number of pixels with maximum value: %d\n', f_n_pixels_max);
g_n_pixels_max = nnz(g == max(g(:)));
fprintf('g --> Number of pixels with maximum value: %d\n', g_n_pixels_max);
f_recovered_n_pixels_max = nnz(f_recovered == max(f_recovered(:)));
fprintf('f_recovered --> Number of pixels with maximum value: %d\n', f_recovered_n_pixels_max);
disp('-----------------------------------------------');

figure(1); 
subplot(231); imshow(f); title('original image')
subplot(232); imshow(g); title('image imadjust');
subplot(233); imshow(f_recovered); title('image recovered');
subplot(234); imhist(f); title('original image')
subplot(235); imhist(g); title('image imadjust');
subplot(236); imhist(f_recovered); title('image recovered');

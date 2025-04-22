clc
clear

I = double([0 2.5; 3.25 -4]);
disp(I)

I_uint8 = uint8(I);
disp(I_uint8)

I_imuint8 = im2uint8(I);
disp(I_imuint8)

I_imint16 = im2int16(I);
disp(I_imint16);

I_mat2gray_imuint8 = im2uint8(mat2gray(I));
disp(I_mat2gray_imuint8);


im2double(mat2gray())

im2uint8(mat2gray(I))










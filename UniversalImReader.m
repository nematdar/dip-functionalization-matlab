function f = UniversalImReader(path,class,convert_to_gray)

% function help --------------------------------------
% inputs:
	% path: image path (example: 'image.dcm' or 'image.png',input: str)
	% convert_to_gray(Optional,boolean,default=true, input: true or false):
		% True if the user wants to convert  image 
		% into one channel gray image.
	% class(Optional, default='uint8', input: 'uint8' or 'double'):
		% Convert image from any given format into 'uint8' or 'double'.
% ------------------------------------------------------

% Step 1
% See how many inputs user entered
% nargin --> number of inputs
if nargin == 2
	convert_to_gray = true;
elseif nargin == 1
	convert_to_gray = true;
	class = 'uint8';
end

% Step 2
% Import image from path
if endsWith(path,'.dcm')
	f = dicomread(path);
else
	f = imread(path);
end

% Step 3
% change image class (or datatype)
if strcmp(class,'double')
	f = im2double(mat2gray(f));
else
	f = im2uint8(mat2gray(f));
end

% Step 4
% Convert to gray (Optional)
if convert_to_gray
	if size(f,3) == 3
		f = rgb2gray(f);
	end
end

end

% --------------------
% Example in program:
% clc; clear
% path = 'image.png';class = 'double';convert_to_gray = false
% f = UniversalImReader(path)
% figure(1);imshow(f)
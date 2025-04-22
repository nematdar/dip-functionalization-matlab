function g = ChessBoard(m)

blockb = zeros(m/8,'uint8');
blockw = ones(m/8,'uint8')*255;
g = repmat([blockb blockw;blockw blockb],4);

% Using Imresize:
% g = uint8(imresize(repmat([blockb blockw;blockw block],4),m/8,"nearest"));

end

% --------------------
% Example:
% clc; clear
% m=256;
% g = ChessBoard(m);
% figure(1);imshow(g);
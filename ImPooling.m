function g = ImPooling(path,M,S,T)

% m_out = floor((M - K + 2P)/S) + 1
f = UniversalImReader(path,'double',true);

[rows,cols] = size(f);

% 1. Pooling Function: mean - max - min
pool_func =@(x) mean(x(:));
if T > 0 
    pool_func =@(x) max(x(:));
elseif T < 0 
    pool_func =@(x) min(x(:));
end

% 2. See if the kernel is even or odd
even_flag = 0;
if mod(M,2) == 0
    even_flag = 1;
end
% 3. Padding for Odd Kernels
switch even_flag
    case 0
        % number if pads needed in the left and the top of the image
        % matrix:
        pre_pads = floor(M/2);
        
        % a_n = a_0 +(n-1)*d
        % d ~ s, a_n ~ rows | cols, a_0 = 1
        % a_0 +(n-1)*d <= a_n
        % post_pad = floor((( rows - 1 )/s) + 1 )
        
        % `n` is the number of `s` steps that we need to go through to reach the
        % last pixel in the image that fits on the center of our odd kernel
        % After finding n, we can calculate the last center of our kernel
        % which fells inside the image matrix (`last_pixel_row` or `last_pixel_col`). then, 
        %  is we have `rows` as the maximum index of image, we need to
        %  find its distance to the nearest index of the kernel. 
        % e.g. size(image) = 19X19 __ poolsize = 7 __ strides = 7. we want
        % to find the number of the right padarrays:
%              ___ ___ ___ ___ ___ ___ ___ ___ ___ ____ ____ ____ ____ ____ ____ ____ ____ ____ ____
% Pixel Index:| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 |
% k centers:    /\                         /\                                /\                | /!\|
        %                                                                            COLS = 18 so we need to
        %                                                                            know how many zeros we
        %                                                                            should insert after the
        %                                                                            pixel with index=18 in
        %                                                                            case of not using the
        %                                                                            18th index data!

        % nearest pooling index inside the kernel: floor(poolsize/2) + 15 = 18
        % 
        % --> 19 - 18 = 1 --> poolsize - 1 = 7 - 1 = 6 --> 6 zero padding
        % after 18 is needed
        %                                                       
        n_row = floor((( rows - 1 )/S) + 1 );
        n_col = floor((( cols - 1 )/S) + 1 );
        last_central_pixel_row = 1 + (n_row - 1)*S;
        last_central_pixel_col = 1 + (n_col - 1)*S;
        last_pixel_in_last_kernel_in_row = last_central_pixel_row + floor(M/2);
        last_pixel_in_last_kernel_in_col = last_central_pixel_col + floor(M/2);
        
        % ----- debug ------
        disp('last_pixel_in_last_kernel_in_row');
        disp(last_pixel_in_last_kernel_in_row);
        disp('last_pixel_in_last_kernel_in_col')
        disp(last_pixel_in_last_kernel_in_col)
        % ----- ----- ------
        
        distance_till_rows = rows - last_pixel_in_last_kernel_in_row;
        distance_till_cols = cols - last_pixel_in_last_kernel_in_col;

        % ----- debug ------
        disp('distance_till_rows');
        disp(distance_till_rows);
        disp('distance_till_cols')
        disp(distance_till_cols)
        % ----- ----- ------

        if distance_till_rows == 0
            disp('distance_till_rows == 0')
            post_pad_down = 0;
        elseif distance_till_rows > 0 
            disp('distance_till_rows > 0')
            post_pad_down = M - distance_till_rows;
        elseif distance_till_rows < 0 
            disp('distance_till_rows < 0 ')
            post_pad_down = abs(distance_till_rows);
        end
        if distance_till_cols == 0
            disp('distance_till_cols == 0')
            post_pad_right = 0;
        elseif distance_till_cols > 0 
            disp('distance_till_cols > 0 ')
            post_pad_right = M - distance_till_cols;
        elseif distance_till_cols < 0 
            disp('distance_till_cols < 0 ')
            post_pad_right = abs(distance_till_cols);
        end
        
        

        % padding in each side should be less than the kernel or pooling
        % size, or there's no need for padding.
        % if post_pad_right == M
        %     post_pad_right = 1;
        % end
        % if post_pad_down == M
        %     post_pad_down = 1;
        % end

        g = padarray(f, [pre_pads pre_pads], 0, 'pre');
        g = padarray(g, [post_pad_down post_pad_right], 0, 'post');
        [g_rows, g_cols] = size(g);

        % ----- debug ------
        disp('pre_pads');
        disp(pre_pads);
        disp('post_pad_right')
        disp(post_pad_right)
        disp('post_pad_down')
        disp(post_pad_down)
        disp('round(post_pad_down/M)')
        disp(round(post_pad_down/M))
        disp('round(post_pad_right/M)')
        disp(round(post_pad_right/M))
        % ----- ----- ------

        % initializing the final pooling matrix with zeroes
        g_pooled = zeros(n_row + round(post_pad_down/M),n_col + round(post_pad_right/M));
        % ----- debug ------
        disp('n_row');
        disp(n_row);
        disp('n_col');
        disp(n_col);
        disp('size g');
        disp(size(g));
        % ----- ----- ------
        g_pooled_r_idx = 0;
        for center_r = ( 1 + pre_pads ):S:g_rows
            g_pooled_r_idx = g_pooled_r_idx + 1;
            g_pooled_c_idx = 1;
            for center_c = ( 1 + pre_pads ):S:g_cols
                %
                % from top_left_edge_idx     to    right_edge_idx
                %                  -> ____________________  <-
                %                    |__|__|__|__|__|__|__|
                %                    |__|__|__|__|__|__|__|
                %                    |__|__|__|__|__|__|__|
                %                    |__|__|__|__|__|__|__|
                %                    |__|__|__|__|__|__|__|
                %                  ->                       <-
                % from bottom_left_edge_idx   to    bottom_right_edge_idx
                left_row_idx = center_r - pre_pads;
                left_col_idx = center_c - pre_pads;
                right_row_idx = center_r + pre_pads;
                right_col_idx = center_c + pre_pads;

                pooling_width = left_row_idx:right_row_idx;
                pooling_height = left_col_idx:right_col_idx;
                %  ----- debug ------
                % disp('center_r:');
                % disp(center_r);
                % disp('center_c');
                % disp(center_c);
                % disp('right_col_idx')
                % disp(right_col_idx)
                % disp('right_row_idx')
                % disp(right_row_idx)
                % ----- ----- ------
                pooling_kernel = g(pooling_width,pooling_height);
                g_pooled(g_pooled_r_idx,g_pooled_c_idx) = pool_func(pooling_kernel);

                g_pooled_c_idx = g_pooled_c_idx + 1;
                % ----- debug ------
                % disp('g_pooled_r_idx:');
                % disp(g_pooled_r_idx);
                % disp('g_pooled_c_idx');
                % disp(g_pooled_c_idx);
                % ----- ----- ------

            end
            
        end
        g = im2uint8(mat2gray(g_pooled));
    % 3. Padding for Even Kernels
    case 1

        n_row = floor((( rows - 1 )/S) + 1 );
        n_col = floor((( cols - 1 )/S) + 1 );
        last_pixel_row = 1 + (n_row - 1)*S;
        last_pixel_col = 1 + (n_col - 1)*S;
        last_pixel_in_last_kernel_in_row = last_pixel_row + M - 1;
        last_pixel_in_last_kernel_in_col = last_pixel_col + M - 1;
        distance_till_rows = rows - last_pixel_in_last_kernel_in_row;
        distance_till_cols = cols - last_pixel_in_last_kernel_in_col; 
        
        post_pad_right = M - distance_till_rows;
        post_pad_down = M - distance_till_cols;
        % padding in each side should be less than the kernel or pooling
        % size, or there's no need for padding.
        if post_pad_right >= M
            post_pad_right = 0;
        end
        if post_pad_down >= M
            post_pad_down = 0;
        end

        g = padarray(f, [post_pad_right post_pad_down], 0, 'post');
        [g_rows, g_cols] = size(g);
        
        % initializing the final pooling matrix with zeroes
        g_pooled = zeros(n_row,n_col);
        g_pooled_r_indx = 1;
        for g_row = 1:S:g_rows
            g_pooled_c_idx = 1;
            for g_col =1:S:g_cols
                left_row_idx = g_row;
                left_col_idx = g_col;
                right_row_idx = g_row + M - 1;
                right_col_idx = g_col + M - 1;

                pooling_width = left_row_idx:right_row_idx;
                pooling_height = left_col_idx:right_col_idx;

                pooling_kernel = g(pooling_width,pooling_height);
                g_pooled(g_pooled_r_indx:g_pooled_c_idx) = pool_func(pooling_kernel);

                g_pooled_c_idx = g_pooled_c_idx + 1;
            end
            g_pooled_r_idx = g_pooled_r_idx + 1;
        end
        g = im2uint8(mat2gray(g_pooled));
end
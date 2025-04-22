# dip-functionalization-matlab

 *Useful MATLAB Functions for Digital Image Processing*

**Digital Image Processing with MATLAB: A Quick Review** 

-------------------------------------
-------------------------------------
## Basic intensity transformations

### 1. Linear Equation

`s = a . r + b`

-  a = contrast,  b = brightness
-  For b > 0 brighter image
-  For b < 0 darker image
-  For |a| > 1 higher contrast
-  For |a| < 1 lower contrast
-  e.g. s = 2r
-  Pixels values between 0 to L/a are mapped to 0 to L-1
-  all pixel values greater than 
-  L/2, will be equal to L-1 (max value e.g. 255) (higher contrast)
- -------------------------------------------------------
### 2. Negative image

`s = -r + 255`
- For |a| > 1 higher contrast
- For |a| < 1 lower contrast
- -------------------------------------------------------
### 3. Power Equation

`S = C . r^(gamma)`
```markdown
- if gamma < 1:
     • Higher contrast for low pixel values
     • Lower contrast for high pixel values
     • mapping is weighted toward higher output (brighter image)
     • e.g. s = 48 . r ^ (0.3) ----> brighter output

- elseif gamma > 1:
    • Higher contrast for high pixel values
    • Lower contrast for low pixel values
    • mapping is weighted toward lower output (darker image) 
    • e.g. s = 0.0004 . r ^ (2) ----> darker output
```
- -------------------------------------------------------
### 4. Log Equation

`s = c . log2 ( r + 1 )`  ---> greater c ~~~ higher max (brighter image)
- -------------------------------------------------------
### 5. Thresholding Equation


`s = 1 / ( 1 + (m/r)^E )` ---> HIGH PASS EQUATION

- A simple tool used for image segmentation.
- The "threshold" is {m} and {E} controls the "slope" of the function.
- 
```markdown 
% High-pass:
    % • low intensities are removed
    % • High intensities are highlighted
 % if E = 15, betweem 90, 150, 190 -----> m=190 has higher contrast and
 % shows more details
```

```markdown
`s = 1 / ( 1 + (r/m)^E )` ---> LOW PASS EQUATION

- • High intensities are removed
- • Low intensities are highlighted
```
- -------------------------------------------------------

### 6. Histogram Equation

- `h(r_k) = n_k`

- imadjust used for Hist method
- `g1 = im2uint8(mat2gray((1./(1+(m./f).^E1))));`
- histogram equalization 

```matlab
f=imread(‘pelvis.tif’);
g=histeq(f);     % ---> Histogram equalization MATALB command
figure, imshow(g);
figure, imhist(g);
```
### 7. Sacling

$$
\text{scaledImage} = (\text{imgPixelValue} - \text{oldMin}) \times \left( \frac{\text{newMax} - \text{newMin}}{\text{oldMax} - \text{oldMin}} \right)
$$

---------------------------------------
---------------------------------------
## Some useful MATLAB functions (1):

```matlab
% Example input image
I = double([0 0.5; 1.0 1.25]);

% Convert to different formats
J1 = im2uint8(I);            % 8-bit unsigned integer
J2 = im2uint16(I);           % 16-bit unsigned integer
J3 = im2int16(I);            % 16-bit signed integer
J4 = im2single(I);           % Single precision floating-point
J5 = im2double(I);           % Double precision floating-point
J6 = mat2gray(I);            % Normalized grayscale [0, 1]
J7 = im2uint8(mat2gray(I));  % Normalized grayscale to 8-bit

% Display results
disp('Original Image:');
disp(I);
disp('im2uint8:');
disp(J1);
disp('im2uint16:');
disp(J2);
disp('im2int16:');
disp(J3);
disp('im2single:');
disp(J4);
disp('im2double:');
disp(J5);
disp('mat2gray:');
disp(J6);
disp('im2uint8(mat2gray):');
disp(J7);
```

| Function                   | DICOM Images                           | Other Images                                         |
|---------------------------|----------------------------------------|------------------------------------------------------|
| `im2uint8(I)`             | Not recommended                        | Good for normalized or low-dynamic-range data        |
| `im2uint16(I)`            | Recommended                            | Good for high-dynamic-range data                     |
| `im2int16(I)`             | Rarely needed                          | Use if signed data representation is required        |
| `im2single(I)`            | Good for computations                  | Good for computations                                |
| `im2double(I)`            | Good for precision-sensitive tasks     | Overkill unless high precision is needed             |
| `mat2gray(I)`             | Useful for visualization               | Useful for visualization                             |
| `im2uint8(mat2gray(I))`   | Good for visualization                              | Useful for saving/visualization in 8-bit             |

- --------------------------------------------------------------------------------------------------------------

### imadjust function: for Linear and gamma correction

`J = imadjust(I,[low-in high-in],[low-out high-out],gamma);`

- [low_in high_in]
- The portion of your input intensity range that you care about.
- Any pixel in I with value ≤ low_in will be mapped to the lowest output level.
- Any pixel ≥ high_in will go to the highest output level.
- Everything in between is remapped (see formula below).

- [low_out high_out]
- The target range in the output image J.
- Pixels that fell below or at low_in become low_out.
- Pixels at or above high_in become high_out.
- In–between values are interpolated (and optionally gamma‐corrected).

```markdown
% gamma < 1 -----> “brightens” mid‐tones (concave).
% gamma = 1 -----> straight linear mapping.
% gamma > 1 -----> "darkens” mid‐tones (convex).
```

```markdown
`y = ((x – low_in) / (high_in – low_in))^gamma;`   % stretch & gamma‐correction
`y = y * (high_out – low_out) + low_out;`          % scale & shift
`y is clipped to [0,1]`
```

```markdown
- NOTE for imadjust:
- The output image will be scaled 
- between 0-1
- So, it should be scaled to 0-255 again by:
- g=im2uint8(f)

-  f1=imadjust(f, stretchlim(f), [], 1); % [] --> default [0 1],
-  stretchlim(f) --> automatically finds the best Min and Max
-  the default limits [0.01 0.99], saturating the upper 1% and the lower 1%.
-  [0.02 0.97] --> saturate the upper 3% and the lower 2%.
-  g=im2uint8(f1);
```
- -------------------------------------------------------

### imcomplement function: Making negative

`output = imcomplement(input);`

```matlab
d=dicomread('1-200.dcm');
f=im2uint8(mat2gray(d));
g=imcomplement(f);
```


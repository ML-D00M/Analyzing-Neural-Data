%% 1. Create a 5x6 matrix A of randomly generated numbers. 
%% Loop through all row and columns and test whether each element 
%% is greater than 0.4

A = rand(5,6);
n = 0;

for i=1:5
    for j=1:6
        if A(i,j)>0.4
            n = n+1;
        end
    end % end j-loop
end % end i-loop

fprintf('The number of elements greater than 0.4 is %i \n', n);

%% Report the result of the test in a 5x6 matrix A_bin 
%% with values 1 if >0.5 and 0 if <0.5

A_bin = A > 0.5

%% Write the function matrix_gt_05.m with A_bin(0 or 1) 
%% and input the matrix A

A_bin = matrix_gt_05(A)

%% Import the picture of Moscow that comes with the Matlab code and 
%% find the maximum value of each color (R,G,B) and 
%% plot a star of that color on the pixel with maximum value 
%% (if more than one maximum, the first pixel from top left)

M = imread('Moscow.bmp');
whos Moscow

s=size(M);
Red = M(:,:,1);
Green = M(:,:,2);
Blue = M(:,:,3);

imshow(M);
hold on;

Red_max = max(Red(:));
[rowsR colsR] = find(Red == Red_max);
plot(colsR(1),rowsR(1), '*', 'LineWidth', 2, 'MarkerSize', 50,'color', 'r');
hold on;

Green_max = max(Green(:));
[rowsG colsG] = find(Green == Green_max);
plot(colsG(1), rowsG(1),  '*', 'LineWidth', 2, 'MarkerSize', 50,'color', 'g');
hold on;

Blue_max = max(Blue(:));
[rowsB colsB] = find(Blue == Blue_max);
plot(colsB(1), rowsB(1),  '*', 'LineWidth',2, 'MarkerSize', 50, 'color', 'b');
hold on;

%% Generate a random 32 x 3 matrix B. Use the function of exercise 3 
%% to generate another 32x3 matrix B_bin(0 or 1 if < or > 0.5) 
%% Write matrix B and B_bin to sheet ‘B’ and ‘B_bin’ of an excel file

B = rand(32,3);
B_bin = B > 0.5;

xlswrite('Matlab data.xlsx',B, 'B');
xlswrite('Matlab data.xlsx',B_bin, 'B_bin');
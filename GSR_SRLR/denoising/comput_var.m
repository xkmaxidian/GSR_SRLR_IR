clear; clc;
% filepath = ['Set12/', '01', '.tiff'];
% filepath = 'C:\Users\HP\Pictures\Saved Pictures\捕获3.png';
I = imread(filepath);
[h, w, ch] = size(I);
if ch == 3
    I = rgb2gray(I);
end
I = double(I);
var1 = (std2(I));
I = I + 30*randn(h, w);
var2 = (std2(I));
var1
var2
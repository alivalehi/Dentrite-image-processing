clear all
RGB = imread('original/1.png');
figure;
imshow(RGB);
title('Original indexed image');
%pause;
I = rgb2gray(RGB);
figure;
imshow(I)
bw = im2bw(I,0.35);
figure;
imshow(bw)
out = bwareaopen(bw, 700);
figure;
imshow(out);
skleton = bwmorph(out,'skel',inf);
figure;
imshow(skleton);
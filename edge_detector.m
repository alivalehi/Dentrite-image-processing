
RGB = imread('original/2.png');
I = rgb2gray(RGB);
Edge = edge(I,'Canny');
imshow(Edge)
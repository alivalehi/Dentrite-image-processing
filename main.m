%%%%% main file load dictionar

clear all
load('Dictionary.mat');
RGB = imread('original/5.png');
RGB = imnoise(RGB,'gaussian',0,0.02)
I = rgb2gray(RGB);
%     figure;
%     imshow(I)
bw = im2bw(I,0.35);
%     figure;
%     imshow(bw)
[w,h] = size(bw);
s = regionprops(bw,'centroid');
s_length = length(s);
for o = 1:s_length
    center_distance(o) =  norm(s(o).Centroid - [w/2 h/2]);
end
P = find(center_distance==min(center_distance));
X = s(P).Centroid(1,1);
Y = s(P).Centroid(1,2);
scaled = imcrop(bw,[X-50 Y-50 99 99]);
out = bwareaopen(scaled, 700);
%     figure;
%     imshow(out);
skleton = bwmorph(out,'skel',inf);
%      figure;
%      imshow(skleton);
tiles = mat2cell(scaled,5*ones(1,20),5*ones(1,20));
[m,n] = size(tiles)
indicator = zeros(n,m);
for i=1: m
    for j=1:n
        tiles_numric = cell2mat(tiles(i,j));
        if(any(tiles_numric(1,:)));
            indicator(i,j) = indicator(i,j)+8;
        end
        if(any(tiles_numric(:,end)));
            indicator(i,j) = indicator(i,j)+4;
        end
        if(any(tiles_numric(end,:)));
            indicator(i,j) = indicator(i,j)+2;
        end
        if(any(tiles_numric(:,1)));
            indicator(i,j) = indicator(i,j)+1;
        end
    end
end

B = reshape(indicator,n*m,1);
[w_A,h_A] = size(A);
for l=1:h_A
    D(l) =  norm(A(:,l) - B);
end
fprintf('Matched image is image number:%d \n',(find(D==min(D))));
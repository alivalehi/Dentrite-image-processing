function new_result=graph_based(image_file,noise_flag)
clear functions
%image_file ='original/ROC/b5.png';
RGB = imread(image_file);
%RGB = imnoise(RGB,'gaussian',0,0.0025);
if(size(RGB,3)==3)
I = rgb2gray(RGB);
if(nargin>1)
    if(noise_flag==1 )
        I = wiener2(I,[5 5]);
    end
end
bw = im2bw(I,0.35);
else
    bw= RGB;
    
end
[w,h] = size(bw);
s = regionprops(bw,'centroid');
s_length = length(s);
% for o = 1:s_length
%     center_distance(o) =  norm(s(o).Centroid - [w/2 h/2]);
% end
out = bwareaopen(bw, 700);
skleton = bwmorph(out,'skel',inf);
if(size(RGB,3)==3)
circle = find_circles(image_file);
else
    Image_w = 926;
Image_h = 926;
centers(1,1) = Image_w/2;
centers(1,2) = Image_h/2;
circle.centers = centers;
circle.radii  = 30;
end
%%% remove circle in center and find tree initial point
radius = floor((circle.radii));
centery= round(circle.centers(1,1));
centerx= round(circle.centers(1,2));
downboundx = centerx-radius;
upboundx = centerx+radius;
downboundy = centery-radius;
upboundy = centery+radius;
initial_image = skleton;
[xgrid, ygrid] = meshgrid(1:size(initial_image,2), 1:size(initial_image,1));
mask = sqrt((xgrid-centery).^2 + (ygrid-centerx).^2) <= radius+1;
mask = (mask-1)*(-1);
initial_image = mask.*initial_image;
%finding initial points

%  figure;
%  imshow(skleton);
%  figure;
% imshow(initial_image);
mask1 = sqrt((xgrid-centery).^2 + (ygrid-centerx).^2) <= radius+2;
initial_image1 = mask1.*initial_image;
%frame = initial_image(x1,y1);
[x,y] = find(initial_image1==1);
%frame_center = ceil(length(frame)/2);
for k =1 :length(x)
    initialpoint(k).x =  (x(k,1));
    initialpoint(k).y =  (y(k,1));
end
parent.x= centerx;
parent.y = centery;
parent.level = 0;
result=node_search(initialpoint,initial_image,parent);
% hold all;
% plot(result(:,2),result(:,1),'.','MarkerSize',20);
%%% prepare desired graph
[a,b] = size(result);
nodes_cordinates = [result(:,1) result(:,2)];
new_result =[];
for l =1 : a
    %node(Rx,Ry,angle,type ,level,parentxy,x,y)
    new_result(l,:) = [result(l,1)-result(l,5) result(l,2)-result(l,6)  acot((result(l,1)-centerx)/(result(l,2)-centery)) result(l,3) result(l,4) result(l,5) result(l,6) result(l,1) result(l,2) radius];
end
length_level = max(new_result(:,5));
new_result =[new_result,zeros(a,1)];
for z=1:length_level
    [samelevely,samelevelx] =  (find(new_result(:,5)==z));
    [h,w] = size(new_result(find(new_result(:,5)==z)));
    Id = [1:h].';
    for ww=1:h
        new_result(samelevely(ww),10) = Id(ww);
    end
end
new_result = prune(new_result);
%     hold all;
%  plot(new_result(:,9),new_result(:,8),'.','MarkerSize',20);
%  samelevel_test   = new_result(find(new_result(:,5)==1),:);
% plot(samelevel_test(:,9),samelevel_test(:,8),'.','MarkerSize',20);
%%%
end
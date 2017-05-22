function circle = find_circles(inputimage)
%inputimage = 'original/b3.png';
sensivity = .85;
 detection_flag = 0;
 accradii = [];
 acccenter = [];
 time_out = 0;
% InfoImage = imfinfo(input);
% Width = InfoImage.Width;
% Height = InfoImage.Height;
% Radius_Range = [50 max(Width,Height)];
RGB = imread(inputimage);
%imshow(RGB);
% text ='lower:';
% x = input(text);
% text = 'upper:';
% y = input(text);
% Radius_Range1 = [x y];
Radius_Range1 = [1 40];

J = rgb2gray(RGB);
[w,h] = size(J);
%Edge detection Added
edged =single(edge(J,'Canny'));
edged = -1 * (edged-1);
I = imadjust(edged);
%[centers, radii] = imfindcircles(I,Radius_Range,'Sensitivity',.98);
while(~detection_flag)
    [centers, radii] = imfindcircles(I,Radius_Range1,'Sensitivity',sensivity,'Method','TwoStage');
   %[q,p] = size (centers);
  
%     if(isempty(acccenter))
%            centers = [] ;
%            radii = [] ;
%     end
%     centers = acccenter ;
%     radii = accradii ;
    if(length(radii)==1)
       
        radius = floor((radii(1)));
        centery= round(centers(1,1));
        centerx= round(centers(1,2));
        downboundx = centerx-radius;
        upboundx = centerx+radius;
        downboundy = centery-radius;
        upboundy = centery+radius;
        if(~(upboundx<(3*w/4) && downboundx>=(w/4) && downboundy >=(h/4) && upboundy<(3*h/4)))
            sensivity = sensivity + 0.001; 
            time_out = time_out + 1;
        else
            detection_flag = 1;
            x = centers(1,1);
            y = centers(1,2);
            time_out = 0;
        end 
        if(time_out>100)
            msg = 'Time out.';
            error(msg)
        end   
    
    
elseif(length(radii)>1)   
        if(time_out>3)
         [q,p] = size (centers);
    for n=1:q
        radius = floor((radii(n)));
        centery= round(centers(n,1));
        centerx= round(centers(n,2));
        downboundx = centerx-radius;
        upboundx = centerx+radius;
        downboundy = centery-radius;
        upboundy = centery+radius;
         if(upboundx<(3*w/4) && downboundx>=(w/4) && downboundy>=(h/4) && upboundy<(3*h/4))
        centers = centers(n,:);
        radii         = radii(n);
         detection_flag = 1;
            x = centers(1,1);
            y = centers(1,2);
        end   
    end 
    
%     if(isempty(acccenter))
%            centers = [] ;
%            radii = [] ;
%     end
%     centers = acccenter ;
%     radii = accradii ;
%      accradii = [];
%      acccenter = [];
    end
        sensivity = sensivity - 0.001;    
    elseif(length(radii)<1)   
        sensivity = sensivity + 0.001;     
    end   

    if(sensivity==0 || sensivity==1)
        msg = 'Error occurred.';
error(msg)
    end
end
sensivity
circle.centers = centers;
circle.radii  = radii;
% detection_flag = 0;
% I = imadjust(J);
% while(~detection_flag)
%     [centers1, radii1] = imfindcircles(I,Radius_Range1,'Sensitivity',sensivity,'Method','TwoStage');
%     if(length(radii1)==1)
%         detection_flag = 1;
%         x1 = centers1(1,1);
%         y1 = centers1(1,2);
%     elseif(length(radii1)>1)   
%         sensivity = sensivity - 0.01;    
%     elseif(length(radii1)<1)   
%         sensivity = sensivity - 0.01;     
%     end    
% end
   
% if (~(((w/4)<x) && ((w/4)<x) && ((h/4)<y) && ((h/4)<y)) && ~(((w/4)<x1) && ((w/4)<x1) && ((h/4)<y1) && ((h/4)<y1)) )
%     fprintf('too noisy image I can not detect anything1')
% elseif(~(((w/4)<x) && ((w/4)<x) && ((h/4)<y) && ((h/4)<y)))
%         x = x1;
%         y = y1;
% if(~(((w/4)<x1) && ((w/4)<x1) && ((h/4)<y1) && ((h/4)<y1) ))
%         x1 = x;
%         y1 = y; 
% end
% if((norm(x,x1)<5) && (norm(y,y1)<5))
% figure;
      imshow(I);
     hh = viscircles(centers,radii);
%     %h1 = viscircles(centers,radii);
% else
%     fprintf('too noisy image I can not detect anything')
% end    
end
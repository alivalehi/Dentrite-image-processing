filename ='Samples/btotal.jpg'
RGB = imread(filename);
imshow(filename)
rect = getrect
i=1;
filename = ['b' num2str(i) '.png'];
cropped_image = imcrop(RGB,rect);
imwrite(cropped_image,filename);
end_flag=0;
wspace = 328;
hspace = 326; 
while(~end_flag)

prompt = 'what should I do? ';
x = input(prompt,'s')
    if (x=='q')
    end_flag = 1;
    end
    if (x=='d')%move right
        rect = [rect(1)+(rect(4)+wspace) rect(2) rect(3) rect(4)];
        i = i+1;
        filename = ['b' num2str(i) '.png'];
        cropped_image = imcrop(RGB,rect);
        imshow(cropped_image);
        imwrite(cropped_image,filename);
    end
    if (x=='a')%move left
        rect = [rect(1)- (rect(4)+wspace) rect(2) rect(3) rect(4)];
        i = i-1;
        filename = ['b' num2str(i) '.png'];
        cropped_image = imcrop(RGB,rect);
        imshow(cropped_image);
        imwrite(cropped_image,filename);
    end
    if (x=='s') %move down
        rect = [rect(1) rect(2)+(rect(4)+hspace) rect(3) rect(4)];
        i = i+1;
        filename = ['b' num2str(i) '.png'];
        cropped_image = imcrop(RGB,rect);
        imshow(cropped_image);
        imwrite(cropped_image,filename);
    end
    if (x=='m') %move down
        prompt = 'What kind of modification? ';
        y = input(prompt,'s')
        if (y=='q')
        end_flag = 1;
        end
        if (y=='1')%move right
            prompt = 'how much add to wspace ';
            dw = input(prompt)
            rect = [rect(1)+(rect(4)+wspace+dw) rect(2) rect(3) rect(4)];
            filename = ['b' num2str(i) '.png'];
            cropped_image = imcrop(RGB,rect);
            imshow(cropped_image);
            imwrite(cropped_image,filename);
        end
        if (y=='2')%move left
            prompt = 'how much add to hspace ';
            dh = input(prompt)
            rect = [rect(1) rect(2)+(rect(4)+hspace+dh) rect(3) rect(4)];
            filename = ['b' num2str(i) '.png'];
            cropped_image = imcrop(RGB,rect);
            imshow(cropped_image);
            imwrite(cropped_image,filename);
        end
        if (y=='3') %move down
            prompt = 'how much increase frame w ';
            w = input(prompt)
            rect = [rect(1) rect(2) rect(3)+w rect(4)];
            filename = ['b' num2str(i) '.png'];
            cropped_image = imcrop(RGB,rect);
            imshow(cropped_image);
            imwrite(cropped_image,filename);
        end
         if (y=='4') %move down
            prompt = 'how much increase frame h ';
            h = input(prompt)
            rect = [rect(1) rect(2) rect(3) rect(4)+h];
            filename = ['b' num2str(i) '.png'];
            cropped_image = imcrop(RGB,rect);
            imshow(cropped_image);
            imwrite(cropped_image,filename);
         end
         if (y=='5') %move down
            prompt = 'how much add to initialx ';
            dx = input(prompt)
            rect = [rect(1)+dx rect(2) rect(3) rect(4)+h];
            filename = ['b' num2str(i) '.png'];
            cropped_image = imcrop(RGB,rect);
            imshow(cropped_image);
            imwrite(cropped_image,filename);
         end
           if (y=='6') %move down
            prompt = 'how much add to initialy ';
            dy = input(prompt)
            rect = [rect(1) rect(2)+dy rect(3) rect(4)];
            filename = ['b' num2str(i) '.png'];
            cropped_image = imcrop(RGB,rect);
            imshow(cropped_image);
            imwrite(cropped_image,filename);
        end
    end
end


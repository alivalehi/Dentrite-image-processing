if(1)
    clear all;
numberlist = [5,7,13,17,32,36,43,52,55];
  for k=numberlist
    pathstr = 'original'; 
    name = num2str(k);
    ext = 'png';
    input = strcat(pathstr,'/b',name,'.',ext);
    filename = input;
    %[pathstr,name,ext] = fileparts(filename); 
    RGB = imread(filename);
    param = 5;
    RGB = imnoise(RGB,'gaussian',0,(param/1e4));
    expname = strcat('gaus',num2str(param));
    export = strcat(pathstr,'/ROC/',expname,'-',name,'.',ext);
    imwrite(RGB,export);
  end 



end    
if(0)
%%skew%%
%   for k=1:9
%     pathstr = 'original'; 
%     name = k;
%     ext = 'png';
%     input = strcat(pathstr,'/',name,ext);
%     filename = input;
%     %[pathstr,name,ext] = fileparts(filename); 
%     RGB = imread(filename);
%     tform = affine2d([1 0 0; .5 1 0; 0 0 1]);
%     J = imwarp(RGB,tform);
%     export = strcat(pathstr,'/',name,'-','skewed0_5',ext);
%     imwrite(J,export);
%   end   
%%scale%%
  for k=1:9
    pathstr = 'original'; 
    name = num2str(k);
    ext = 'png';
    input = strcat(pathstr,'/b',name,'.',ext);
    filename = input;
    %[pathstr,name,ext] = fileparts(filename); 
    RGB = imread(filename);
    [h,w] = size(RGB);
    tform = affine2d([1 1.5 0; 0 1 0; 0 0 1]);
    J = imwarp(RGB,tform);
    J = imresize(J,[h,w]) ;
    export = strcat(pathstr,'/','skewy30','-',name,'.',ext);
    imwrite(J,export);
  end 
  end
function [ output_args ] = dendrite_generator( type )
%DENDRITE_GENERATOR Summary of this function goes here
%   Detailed explanation goes here
%%temp variables
clear all
for m=1:1e4
type = 1;
%
Image_w = 926;
Image_h = 926;
Radius = 30;
%%% Generating  circle
blank = zeros(Image_w , Image_h);
Centerpoint = [Image_w/2 , Image_h/2];
[r c] = meshgrid(1:max(Image_h,Image_w));
C = sqrt((r-Centerpoint(1,1)).^2+(c-Centerpoint(1,2)).^2)<= Radius+1;
D = sqrt((r-Centerpoint(1,1)).^2+(c-Centerpoint(1,2)).^2)<= Radius;
E =C-D;
[x y]= find(E~=0);
Circumference = [x y];

if(type == 1)
    
    for k=[1 2 3 4]
        
        rndnumber = randperm(3,1);
        KernelMatrix = [-1 -1;0 -1;1 -1;1 0;1 1;0 1;-1 1;-1 0];
        
        % MirrorElements = [1 5;2 6;3 7;4 8;5 1;6 2;7 3;8 4];
        switch k
            case 1 %left up
                a = Circumference(Circumference(:,2) < [Image_w/2],:);
                a = a(a(:,1) < [Image_h/2],:);
                randIndices = randperm(length(a),type);
                randSet = randIndices(1:(type));
                b=a(randSet,:);
                pointerx = b(1,1);
                pointery = b(1,2);
                ReducedKernel = KernelMatrix([1 2 8 3 7],:); %[1 2 3] %[1 2 3 4 8]
                MirrorElements = [4 8;8 4];
                P_case = [.25 .25 .25 .125 .125];
            case 2 %left down
                a = Circumference(Circumference(:,1) > [Image_h/2],:);
                a = a(a(:,2) < [Image_w/2],:);
                randIndices = randperm(length(a),type);
                randSet = randIndices(1:(type));
                b=a(randSet,:);
                pointerx = b(1,1);
                pointery = b(1,2);
                ReducedKernel = KernelMatrix([2 3 4 1 5],:); %[3 4 5]%[2 3 4 5 6]
                MirrorElements = [2 6;6 2];
                P_case = [.25 .25 .25 .125 .125];
            case 3 %right up
                a = Circumference(Circumference(:,2) > [Image_w/2],:);
                a = a(a(:,1) < [Image_h/2],:);
                randIndices = randperm(length(a),type);
                randSet = randIndices(1:(type));
                b=a(randSet,:);
                pointerx = b(1,1);
                pointery = b(1,2);
                ReducedKernel = KernelMatrix([6 7 8 1 5],:); %[5 6 7]%[4 5 6 7 8]
                MirrorElements = [4 8;8 4];
                P_case = [.25 .25 .25 .125 .125];
        
            otherwise %right down
                 a = Circumference(Circumference(:,1) > [Image_h/2],:);
                 a = a(a(:,2) > [Image_w/2],:);
                randIndices = randperm(length(a),type);
                randSet = randIndices(1:(type));
                b=a(randSet,:);
                pointerx = b(1,1);
                pointery = b(1,2);
                ReducedKernel = KernelMatrix([4 5 6 3 7],:);%[1 7 8]%[1 2 6 7 8]
                MirrorElements = [2 6;6 2];
                P_case = [.25 .25 .25 .125 .125];
        end
        
        Kernel = ReducedKernel;
        pointerx = pointerx + Kernel(rndnumber,1);
        pointery = pointery + Kernel(rndnumber,2);
        subtree_matrix = [pointerx pointery];
        MirrorElement = MirrorElements((MirrorElements(:,1)==rndnumber),2);
       blank(pointerx,pointery)= 1;
        Kernel = KernelMatrix;
        Kernel(MirrorElement,:)= [];
         upperbound = 1e2+rand(1e2);
     X = [1:length(Kernel)];
     P = P_case;
     %   upperbound = 1e2;
        for j=1:upperbound
            if (pointerx < Image_h && pointery < Image_w && pointerx > 1 && pointery > 1)
                if(rand<7e-2) %&& j>5)
                    blank = Subtree_generator(k,blank,subtree_matrix,KernelMatrix,Image_h,Image_w);
                end
                rndnumber = randnumber(P,X);
                pointerx = pointerx + Kernel(rndnumber,1);
                pointery = pointery + Kernel(rndnumber,2);
                subtree_matrix = [subtree_matrix;pointerx pointery];
                blank(pointerx,pointery)= 1;
                Kernel = ReducedKernel;
                X = [1:length(Kernel)];
                if((MirrorElements(:,1)==rndnumber))
                    MirrorElement = MirrorElements((MirrorElements(:,1)==rndnumber),2);
                    Kernel(MirrorElement,:)= [];
                end
                blank(pointerx,pointery)= 1;
            else
                break
            end
        end
     
    end
        
end
for n=1:length(Circumference)
blank(Circumference(n,1),Circumference(n,2))=1;
end
%imshow(blank);
imwrite(blank,['Img/sample-' num2str(m) '.png']);
end
end


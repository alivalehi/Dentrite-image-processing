function [ E ] = Subtree_generator(type,E,pointers,KernelMatrix,Image_h,Image_w,l)
ali=1;
if (type == 1)
    k_range=[1 2];
elseif (type == 2)
    k_range=[3 4];
elseif (type == 3)
    k_range=[5 6];
elseif (type == 4)
    k_range=[7 8];
else
    display('error');
end
a = pointers;


for k = k_range(randi(2,1))
    pointerx = a(end,1);
    pointery = a(end,2);
    lastpointx = pointerx;
    lastpointy = pointery;
    
    switch k
        case 1 %left
            
            %             randIndices = randperm(length(a),type);
            %             randSet = randIndices(1:(type));
            %             b=a(randSet,:);
            %             pointerx = b(1,1);
            %             pointery = b(1,2);
            ReducedKernel = KernelMatrix([1 7 8 6 2],:);%[1 2 3]1678
            MirrorElements = [4 8;8 4];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        case 2 %right
            %
            %             randIndices = randperm(length(a),type);
            %             randSet = randIndices(1:(type));
            %             b=a(randSet,:);
            %             pointerx = b(1,1);
            %             pointery = b(1,2);
            ReducedKernel = KernelMatrix([1 2 3 4 8],:); %[5 6 7]4567
            MirrorElements = [4 8;8 4];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        case 3 %down
            
            %             randIndices = randperm(length(a),type);
            %             randSet = randIndices(1:(type));
            %             b=a(randSet,:);
            %             pointerx = b(1,1);
            %             pointery = b(1,2);
            ReducedKernel = KernelMatrix([3 4 5 6 2],:); %[3 4 5]23456
            MirrorElements = [2 6;6 2];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
            
        case 4 %up
            %             randIndices = randperm(length(a),type);
            %             randSet = randIndices(1:(type));
            %             b=a(randSet,:);
            %             pointerx = b(1,1);
            %             pointery = b(1,2);
            ReducedKernel = KernelMatrix([1 2 3 8 4],:);%[1 7 8]1324
            MirrorElements = [2 6;6 2];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        case 5 %up
            ReducedKernel = KernelMatrix([1 7 8 2 6],:);%[1 7 8]1324
            MirrorElements = [2 6;6 2];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        case 6 %up
            ReducedKernel = KernelMatrix([5 6 7 4 8],:);%[1 7 8]1324
            MirrorElements = [2 6;6 2];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        case 7 %up
            ReducedKernel = KernelMatrix([3 4 5 2 6],:);%[1 7 8]1324
            MirrorElements = [2 6;6 2];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        case 8 %up
            ReducedKernel = KernelMatrix([5 6 7 8 4],:);%[1 7 8]1324
            MirrorElements = [2 6;6 2];
            %P_case = [.25 .25 .25 .125 .125];
            P_case = [.2727 .2727 .2727 .0909 .0909];
        otherwise %right up
            %             a = Circumference(Circumference(:,2) > [Image_w/2],:);
            %             a = a(a(:,1) < [Image_h/2],:);
            %             randIndices = randperm(length(a),type);
            %             randSet = randIndices(1:(type));
            %             b=a(randSet,:);
            %             pointerx = b(1,1);
            %             pointery = b(1,2);
            %             ReducedKernel = KernelMatrix([6 7 8],:); %[5 6 7]%[4 5 6 7 8]
            %             MirrorElements = [4 8;8 4];
    end
    Kernel = KernelMatrix;
    subtree_matrix =  [pointerx pointery];
    P = ones(1,8);
    X = [1:length(Kernel)];
    lastx(1) = pointerx;
    lasty(1) = pointery;
    i=1;
    upperbound = 5e1+rand(3e1);
    for j=1:upperbound
        
        if (pointerx < Image_h && pointery < Image_w && pointerx > 1 && pointery > 1)
            if(rand<5e-2)
                E = Subtree_generator(type,E,subtree_matrix,KernelMatrix,Image_h,Image_w);
            end
            rndnumber = randnumber(P,X);
            if(E(pointerx+Kernel(rndnumber,1),pointery+Kernel(rndnumber,2))~= 1)
                pointerx = pointerx + Kernel(rndnumber,1);
                pointery = pointery + Kernel(rndnumber,2);
                subtree_matrix = [subtree_matrix;pointerx pointery];
                radius = 1;
                downboundx = pointerx-radius;
                upboundx = pointerx+radius;
                downboundy = pointery-radius;
                upboundy = pointery+radius;
                frame = E(downboundx:upboundx,downboundy:upboundy);
                
                Kernel = ReducedKernel;
                X = [1:length(Kernel)];
                P = P_case;
                if((MirrorElements(:,1)==rndnumber))
                    MirrorElement = MirrorElements((MirrorElements(:,1)==rndnumber),2);
                    Kernel(MirrorElement,:)= [];
                end
                %find all 1 in frame
                if(length(frame(frame==1))>1 && j~=1)
                    if(rand<0.5)
                        E(pointerx,pointery)= 1;
                    elseif(rand>0.5)
                       
                        pointerx = lastx(j-1);
                        pointery = lasty(j-1);
                    end
                elseif(length(frame(frame==1))>1 && j==1)% && length(lastx(lastx(:)==pointerx))<1 && length(lasty(lasty(:)==pointery))<1)
                    
                    pointerx = lastpointx;
                    pointery = lastpointy;
                    
                else
                    E(pointerx,pointery)= 1;
                end
                
                lastx(j) = pointerx;
                lasty(j) = pointery;
            else
                break
                if (j>1)
                    pointerx = lastx(j-1);
                    pointery = lasty(j-1);
                    
                else
                    pointerx = lastpointx;
                    pointery = lastpointy;
                end
                lastx(j) = pointerx;
                lasty(j) = pointery;
            end
        end
    end
end
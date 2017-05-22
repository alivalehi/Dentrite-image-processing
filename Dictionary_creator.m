if(1)
    clear all
    l=1;
    o=1;
    numberlist = [1:60]; %3,11,12,14,16,22,27,28,30,34,37,38,46,49,53,56,57,58,60 removed
    numberlist = numberlist(find(~ismember(numberlist,[3,11,12,14,16,22,23,24,27,28,29,30,34,37,38,39,40,46,47,48,49,50,53,54,56,57,58,59,60,4,6,8,9,10,15,18,19,20,21]))); %4,6,8,9,10,15,18,19,20,21 is just for ROC test
    
    for q=numberlist
%         imagestr{o} = ['original/b' num2str(q) '.png'];
        imagestr{o} = ['Artificial dendrite/Img/sample-' num2str(1) '.png'];
        o =o+1;
    end
    % image = ['original/b1.png';'original/b2.png';'original/b4.png';'original/b5.png';'original/b6.png';'original/b7.png'];%'original/7.png';'original/8.png'];%;'original/9.png']
    w= length(numberlist);
    plastindex= 1;
    if(0)% if it is not firstime should be 1
        previousdata = load('GraphDic.mat');
        plastindex = previousdata.imagegraph.lastindex;
    end
    lastindex = plastindex + w-1;
    for k=plastindex:lastindex
        k
        string = imagestr{l};
        result =  graph_based(string);
        command = ['imagegraph.n' num2str(k) '=result' ];
        eval(command);
        eval(['save(''time/GraphDic' num2str(k) '.mat'',''result'');'])
        l=l+1;
    end
    imagegraph.lastindex = lastindex;
    save('GraphDic.mat' ,'imagegraph');
end
if(0)
    clear all
    image = ['original/1.png';'original/2.png';'original/3.png';'original/4.png';'original/5.png';'original/6.png'];%'original/7.png';'original/8.png'];%;'original/9.png']
    [w,h] = size(image);
    for k=1:w
        minutiae_points(k) =  minutiae_based(image(k,:))  ;
        k
    end
    save('minutiae_points.mat','minutiae_points') ;
end
if(0)
    clear all
    image = ['original/6.png';'original/7.png';'original/8.png'];%;'original/9.png']
    % image(2) = 'original/2.png';
    % image(3) = 'original/3.png';
    % image(4) = 'original/4.png';
    % image(5) = 'original/5.png';
    % image(6) = 'original/6.png';
    % image(7) = 'original/7.png';
    % image(8) = 'original/8.png';
    % image(9) = 'original/9.png';
    %figure;
    %imshow(RGB);
    %title('Original indexed image');
    %pause;
    [K,L] = size(image);
    for k=1:K
        RGB = imread(image(k,:));
        I = rgb2gray(RGB);
        figure;
        imshow(I);
        bw = im2bw(I,0.35);
        figure;
        imshow(bw);
        [w,h] = size(bw);
        s = regionprops(bw,'centroid');
        s_length = length(s);
        for o = 1:s_length
            center_distance(o) =  norm(s(o).Centroid - [w/2 h/2]);
        end
        %             P = find(center_distance==min(center_distance));
        %             X = s(P).Centroid(1,1);
        %             Y = s(P).Centroid(1,2);
        %             scaled = imcrop(bw,[X-50 Y-50 99 99]);
        %       out = bwareaopen(scaled, 700);
        out = bwareaopen(bw, 700);
        figure;
        imshow(out);
        skleton = bwmorph(out,'skel',inf);
        figure;
        imshow(skleton);
        %             tiles = mat2cell(scaled,5*ones(1,20),5*ones(1,20));
        %             [m,n] = size(tiles);
        %             indicator = zeros(n,m);
        %             for i=1: m
        %                 for j=1:n
        %                     tiles_numric = cell2mat(tiles(i,j));
        %                     if(any(tiles_numric(1,:)));
        %                         indicator(i,j) = indicator(i,j)+8;
        %                     end
        %                     if(any(tiles_numric(:,end)));
        %                         indicator(i,j) = indicator(i,j)+4;
        %                     end
        %                     if(any(tiles_numric(end,:)));
        %                         indicator(i,j) = indicator(i,j)+2;
        %                     end
        %                     if(any(tiles_numric(:,1)));
        %                         indicator(i,j) = indicator(i,j)+1;
        %                     end
        %                 end
        %             end
        %
        %             A(:,k) = reshape(indicator,n*m,1);
        %             center_distance = [];
    end
    %save('Dictionary.mat','A') ;
    B = A(:,1);
    [w_A,h_A] = size(A);
    for l=1:h_A
        D(l) =  norm(A(:,l) - B);
    end
    fprintf('Matched image is image number:%d \n',(find(D==min(D))));
end
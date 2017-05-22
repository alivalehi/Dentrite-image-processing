function result=minutiae_based(image_file)
RGB = imread(image_file);
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
%             X = s(P).Centroid(1,1);
%             Y = s(P).Centroid(1,2);
%             scaled = imcrop(bw,[X-50 Y-50 99 99]);
%             out = bwareaopen(scaled, 700);
            out = bwareaopen(bw, 700);
%     figure;
%     imshow(out);
    skleton = bwmorph(out,'skel',inf);
%      figure;
%      imshow(skleton);
fun=@minutie;
L = nlfilter(skleton,[3 3],fun);
LTerm=(L==1);
imshow(LTerm)
LTermLab=bwlabel(LTerm);
propTerm=regionprops(LTermLab,'Centroid');
CentroidTerm=round(cat(1,propTerm(:).Centroid));
% imshow(~skleton)
% set(gcf,'position',[1 1 600 600]);
% hold on
% plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
LBif=(L==3);
LBifLab=bwlabel(LBif);
propBif=regionprops(LBifLab,'Centroid','Image');
CentroidBif=round(cat(1,propBif(:).Centroid));
plot(CentroidBif(:,1),CentroidBif(:,2),'go')
D=0;
Distance=DistEuclidian(CentroidBif,CentroidTerm);
SpuriousMinutae=Distance<D;
[i,j]=find(SpuriousMinutae);
CentroidBif(i,:)=[];
CentroidTerm(j,:)=[];
Distance=DistEuclidian(CentroidBif);
SpuriousMinutae=Distance<D;
[i,j]=find(SpuriousMinutae);
CentroidBif(i,:)=[];
Distance=DistEuclidian(CentroidTerm);
SpuriousMinutae=Distance<D;
[i,j]=find(SpuriousMinutae);
CentroidTerm(i,:)=[];
% hold off
% imshow(~skleton)
% hold on
% plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
% plot(CentroidBif(:,1),CentroidBif(:,2),'go')
% hold off

Kopen=imclose(skleton,strel('square',7));

KopenClean= imfill(Kopen,'holes');
KopenClean=bwareaopen(KopenClean,5);
imshow(KopenClean)
KopenClean([1 end],:)=0;
KopenClean(:,[1 end])=0;
ROI=imerode(KopenClean,strel('disk',5));
% imshow(ROI)
% imshow(I)
% hold on
% imshow(ROI)
% alpha(0.5)

hold on
plot(CentroidTerm(:,1),CentroidTerm(:,2),'ro')
plot(CentroidBif(:,1),CentroidBif(:,2),'go')
hold off
[m,n]=size(I(:,:,1));
indTerm=sub2ind([m,n],CentroidTerm(:,1),CentroidTerm(:,2));
Z=zeros(m,n);
Z(indTerm)=1;
ZTerm=Z;%.*ROI';
[CentroidTermX,CentroidTermY]=find(ZTerm);

indBif=sub2ind([m,n],CentroidBif(:,1),CentroidBif(:,2));
Z=zeros(m,n);
Z(indBif)=1;
ZBif=Z;%.*ROI';
[CentroidBifX,CentroidBifY]=find(ZBif);


% 
% imshow(I)
% hold on
% plot(CentroidTermX,CentroidTermY,'ro','linewidth',2)
% plot(CentroidBifX,CentroidBifY,'go','linewidth',2)
Table=[3*pi/4 2*pi/3 pi/2 pi/3 pi/4
       5*pi/6 0 0 0 pi/6
       pi 0 0 0 0
      -5*pi/6 0 0 0 -pi/6
      -3*pi/4 -2*pi/3 -pi/2 -pi/3 -pi/4];
  for ind=1:length(CentroidTermX)
    Klocal=skleton(CentroidTermY(ind)-1:CentroidTermY(ind)+1,CentroidTermX(ind)-1:CentroidTermX(ind)+1);
    Klocal(2:end-1,2:end-1)=0;
    [i,j]=find(Klocal);
    OrientationTerm(ind,1)=Table(i,j);
end
dxTerm=sin(OrientationTerm)*5;
dyTerm=cos(OrientationTerm)*5;
% figure
% imshow(skleton)
% set(gcf,'position',[1 1 600 600]);
% hold on
% plot(CentroidTermX,CentroidTermY,'ro','linewidth',2)
% plot([CentroidTermX CentroidTermX+dyTerm]',...
%     [CentroidTermY CentroidTermY-dxTerm]','r','linewidth',2)
for ind=1:length(CentroidBifX)
    Klocal=skleton(CentroidBifY(ind)-1:CentroidBifY(ind)+1,CentroidBifX(ind)-1:CentroidBifX(ind)+1);
    Klocal(2:end-1,2:end-1)=0;
    [i,j]=find(Klocal);
    if length(i)~=3
        CentroidBifY(ind)=NaN;
        CentroidBifX(ind)=NaN;
        OrientationBif(ind)=NaN;
    else
        for k=1:3
            OrientationBif(ind,k)=Table(i(k),j(k));
            dxBif(ind,k)=sin(OrientationBif(ind,k))*5;
            dyBif(ind,k)=cos(OrientationBif(ind,k))*5;

        end
    end
end
result.CentroidTermX = CentroidTermX;
result.CentroidTermY = CentroidTermY;
result.CentroidBifX = CentroidBifX;
result.CentroidBifY = CentroidBifY;
result.OrientationTerm = OrientationTerm;
result.OrientationBif = OrientationBif;

% plot(CentroidBifX,CentroidBifY,'go','linewidth',2)
% OrientationLinesX=[CentroidBifX CentroidBifX+dyBif(:,1);CentroidBifX CentroidBifX+dyBif(:,2);CentroidBifX CentroidBifX+dyBif(:,3)]';
% OrientationLinesY=[CentroidBifY CentroidBifY-dxBif(:,1);CentroidBifY CentroidBifY-dxBif(:,2);CentroidBifY CentroidBifY-dxBif(:,3)]';
% plot(OrientationLinesX,OrientationLinesY,'g','linewidth',2)
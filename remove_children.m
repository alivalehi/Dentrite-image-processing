function [ additivenodes ] = remove_children( graph,x,y,level,additivenodes )
%REMOVE_CHILDREN Summary of this function goes here
%   Detailed explanation goes here
level
additional_list = graph(find(~ismember(graph(:,[5,6,7]),[level,x,y],'rows')),:);  
additional_list= additional_list(find(additional_list(:,5)==level),:);
[numberofnodes,numberofinfo] = size(additional_list);
for i=1:numberofnodes

    additionalnodesx=additional_list(i,8);    
    additionalnodesy=additional_list(i,9);
    additionalnodeslevel=additional_list(i,5);
    
    additivenodes = [additivenodes; additionalnodesx additionalnodesy];
     if(~isempty(graph(find(ismember(graph(:,[5,6,7]),[additionalnodeslevel+1,additionalnodesx,additionalnodesy],'rows')),:)) && sum(ismember(additivenodes,[additionalnodesx additionalnodesy],'rows'))<=1)
         remove_children( graph,additionalnodesx,additionalnodesy,additionalnodeslevel+1,additivenodes);
     end    
end


function [robust_nodes ] = prune( graph )
%PRUNE Summary of this function goes here
%   Detailed explanation goes here

%GET_CHILDREN Summary of this function goes here
%   Detailed explanation goes here
clear function
persistent End_point;
persistent Fathers;
persistent nodestorage;
% persistent additivenodes;

parent = graph(graph (:,5)==1,:);
[numberofnodes,numberofinfo] = size(parent);
distnode = zeros(numberofnodes,3);
tic
for q=1:numberofnodes
    nodestorage= parent(q,:);
    [ End_point,First_father,Fathers ] = get_children( graph,parent(q,:),parent(q,[8,9]),End_point,Fathers,nodestorage);
    if(~isempty(End_point))
        distnode(q,1)= max(End_point);
        distnode(q,2)= parent(q,8);
        distnode(q,3)= parent(q,9);
    end
    clear('End_point');
    clear('Fathers');
    End_point =[];
    Fathers = [];
end
toc
clear_nodes = distnode((distnode(:,1)>35),:);
nodes_withoutfirst = graph(graph (:,5)~=1,:);
parent = graph(graph (:,5)==1,:);
filteredfirstlevel = parent(find(ismember(parent (:,[8,9]),clear_nodes(:,[2,3]),'rows')),:);
robust_nodes=[nodes_withoutfirst;filteredfirstlevel ];
%      clear_nodes = distnode((distnode(:,1)>50),:);
%     dirty_nodes = distnode((distnode(:,1)<50),:);
%     nodes_withoutfirst = graph(graph (:,5)~=1,:);
%     parent = graph(graph (:,5)==1,:);
%     filteredfirstlevel = parent(find(ismember(parent (:,[8,9]),clear_nodes(:,[2,3]),'rows')),:);
%     dirtyfirstlevel = parent(find(~ismember(parent (:,[8,9]),clear_nodes(:,[2,3]),'rows')),:);
%     for ww=1:numberofnodes
%      junk = remove_children( graph,dirtyfirstlevel(ww,8),dirtyfirstlevel(ww,9),2,additivenodes);
%     end
%     temp_robust=[nodes_withoutfirst;filteredfirstlevel ];
%     robust_nodes = temp_robust(find(~ismember(parent (:,[8,9]),additivenodes(:,[1,2]),'rows')),:);
end


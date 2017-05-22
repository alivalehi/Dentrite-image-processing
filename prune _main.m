function [ robust_nodes ] = prune( graph )
    %GET_CHILDREN Summary of this function goes here
    %   Detailed explanation goes here
   clear functions
    persistent End_point;
    persistent Fathers;
    parent = graph(graph (:,5)==1);
    [numberofnodes,numberofinfo] = size(parent);
    for q=1:length(numberofnodes)
    [ End_point,First_father,Fathers ] = get_children( graph,parent,parent(q,[8,9]) )
    end
end


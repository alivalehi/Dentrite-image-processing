function [ Distance ] = graph_distance( target_node,targetDic_nodes)
%GRAPH_DISTANCE Summary of this function goes here
%   Detailed explanation goes here
 

    Euclidean_distance = sqrt((target_node(8)-targetDic_nodes(8))^2+(target_node(9)-targetDic_nodes(9))^2);
    angle_difference   = 0;%sqrt((target_node(3)-targetDic_nodes(3))^2);
    Distance     = Euclidean_distance+angle_difference;  

%     Euclidean_distance = ((target_node(1)^2+target_node(2)^2)+(targetDic_nodes(1)^2+targetDic_nodes(2)^2));
%     angle_difference   = cos((target_node(3)-targetDic_nodes(3)));
%     Distance     = sqrt(Euclidean_distance+angle_difference*sqrt((target_node(1)^2+target_node(2)^2))*sqrt((targetDic_nodes(1)^2+targetDic_nodes(2)^2)));  
end


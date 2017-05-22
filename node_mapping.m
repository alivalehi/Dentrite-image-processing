function [minvalue,minindex,minDistance,parent_mapping] = node_mapping( Distance,i)
%NODE_MAPPING Summary of this function goes here
%   Detailed explanation goes here
     [distance_h,distance_w] = size(Distance);
       eval(['parent_mapping' num2str(i) ' = zeros(' num2str(distance_h) ',' num2str(distance_w) ');' ]);
%        if(distance_w>distance_h)
%            minDistance = inf(1,distance_h);
%            for p =1 : distance_h
%                 [minvalue,minindex] = min(Distance(p,:));
%                 Distance(:,minindex)= inf; 
%                 minDistance(p)      = minvalue;
%                 if(minDistance(p)~=Inf)
%                     eval(['parent_mapping' num2str(i) '(' num2str(p) ',' num2str(minindex) ') = 1;' ]);
%                 end
%            end
   [distance_h,distance_w] = size(Distance);
       eval(['parent_mapping' num2str(i) ' = zeros(' num2str(distance_h) ',' num2str(distance_w) ');' ]);
       if(distance_w>distance_h)
           alive_nodes = 1:distance_h;
           female = 1:distance_w; 
           male = 1:distance_h;
            for p =1 : distance_h
               [ali,MI(p,:)] = sort(Distance(p,:))
           end
            for q =female
                
                [minvalue,minindex] = min(MI(q,:));
                for p =alive_nodes
                b =sum(MI(:,p)==minvalue)
                if(b>1)
            
                    [X,Y]=find(min(Distance(find(MI(:,p)==minvalue))));
                    alive_nodes(find(~ismember(alive_nodes,[minvalue])));
                 
                    break
                else
                   alive_nodes = alive_nodes(find(~ismember(alive_nodes,[minvalue]))); 
                   MI(:,q) = inf;
                   MI(MI==minvalue)=inf;
                   break;
                end    
                    
                end
            end
       
       else
           minDistance = inf(1,distance_w);
           for p =1 : distance_w
                [minvalue,minindex] = min(Distance(:,p));
                Distance(minindex,:)= inf; 
                minDistance(p)      = minvalue;
                if(minDistance(p)~=Inf)
                eval(['parent_mapping' num2str(i) '(' num2str(minindex) ',' num2str(p) ') = 1;' ]);
                end
           end 
       end
        eval(['parent_mapping = parent_mapping' num2str(i) ';']); 
       
end


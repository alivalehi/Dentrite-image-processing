function result=node_search(junctions,image,parent)

parent.level = parent.level+1;
parentreserve = parent;
%     nodes = [];
%     skelet = [];
indicator = [];
persistent skelet;
persistent nodes;
persistent nodes_cordinates;
persistent endpoint_flag;
[w,h] = size(image);
endpoint_flag = 0;
for i=1:length(junctions)
    parent = parentreserve;
    endpoint_flag = 0;
    startpoint_flag = 0;
    center = junctions(i);
    skelet = [skelet;center.x center.y];
    skelet = unique(skelet,'rows');
    while(~endpoint_flag)
        downboundx = (center.x-1) ;
        upboundx = (center.x+1);
        downboundy = (center.y-1) ;
        upboundy = (center.y+1) ;
        %%To be consistent with image dimention
        if(center.x<=1) %% it was ==
            downboundx = 2;%changed on 4/12/2017 (downboundx+1) ;
            indicator = 0;
        elseif(center.x>=w) %% it was ==
            upboundx = w-1;%changed on 4/12/2017 (downboundx-1) ;
        indicator = 0;
        elseif(center.y<=1) %% it was ==
            downboundy = 2 ;%changed on 4/12/2017 (downboundy+1) ;
        indicator = 0;
        elseif(center.y>=h) %% it was ==
            upboundy = h-1 ;%changed on 4/12/2017 (downboundy-1) ;
        indicator = 0;
        end
        if(isempty(indicator))
        frame = image(downboundx:upboundx,downboundy:upboundy);
        %find all 1 in frame
        [newpoint.x,newpoint.y] = find(frame==1);
        neighbor.x = center.x + (newpoint.x-2);
        neighbor.y = center.y + (newpoint.y-2);
        neighbors = [neighbor.x neighbor.y];
        %remove center point and pints which already stored and find
        %next point for moving the window
        new_neighbors = setdiff(neighbors,intersect(neighbors,skelet,'rows'),'rows');
        [indicator junk]= size(new_neighbors);
    end
        if(indicator==0)%endpoint
            nodetype = 2;%endpoint
            %node(x,y,level,parentxy,type)
            if(~isempty(nodes_cordinates))
                if(isempty(intersect([center.x center.y],nodes_cordinates,'rows')))
                    nodes = [nodes;center.x center.y nodetype parent.level parent.x parent.y ];
                    nodes_cordinates =  [nodes_cordinates;center.x center.y];
                end
            else
                nodes = [nodes;center.x center.y nodetype parent.level parent.x parent.y ];
                nodes_cordinates =  [nodes_cordinates;center.x center.y];
            end
            endpoint_flag = 1;
            skelet = [skelet;center.x center.y];
            %             elseif(indicator==1 && ~startpoint_flag)%startingpoint
            %                 startpoint_flag=1;
            %                 frame(2,2)=0;
            %                 last_center=center;
            %                 [newpoint.x,newpoint.y] = find(frame==1);
            %                 center.x = center.x + (newpoint.x-2);
            %                 center.y = center.y + (newpoint.y-2);
            %                 skelet = [skelet;center.x center.y];
            indicator = [];
        elseif(indicator==1)%usual point
            %                 frame(2+last_center.x-center.x,2+last_center.y-center.y)=0;
            %                 last_center=center;
            %                 [newpoint.x,newpoint.y] = find(frame==1);
            % move window to new position
            center.x = new_neighbors(1,1);
            center.y = new_neighbors(1,2);
            skelet = [skelet;center.x center.y];
            indicator = [];
        elseif(indicator>=2)%bifurcation
            nodetype = 1;%bifurcation
            
            if(~isempty(nodes_cordinates))
                if(isempty(intersect([center.x center.y],nodes_cordinates,'rows')))
                    nodes = [nodes;center.x center.y nodetype parent.level parent.x parent.y];
                    nodes_cordinates =  [nodes_cordinates;center.x center.y];
                end
            else
                nodes = [nodes;center.x center.y nodetype parent.level parent.x parent.y ];
                nodes_cordinates =  [nodes_cordinates;center.x center.y];
            end
            parent.x = center.x;
            parent.y = center.y;
            %                 new_inframe_x =2-(center.x-new_neighbors(:,1));
            %                 new_inframe_y =2-(center.y-new_neighbors(:,2));
            %                 frame(new_inframe_x,new_inframe_y)=0;
            %                 last_center=center;
            %                 [newpoint.x,newpoint.y] = find(frame==1);
            %                 center.x = center.x + (newpoint.x-2);
            %                 center.y = center.y + (newpoint.y-2);
            new_inframe_x =2-(center.x-new_neighbors(:,1));
            new_inframe_y =2-(center.y-new_neighbors(:,2));
            %                 center.x = center.x + (newpoint.x-2);
            %                 center.y = center.y + (newpoint.y-2);
            skelet = [skelet;new_neighbors(:,1) new_neighbors(:,2)];
            skelet = [skelet;center.x center.y];
            for j=1:length(new_inframe_x)
                new_junction(j).x = new_neighbors(j,1);
                new_junction(j).y = new_neighbors(j,2);
            end
            node_search(new_junction,image,parent);
            indicator = [];
        end
    end
end
result = nodes;
end
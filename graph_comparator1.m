clc;
clear all
%load('GraphDic.mat');
image_file            = 'original/b41.png'; %3,11,12,14,16,22,27,28,30,34,37,38,46,49,53,56,57,58,60 not indexed
sample                = graph_based(image_file);
maxnode_test          = max(sample(:,5));
sampleindex_dic       = 1:imagegraph.lastindex;
firstlevel_flag       = 1;
parent_id_test        = [];
parent_samelevel_dic  = [];
node_exceed_flag      = 0;
samplemindistance =0;
Distancesubgraphs = [];
tic
% node ------->  (Rx,Ry,angle,type ,level,parentxy,x,y)
for j=1: maxnode_test %current level index
   j
    samelevel_test   = sample(find(sample(:,5)==j),:); % get information of all of the nodes which has level=j in test graph
    lastlevel_test   = sample(find(sample(:,5)==j-1),:);
    [h,w]            = size(samelevel_test);
    parrent_mapping0 = zeros(1,w);
    for i= sampleindex_dic % graph index in Dic
        
     if(firstlevel_flag)
         
        eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '(find(imagegraph.n' num2str(i) '(:,5)==j),:);']);% get information of all of the nodes which has level=j in Dic graph =i
        eval(['[h1,w1] = size(samelevel_dic' num2str(j) num2str(i) ');']);
        Distance = Inf(h,h1);
     else
         Distance = Inf(h,max(sample(:,10)));
     end
       
           
           
         for k=1:h % node index in test graph
                
               
            if(~firstlevel_flag)
                %%%(extract only childeren of mapped)
                
               eval(['samelevel_dic' num2str(j-1) num2str(i) ' = imagegraph.n' num2str(i) '(find(imagegraph.n' num2str(i) '(:,5)==j-1),:);']);% get information of all of the nodes which has level=j in Dic graph =i
               eval(['[test_index,dic_index]=find(parent_mapping'  num2str(j-1) num2str(i) ' == 1);']);
               [indexa,indexbb]=sort(test_index);
               dic_index = dic_index(indexbb);
                parent_id_test = find(eval(['ismember(lastlevel_test(:,[8 9]),[samelevel_test(k,[6,7])],''rows'')']));%find parent of current node (test)
                parent_id_dic  = dic_index(find(test_index==parent_id_test));
                if(~isempty(parent_id_dic))
                    %%extract childeren  of mapped
                  
                    parenty = eval(['samelevel_dic' num2str(j-1) num2str(i) '(' num2str(parent_id_dic) ',[8])']);
                    parentx = eval(['samelevel_dic' num2str(j-1) num2str(i) '(' num2str(parent_id_dic) ',[9])']);
                  if(samelevel_test(k,4)==1)
                    eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '((find(ismember(imagegraph.n' num2str(i) '(:,[4,5,6,7]),[1,j,' ...
                    num2str(parenty) ',' num2str(parentx) '],''rows''))),:);']);% get information of all of the nodes which has level=j in Dic graph =i (extract only childeren of mapped)
                    endpoint_flag =0;
                  else
                      endpoint_flag =1;
                      eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '((find(ismember(imagegraph.n' num2str(i) '(:,[4,5,6,7]),[2,j,' ...
                    num2str(parenty) ',' num2str(parentx) '],''rows''))),:);']);% get information of all of the nodes which has level=j in Dic graph =i (extract only childeren of mapped)
                  end
                    eval(['[h1,w1] = size(samelevel_dic' num2str(j) num2str(i) ');']);
                %   if(samelevel_test(k,4)==1)
                    node_exceed_flag =0;
                 %  else
                %       node_exceed_flag = 1;
                %   end
                else
                   node_exceed_flag = 1;
                end 
            end
            if(~node_exceed_flag)
                for l= [1:h1] %node index in selected graph in Dic
                   subDistance = [];
                   eval( ['targetDic_nodes = samelevel_dic' num2str(j) num2str(i) '(l,:);']); %put node #(l) of graph #(i) level #(j) in targetDic_nodes
                   target_node        = samelevel_test(k,:); %put node #(k) of test graph level #(j) in target_node
                   if(~firstlevel_flag)
                      if(~endpoint_flag)
                       %%%find nearest point in triangle of node and cilderen%%%
                       currenty = targetDic_nodes(8);
                       currentx = targetDic_nodes(9);
                       eval(['samelevel_dic' num2str(j+1) num2str(i) ' = imagegraph.n' num2str(i) '((find(ismember(imagegraph.n' num2str(i) '(:,[5,6,7]),[j+1,' ...
                       num2str(currenty) ',' num2str(currentx) '],''rows''))),:);']);% get children of current node
                     %  eval(['samelevel_dic' num2str(j+1) num2str(i) '[end+1,:] = samelevel_dic' num2str(j) num2str(i) '(l,:)'])
                       [length_subgraphy,length_subgraphx ] = eval(['size(samelevel_dic' num2str(j+1) num2str(i) ');']);
                       for q=1: length_subgraphy  
                         eval( ['targetDic_nodessub = samelevel_dic' num2str(j+1) num2str(i) '(q,:);']); %put node #(l) of graph #(i) level #(j+1) (childre of current) in targetDic_nodes
                         subDistance(q)      = graph_distance( target_node,targetDic_nodessub); %measure distance between current node of test graph  and children of current node of dic 
                       end
                         subDistance(end+1)  = graph_distance( target_node,targetDic_nodes);%measure distance between current node of test graph  and current node of dic 
                        [valuemin,index_min] = min(subDistance);% find bestmatch of current node and corresponding nodes in dic
                      if(index_min~=length(subDistance))
                           eval( ['targetParentDic_nodes = samelevel_dic' num2str(j+1) num2str(i) '(' num2str(index_min) ',:);']); %put node #(l) of graph #(i) level #(j) in targetDic_nodes
                      else
                           targetParentDic_nodes = targetDic_nodes;
                      end
                      
                     %%% map between childeren and main node of triangle%%%
                      
                       currenty = targetParentDic_nodes(8);
                       currentx = targetParentDic_nodes(9);
                       level = targetParentDic_nodes(5);
                       eval(['nextlevel_dic' num2str(level+1) num2str(i) ' = imagegraph.n' num2str(i) '((find(ismember(imagegraph.n' num2str(i) '(:,[5,6,7]),[level+1,' ...
                       num2str(currenty) ',' num2str(currentx) '],''rows''))),:);']);% get children of current node(matched node with top)
                       eval(['nextlevel_test = sample((find(ismember(sample(:,[5,6,7]),[j+1,samelevel_test(k,8) ,samelevel_test(k,9)],''rows''))),:);']);
                      eval(['[yh1,yw1] = size(nextlevel_dic' num2str(level+1) num2str(i) ');']);
                       [xh1,xw1]            = size(nextlevel_test);
                      for x=1:xh1
                           for y =1:yh1
                                eval( ['targetParentDic_nodes = nextlevel_dic' num2str(level+1) num2str(i) '(' num2str(y) ',:);']); %put node #(l) of graph #(i) level #(j) in targetDic_nodes
                                target_node        = nextlevel_test(x,:); %put node #(k) of test graph level #(j) in target_node
                                Distancesubgraphs(y,x)      = graph_distance( target_node,targetParentDic_nodes);
                           end
                      end
                       if(~isempty(Distancesubgraphs))
                       [minvalue,minindex,minDistance,parent_mapping] = node_mapping( Distancesubgraphs,['sub' num2str(i)]);
                       l_id = targetDic_nodes(10);
                       Distance(k,l_id) = valuemin + sum(minDistance);  
                      end
                      else
                           l_id = targetDic_nodes(10);
                          Distance(k,l_id)      = graph_distance( target_node,targetDic_nodes);
                      end
                     
                       %%%
                       
                   else
                         Distance(k,l)      = graph_distance( target_node,targetDic_nodes);
                   end
                end  
            end
         end
    [minvalue,minindex,minDistance,parent_mapping] = node_mapping( Distance,i);
    eval(['parent_mapping' num2str(j) num2str(i) ' = parent_mapping ;' ]); 
    if(sum(isinf(minDistance))~= length(minDistance))  
        samplemindistance(i) = sum(minDistance(minDistance~=Inf));
    end
    end 
    firstlevel_flag  = 0;
   [B,I]             =  sort(samplemindistance);
   sampleindex_dic   = I(1:ceil(length(sampleindex_dic)/2));
   samplemindistance = Inf(1,imagegraph.lastindex);
   graph_vote(i)     = samplemindistance(i);
   Distance = [];
   if(length(sampleindex_dic)==1 || sum(~isinf(B))==1)
   fprintf('matched graph is : %d\n',round(sampleindex_dic(1)))
   toc
break
   end    
end
        

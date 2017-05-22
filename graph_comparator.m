function [ result ] = graph_comparator( image_file,noise_flag )
%GRAPH_COMPARATOR Summary of this function goes here
%   Detailed explanation goes here
if (nargin==1)
    noise_flag = [];
end
%tic
load('GraphDic.mat');
%image_file            = 'original/b41.png'; %3,11,12,14,16,22,27,28,30,34,37,38,46,49,53,56,57,58,60 not indexed

if(0)
    load('test.mat')
else
    sample = graph_based(image_file,noise_flag);
    [pathstr,name,ext] = fileparts(image_file);
    save(['test' name '.mat']);
end
maxnode_test          = max(sample(:,5));
sampleindex_dic       = 1:imagegraph.lastindex;
firstlevel_flag       = 1;
parent_id_test        = [];
parent_samelevel_dic  = [];
node_exceed_flag      = 0;
samplemindistance = 0;
l_total = 0;
k_total = 0;
penalty = 0;
Distancesubgraphs = [];
graph_vote = 0;
B=[];
I=[];
B1=[];
I1=[];
diffdistance = 1000000*ones(1,imagegraph.lastindex);
copy_samplemindistance = 0;
% node ------->  (Rx,Ry,angle,type ,level,parentxy,x,y)
for j=1: maxnode_test %current level index
    
    samelevel_test   = sample(find(sample(:,5)==j),:); % get information of all of the nodes which has level=j in test graph
    lastlevel_test   = sample(find(sample(:,5)==j-1),:);
    [h,w]            = size(samelevel_test);
    parrent_mapping0 = zeros(1,w);
    for i= sampleindex_dic % graph index in Dic
        
        if(firstlevel_flag)
            %      Ids = [1:h].';
            %      samelevel_test = [samelevel_test(:,1:end-1),Ids];
            eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '(find(imagegraph.n' num2str(i) '(:,5)==j),:);']);% get information of all of the nodes which has level=j in Dic graph =i
            eval(['[aa,bb]=size(samelevel_dic' num2str(j) num2str(i) ');']);
            %      Ids = [1:aa].';
            %      eval(['samelevel_dic' num2str(j) num2str(i) ' = [samelevel_dic' num2str(j) num2str(i)  '(:,1:end-1),Ids];']);% get information of all of the nodes which has level=j in Dic graph =i
            eval(['[h1,w1] = size(samelevel_dic' num2str(j) num2str(i) ');']);
            Distance = eval(['Inf(max(samelevel_test(:,10)),max(samelevel_dic' num2str(j) num2str(i) '(:,10)))']);
            parenty = eval(['samelevel_dic' num2str(j) num2str(i) '(1,[6])']);
            parentx = eval(['samelevel_dic' num2str(j) num2str(i) '(1,[7])']);
        else
            eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '(find(imagegraph.n' num2str(i) '(:,5)==j),:);']);% get information of all of the nodes which has level=j in Dic graph =i
            Distance = eval(['Inf(max(samelevel_test(:,10)),max(samelevel_dic' num2str(j) num2str(i) '(:,10)))']);
        end
        
        
        
        for k=1:h % node index in test graph
            
            
            if(~firstlevel_flag && (eval(['exist(''samelevel_dic' num2str(j-1) num2str(i) ''')==1']))&& (eval(['exist(''parent_mapping' num2str(j-1) num2str(i) ''')==1'])))
                %%%(extract only childeren of mapped)
                eval(['samelevel_dic' num2str(j-1) num2str(i) ' = imagegraph.n' num2str(i) '(find(imagegraph.n' num2str(i) '(:,5)==j-1),:);']);% get information of all of the nodes which has level=j in Dic graph =i
                eval(['[test_index,dic_index]=find(parent_mapping'  num2str(j-1) num2str(i) ' == 1);']);
                [indexa,indexbb]=sort(test_index);
                dic_index = dic_index(indexbb);
                parent_id_test = lastlevel_test(find(eval(['ismember(lastlevel_test(:,[8 9]),[samelevel_test(k,[6,7])],''rows'')'])),10);%find parent of current node (test)
                if(~isempty(parent_id_test))
                    
                    parent_id_dic  = dic_index(find(test_index==parent_id_test));
                else
                    parent_id_dic =[];
                end
                if(~isempty(parent_id_dic))
                    %%extract childeren  of mapped
                    virtual_id = eval(['find(ismember(samelevel_dic' num2str(j-1) num2str(i) '(:,10),[parent_id_dic],''rows''));']);
                    if(~isempty(virtual_id))
                        parenty = eval(['samelevel_dic' num2str(j-1) num2str(i) '(' num2str(virtual_id) ',[8])']);
                        parentx = eval(['samelevel_dic' num2str(j-1) num2str(i) '(' num2str(virtual_id) ',[9])']);
                        %   if(samelevel_test(k,4)==1)
                        node_exceed_flag =0;
                    else
                        node_exceed_flag = 1;
                    end
                else
                    node_exceed_flag = 1;
                end
            end
            if(~node_exceed_flag)
                eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '((find(ismember(imagegraph.n' num2str(i) '(:,[5,6,7]),[j,' ...
                    num2str(parenty) ',' num2str(parentx) '],''rows''))),:);']);% get information of all of the nodes which has level=j in Dic graph =i (extract only childeren of mapped)
                eval(['[h1,w1] = size(samelevel_dic' num2str(j) num2str(i) ');']);
                if(samelevel_test(k,4)==2)
                    endpoint_flag =1;
                else
                    endpoint_flag =0;
                end
                for l= [1:h1] %node index in selected graph in Dic
                    subDistance = [];
                    eval( ['targetDic_nodes = samelevel_dic' num2str(j) num2str(i) '(l,:);']); %put node #(l) of graph #(i) level #(j) in targetDic_nodes
                    if(targetDic_nodes(1,4)==2)
                        endpoint_flag =1;
                    end
                    target_node        = samelevel_test(k,:); %put node #(k) of test graph level #(j) in target_node
                    if(1)%it was first_flag
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
                                [sizx,sizy] = size(Distancesubgraphs);
                                if(sizx>sizy)
                                    Distancesubgraphs = [Distancesubgraphs,Inf(sizx,sizx-sizy) ];
                                elseif(sizx<sizy)
                                    Distancesubgraphs = [Distancesubgraphs;Inf(sizy-sizx,sizy) ];
                                end
                                [minDistance,parent_mapping] = munkres( Distancesubgraphs,sizx,sizy);
                                %                       if(~firstlevel_flag)
                                l_id = targetDic_nodes(10);
                                k_id = samelevel_test(k,10);
                                %                       else
                                %                         l_id=l;
                                %                       end
                                Distance(k_id,l_id) = valuemin + sum(minDistance);
                                Distancesubgraphs = [];
                            end
                        else
                            %                       if(~firstlevel_flag)
                            l_id = targetDic_nodes(10);
                            
                            k_id = samelevel_test(k,10);
                            %                       else
                            %                         l_id=l;
                            %                       end
                            Distance(k_id,l_id)      = graph_distance( target_node,targetDic_nodes);
                        end
                        
                        %%%
                        
                    else
                        
                        
                        Distance(k,l)      = graph_distance( target_node,targetDic_nodes);
                        
                    end
                end
            end
        end
        
        
        [sizx,sizy] = size(Distance);
        if(sizx>sizy)
            Distance = [Distance,Inf(sizx,sizx-sizy) ];
        elseif(sizx<sizy)
            Distance = [Distance;Inf(sizy-sizx,sizy) ];
        end
        if(sum(sum((~isinf(Distance))),2)>1)
            [minDistance,parent_mapping] = munkres( Distance,sizx,sizy);
            
            %[minvalue,minindex,minDistance,parent_mapping] = node_mapping( Distance,i);
            eval(['parent_mapping' num2str(j) num2str(i) ' = parent_mapping ;' ]);
            [xxx,yyy] =size(Distance);
            for gg=1:yyy
                if(sum(isinf(Distance(:,gg)))~=xxx)
                    l_total =l_total+1;
                end
            end
            for kk=1:xxx
                if(sum(isinf(Distance(kk,:)))~=yyy)
                    k_total =k_total+1;
                end
            end
            if(l_total>k_total)
                for ee=1:l_total
                    if(any(parent_mapping(:,ee)))
                        eval(['samelevel_dic' num2str(j) num2str(i) ' = imagegraph.n' num2str(i) '(find(imagegraph.n' num2str(i) '(:,5)==j),:);']);% get information of all of the nodes which has level=j in Dic graph =i
                        penRx = eval( ['samelevel_dic' num2str(j) num2str(i) '(ee,1);']);
                        penRy = eval( ['samelevel_dic' num2str(j) num2str(i) '(ee,2);']);
                        penalty(ee) = sqrt(penRx^2+penRy^2);
                    end
                end
            elseif((l_total<k_total))
                for ee=1:k
                    if(any(parent_mapping(ee,:),2))
                        penRx = samelevel_test(ee,1);
                        penRy = samelevel_test(ee,2);
                        penalty(ee) = sqrt(penRx^2+penRy^2);
                    end
                end
            elseif((l_total==k_total))
                penalty = 0;
            end
            penalty = sum(penalty);
            l_total =0;
            k_total =0;
            if(sum(isinf(minDistance))~= length(minDistance))
                samplemindistance(i) = (10/j)*(sum(minDistance(minDistance~=Inf))+penalty);
            end
        else
            samplemindistance(i) =Inf;
        end
    end
    cp_copy_samplemindistance = samplemindistance;
    samplemindistance = copy_samplemindistance + samplemindistance;
    copy_samplemindistance = samplemindistance;
    copy_samplemindistance(isinf(copy_samplemindistance)) = 100000;
    diffdistance = diffdistance-copy_samplemindistance;
    firstlevel_flag  = 0;
    B2=B1;
    I2=I1;
    B1=B;
    I1=I;
    [B,I]             =  sort(copy_samplemindistance);
    firstlevel_flag  = 0;
    
    
    threshold=B(1)*4.1;
    sampleindex_dic  = I(1:ceil(3*length(sampleindex_dic)/4));
    %    if(sum(~isinf(B))<length(sampleindex_dic))
    %     sampleindex_dic = sampleindex_dic(~isinf(B));
    %    end
    samplemindistance = Inf(1,imagegraph.lastindex);
    (graph_vote(1)-samplemindistance(1))   ;
    graph_vote(i)     = samplemindistance(i);
    Distance = [];
    %    if(isempty(q))
    %    q= B(1)-0.0002;
    %    end
    if(j >2)
        if(length(sampleindex_dic)==1 || maxnode_test == j-1 ||(( length(find(B~=1e5))<=3)&& (I(1)==I2(1))))
            %          B1
            %          I1
            %          B
            %          I
            %    % if(numel(sampleindex_dic))
            fprintf('matched graph is : %d\n',round(I(1)));
            %    % end
            result.j = j
            result.distance =diffdistance;% 1000000*ones(1,imagegraph.lastindex)-diffdistance;
            %    %    result.elapsedtime = toc;
            %     [qqq,ppp]=sort(result.distance);
            break
        end
    end
    %   q=B(1)/B();
end


end


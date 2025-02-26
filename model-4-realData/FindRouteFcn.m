function [dist, path] = FindRouteFcn (GraphMatrix , IntersectionsList,  OriginNode, DestinNode)


%% find closest path

[dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Dijkstra');

[dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode);

%[dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Bellman-Ford');

%[dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Acyclic');



%% show biograph

if(false)
    % This finds handles to all the objects in the current session, 
    % filters it to find just the handles to the Biograph Viewers so that they can be selectively closed.
    child_handles = allchild(0);
    names = get(child_handles,'Name');
    k = find(strncmp('Biograph Viewer', names, 15));
    close(child_handles(k))
    
    NoIntersections = size(IntersectionsList,2);

    %create IDs vector
    ids=cell(1,NoIntersections);
    for i=1:NoIntersections
        ids(1,i) ={int2str(i)};
    end


    %h = view(biograph(GraphMatrix,[],'ShowArrows','on','ShowWeights','on', 'LayoutScale', .2));
    h = view(biograph(GraphMatrix,ids,'ShowArrows','off','ShowWeights','on', 'LayoutScale', .2));

    %set node positions as in the city map
    for i = 1:NoIntersections
    set(h.Nodes(i),'Position',...
       [IntersectionsList(i).x,...
        IntersectionsList(i).y]);
    end

    dolayout(h,'pathsOnly',true)

    % 
    %Show path on graph
    set(h.Nodes(path),'Color',[1 0.4 0.4])
    fowEdges = getedgesbynodeid(h,get(h.Nodes(path),'ID'));
    revEdges = getedgesbynodeid(h,get(h.Nodes(fliplr(path)),'ID'));
    edges = [fowEdges;revEdges];
    set(edges,'LineColor',[1 0 0])
    set(edges,'LineWidth',1.5)
end

end


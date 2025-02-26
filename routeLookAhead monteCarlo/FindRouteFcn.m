function [dist, path] = FindRouteFcn (GraphMatrix , IntersectionsList,  OriginNode, DestinNode, algorithm)

NoIntersections = size(IntersectionsList,2);

switch (algorithm)
    case 'Dijkstra'
        [dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Dijkstra');
    case 'Bellman-Ford'
        [dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Bellman-Ford');
    case 'Acyclic'
        [dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Acyclic');
    otherwise
        [dist,path,~] = graphshortestpath(GraphMatrix,OriginNode,DestinNode,'directed',false, 'Method','Dijkstra');
end


end


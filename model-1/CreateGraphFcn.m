function [ GraphMatrix ] = CreateGraphFcn( IntersectionsList, SignalMatrix)

%%% IntersectionsListExample = struct('x',{},'y',{},'con1',{},'con2',{},'con3',{});

NoIntersections = size(IntersectionsList,2);

SNames = fieldnames(IntersectionsList);     %save struct field names

MaxConnections = size(SNames, 1) - 2;

n = 1;

GraphCon1 = [];
GraphCon2 = [];
GraphConW = [];


for i=1:NoIntersections
    for j=3:numel(SNames) 
        temp = IntersectionsList(i).(SNames{j});
        if (~isempty (temp))
           GraphCon1 = [GraphCon1   i];
           GraphCon2 = [GraphCon2   temp];
           
           p1 = [IntersectionsList(i).x     IntersectionsList(i).y];
           p2 = [IntersectionsList(temp).x  IntersectionsList(temp).y];
           
           [average,~,~,distance,grade] = SignalPathFcn(p1,p2,SignalMatrix);
           
           
           weight = grade;
           
           GraphConW = [GraphConW   weight];
        end
        
    end
end

if min(GraphConW) < 0
    GraphConW = GraphConW + abs(min(GraphConW));
end

GraphMatrix = sparse(GraphCon1,GraphCon2,GraphConW);

GraphMatrix = tril(GraphMatrix);
    
end

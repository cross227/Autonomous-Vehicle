coverage = ResultMatrix;

expansionLength = 100;  % side length of each coverage map

updateDistance = 4;     % number of intersections to drive before getting a new coverage map

sizeX = size(coverage,2);
sizeY = size(coverage,1);

tempPath = [];
drivenPath = [];
handler = [];

for k=1:size(path,2)
    
    if( rem (k, updateDistance) == 1)
        thisNode = path(k);
        thisX = IntersectionsList(thisNode).x;
        thisY = IntersectionsList(thisNode).y;

        %define map limit coordinates
        maxX = thisX + floor(expansionLength/2);
        minX = thisX - floor(expansionLength/2);
        maxY = thisY + floor(expansionLength/2);
        minY = thisY - floor(expansionLength/2);

        %check for out matrix borders conditions
        maxX = min(maxX, sizeX);
        minX = max(minX, 1);
        maxY = min(maxY, sizeY);
        minY = max(minY, 1);

        %apply mask over coverage
        tempCoverage = ones(sizeY,sizeX);
        for i=minY:maxY
            for j=minX:maxX
                tempCoverage(i,j) = coverage(i,j);
            end
        end
        
        %create new graph
        [tempGraph, NoEdges, NoIntersections] = CreateGraphFcn( IntersectionsList, tempCoverage);
        %find new route
        [dist, newPath] = FindRouteFcn (tempGraph , IntersectionsList, thisNode, DestinNode);
            
        %show tempCoverage
        figure(1)
        hold on;
        if(~isempty(handler))
            delete(handler);
        end
        handler=imagesc(tempCoverage);
        set(gca,'YDir','normal')
    
        newPath = [drivenPath   newPath ];
        
        for i=1:size(newPath,2)
            thisNode = newPath(i);
            thisX = IntersectionsList(thisNode).x;
            thisY = IntersectionsList(thisNode).y;
            scatter(thisX, thisY,'or','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',2.5);
        end
    end
    
    drivenPath = [drivenPath    path(k)];
        
    %plot path over tempCoverage
    for i=1:k
        thisNode = path(i);
        thisX = IntersectionsList(thisNode).x;
        thisY = IntersectionsList(thisNode).y;
        scatter(thisX, thisY,'.w');
    end
    
    pause(.1);
end



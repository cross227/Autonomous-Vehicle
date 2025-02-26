function [avSig, signalVector, avUnd, undVector ] = RouteLookAhead3 (coverage, graphMatrix, intersectionsList, originNode, destinNode, partialMapSideLength, updateDistance, plotResults, algorithm)


%%INPUT VARIABLES
% coverage: matrix with the coverage heat map values
% graphMatrix: graph that represents the intersections and their
%              connections and weights
% intersectionsList:    struct with intersections and connections between
%                       them
% originNode:
% destinNode:
% partialMapSideLength: desired size for partial map on this process,
%                       measured in points
% updateDistance:   number of intersections to drive before getting a new coverage map  
% plotResults:      plot maps and routes along path or not (true / false)
% algorithm:        'Dijkstra', Bellman-Ford' or 'Acyclic'

%%OUTPUT VARIABLES
% avUnd:    average undesirability along the path
% avSig:    average signal value along the path


sizeX = size(coverage,2);
sizeY = size(coverage,1);

tempPath = [];
drivenPath = [];
 
tempGraph = graphMatrix;

[dist, newPath] = FindRouteFcn (tempGraph , intersectionsList, originNode, destinNode, algorithm);
     
if (plotResults == true)
    figure(1)
    clf
end

arrived = false;
k = 1;
while(~arrived)
    
    if( rem (k, updateDistance) == 1)
        thisNode = newPath(k);
        thisX = intersectionsList(thisNode).x;
        thisY = intersectionsList(thisNode).y;

        %define map limit coordinates
        maxX = thisX + floor(partialMapSideLength/2);
        minX = thisX - floor(partialMapSideLength/2);
        maxY = thisY + floor(partialMapSideLength/2);
        minY = thisY - floor(partialMapSideLength/2);

        %check for out matrix borders conditions
        maxX = min(maxX, sizeX);
        minX = max(minX, 1);
        maxY = min(maxY, sizeY);
        minY = max(minY, 1);

        %apply mask over coverage
        tempCoverage = 1000*ones(sizeY,sizeX);
        
        for i=minY:maxY
            for j=minX:maxX
                tempCoverage(i,j) = coverage(i,j);
            end
        end
        
        %create new graph
        [tempGraph, NoEdges, NoIntersections] = CreateGraphFcn( intersectionsList, tempCoverage);
        %find new route
        [dist, newPath] = FindRouteFcn (tempGraph , intersectionsList, thisNode, destinNode,algorithm);
         
        newPath = [drivenPath   newPath ];
        
        %show tempCoverage
        if (plotResults == true)
            figure(1)
            imagesc(tempCoverage);
            hold on;
            set(gca,'YDir','normal')

            for i=1:size(newPath,2)
                thisNode = newPath(i);
                thisX = intersectionsList(thisNode).x;
                thisY = intersectionsList(thisNode).y;
                scatter(thisX, thisY,'or','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',2.5);
            end
        end
    end
    
    drivenPath = [drivenPath    newPath(k)];
        
    %plot path over tempCoverage
    if (plotResults == true)
        for i=1:k
            thisNode = drivenPath(i);
            thisX = intersectionsList(thisNode).x;
            thisY = intersectionsList(thisNode).y;
            scatter(thisX, thisY,'.w');
        end
        %pause(.1);
    end
    
    
    
    if (drivenPath(k)==destinNode)
        arrived = true;
    end
    k = k+1;
end

%% Plot optimum path
if (plotResults == true)
    [dist, originalPath] = FindRouteFcn (graphMatrix , intersectionsList, originNode, destinNode,algorithm);
    for i=1:size(originalPath,2)
        thisNode = originalPath(i);
        thisX = intersectionsList(thisNode).x;
        thisY = intersectionsList(thisNode).y;
        scatter(thisX, thisY,'.g');
    end
end



[signalVector, undVector] = EvaluatePathFcn( drivenPath, intersectionsList, coverage, coverage );
avUnd = mean(undVector);
avSig = mean(signalVector);

end


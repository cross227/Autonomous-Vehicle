


coverage = ResultMatrix;

 OriginNode = 1000;
% 
 DestinNode = 1;

expansionLength = 150;  % side length of each coverage map

updateDistance = 4;     % number of intersections to drive before getting a new coverage map

sizeX = size(coverage,2);
sizeY = size(coverage,1);

tempPath = [];
drivenPath = [];
handler = [];

plotResults = true;

[dist, originalPath] = FindRouteFcn (GraphMatrix , IntersectionsList, OriginNode, DestinNode);
 
tempGraph = GraphMatrix;

[dist, newPath] = FindRouteFcn (tempGraph , IntersectionsList, OriginNode, DestinNode);
     
if (plotResults == true)
    figure(1)
    clf
end

arrived = false;
k = 1;
while(~arrived)
    
    if( rem (k, updateDistance) == 1)
        thisNode = newPath(k);
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
         
        newPath = [drivenPath   newPath ];
        
        %show tempCoverage
        if (plotResults == true)
            figure(1)
            clf
            handler=imagesc(tempCoverage);
            hold on;
            set(gca,'YDir','normal')

            for i=1:size(newPath,2)
                thisNode = newPath(i);
                thisX = IntersectionsList(thisNode).x;
                thisY = IntersectionsList(thisNode).y;
                %scatter(thisX, thisY,'or','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',2.5);
            end
        end
    end
    
    drivenPath = [drivenPath    newPath(k)];
        
    %plot path over tempCoverage
    if (plotResults == true)
        xVec = [];
        yVec = [];
        for i=1:k
            thisNode = drivenPath(i);
            thisX = IntersectionsList(thisNode).x;
            thisY = IntersectionsList(thisNode).y;
            xVec = [xVec    thisX];
            yVec = [yVec    thisY];
        end
        plot(xVec,yVec,'--k','LineWidth',3);
        
        thisX = IntersectionsList(OriginNode).x;
        thisY = IntersectionsList(OriginNode).y;
        text(thisX+5,thisY-12,'A','BackgroundColor','w','FontSize',15,'FontWeight','bold');

        thisX = IntersectionsList(DestinNode).x;
        thisY = IntersectionsList(DestinNode).y;
        text(thisX,thisY+10,'B','BackgroundColor','w','FontSize',15,'FontWeight','bold');
   
    
        pause(.1);
    end
    
    
    
    if (drivenPath(k)==DestinNode)
        arrived = true;
        break;
    end
    k = k+1;
end

%% Plot optimum path

            
if (plotResults == true)
    figure(1)
    clf
    handler=imagesc(tempCoverage);
    hold on;
    set(gca,'YDir','normal')
    colorbar;
    plot(xVec,yVec,'--k','LineWidth',3);
    
    xVec2 = [];
    yVec2 = [];
    for i=1:size(originalPath,2)
        thisNode = originalPath(i);
        thisX = IntersectionsList(thisNode).x;
        thisY = IntersectionsList(thisNode).y;
        xVec2 = [xVec2    thisX];
        yVec2 = [yVec2    thisY];
    end    
    plot(xVec2,yVec2,'dg','LineWidth',2,'MarkerSize',6, 'MarkerEdgeColor','g',...
                       'MarkerFaceColor','k');
                   
                   
    thisX = IntersectionsList(OriginNode).x;
    thisY = IntersectionsList(OriginNode).y;
    text(thisX+5,thisY-12,'A','BackgroundColor','w','FontSize',15,'FontWeight','bold');
    
    thisX = IntersectionsList(DestinNode).x;
    thisY = IntersectionsList(DestinNode).y;
    text(thisX,thisY+10,'B','BackgroundColor','w','FontSize',15,'FontWeight','bold');
        
    %title('Adaptive routing with partial known coverage map (A -> B)');
    legend('Partial routing','Full map routing (reference)','Location','SouthEast');
    
end



[SignalVector, UndesirabilityVector] = EvaluatePathFcn( drivenPath, IntersectionsList, ResultMatrix, Coverage_matrix );
AvUnd = mean(UndesirabilityVector)'
AvSig = mean(SignalVector)'


function [SignalVectorDj, UndesirabilityVectorDj, SignalVectorAc, UndesirabilityVectorAc] = testbench( )

clear all
%% Generate city with intersections
dimension = 500;    %size of full map in points
width = 5;
buildings = 15;

cityMap  = SquareCity2Fcn(dimension,width,buildings)
disp('---City map finished');

[~, intersectionsList] = FindIntersectionsFcn( cityMap, width, buildings )
disp('---Intersection List finished');


%% Set fixed parameters for routing executions
OriginNode = 1000; % starting point

DestinNode = 1; % stop point 

updateDistance = 4;     % number of intersections to drive before getting a new coverage map

plotResults = false;    %disable printing results

lengthVector = 50:5:400;    %vector with all possible side map lengths to be tested


%% 

%[dist, originalPath] = FindRouteFcn (graphMatrix , IntersectionsList, OriginNode, DestinNode,'Dijkstra');

%algorithm = 'Dijkstra';

undVector = [];
sigVector  = [];



%define new side length
partialMapSideLength = 100;  % side length of each partial coverage map
    
%loop with different random coverage values

    %create new coverage 
    
    %update graph with new coverage
    pos_antennas = [.4 .6; .7 .4 ; .1 .1];

    %coverage=CoverageFcn(pos_antennas,cityMap,width,buildings);
    coverage = 0.5 * abs(randn(500));
    [graphMatrix, NoEdges, NoIntersections] = CreateGraphFcn( intersectionsList, coverage );
    disp('---Graph matrix finished');

    % find the original route with no heatmap
    [dist1,originalPath]=FindRouteFcn (graphMatrix , intersectionsList,  OriginNode, DestinNode, 'Dijkstra')
    
    
    
    %find route
    [AvUnd, AvSig] = RouteLookAhead3 (coverage, graphMatrix, intersectionsList, ...
OriginNode, DestinNode, partialMapSideLength, updateDistance, plotResults, 'Dijkstra');
    
    %save results for this route generation
    %undVector(t) = AvUnd;
    %sigVector (t) = AvSig;
    
    %find route with other algorithms if desired, and save results
   
%end of loop for this random coverage, do again for next one



%evaluate optimum possible path
[SignalVectorDj, UndesirabilityVectorDj] = EvaluatePathFcn( originalPath, intersectionsList, coverage, coverage);
%AvUndFull = mean(UndesirabilityVector)
%AvSigFull = mean(SignalVector)

 %find route
    [AvUnd, AvSig] = RouteLookAhead3 (coverage, graphMatrix, intersectionsList, ...
OriginNode, DestinNode, partialMapSideLength, updateDistance, plotResults, 'Acyclic');
    
    %save results for this route generation
    %undVector(t) = AvUnd;
    %sigVector (t) = AvSig;
    
    %find route with other algorithms if desired, and save results
   
%end of loop for this random coverage, do again for next one



%evaluate optimum possible path
[SignalVectorAc, UndesirabilityVectorAc] = EvaluatePathFcn( originalPath, intersectionsList, coverage, coverage);
%AvUndFull = mean(UndesirabilityVector)
%AvSigFull = mean(SignalVector)



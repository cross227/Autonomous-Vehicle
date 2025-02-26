%function [SignalVectorDj, UndesirabilityVectorDj, SignalVectorAc, UndesirabilityVectorAc] = testbench( )

clear all
%% Generate city with intersections
dimension = 400;    %size of full map in points
width = 5;
buildings = 15;

cityMap  = SquareCity2Fcn(dimension,width,buildings);
disp('---City map finished');

[~, intersectionsList] = FindIntersectionsFcn( cityMap, width, buildings );
disp('---Intersection List finished');


%% Set fixed parameters for routing executions
OriginNode = size (intersectionsList,2);    % starting point

DestinNode = 1; % stop point 

updateDistance = 4;     % number of intersections to drive before getting a new coverage map

plotResults = false;    %disable printing results

%lengthVector = [10 100 200 300] ;    %vector with all possible side map lengths to be tested
lengthVector = [400 500 600 700 800] ;    %vector with all possible side map lengths to be tested

numberOfRuns = 1000;      %ammount of random runs for each 
    
%% run iteractions


for partialMapSideLength = lengthVector

    %define new side length
    disp(sprintf('\n\n\tPartial map side length =  %d \t\t**',partialMapSideLength));    
    
    
    %loop with different random coverage map values
    for run=1:numberOfRuns
        disp(sprintf('\n\tRun = %d',run));
        %create new coverage 
        rng('shuffle');
        coverage = 100 * abs(randn(dimension));

        [graphMatrix, NoEdges, NoIntersections] = CreateGraphFcn( intersectionsList, coverage );

        % find the optimum route using the full heat map
        [dist,originalPath]=FindRouteFcn (graphMatrix , intersectionsList,  OriginNode, DestinNode, 'Dijkstra');
        [optSignalVector, optUndVector] = EvaluatePathFcn( originalPath, intersectionsList, coverage, coverage);

        %find route Dijkstra
        [~, ~, dijAvUnd, dijUndVector] = RouteLookAhead3 (coverage, graphMatrix, intersectionsList, ...
        OriginNode, DestinNode, partialMapSideLength, updateDistance, plotResults, 'Dijkstra');

        %find route Acyclic
        [~, ~, acyAvUnd, acyUndVector] = RouteLookAhead3 (coverage, graphMatrix, intersectionsList, ...
        OriginNode, DestinNode, partialMapSideLength, updateDistance, plotResults, 'Acyclic'); 

    %save and show results for this route generation
        optMonteCarloVector(run) = sum(optUndVector);
        disp(sprintf('Opt distance: \t %f',optMonteCarloVector(run)));

        dijMonteCarloVector(run) = sum(dijUndVector);
        disp(sprintf('Dij distance: \t %f',dijMonteCarloVector(run)));

        belMonteCarloVector(run) = sum(belUndVector);
        disp(sprintf('Bel distance: \t %f',belMonteCarloVector(run)));
        
        acyMonteCarloVector(run) = sum(acyUndVector);
        disp(sprintf('Acy distance: \t %f',acyMonteCarloVector(run)));

    end      %end of loop for this random coverage, do again for next one
   

    %save temporary Monte Carlo vectors for this fixed side map length
    variableName=sprintf('optMonteCarloVector%d', partialMapSideLength);
    assignin('base',variableName,optMonteCarloVector);
    
    variableName=sprintf('dijMonteCarloVector%d', partialMapSideLength);
    assignin('base',variableName,dijMonteCarloVector);

    variableName=sprintf('belMonteCarloVector%d', partialMapSideLength);
    assignin('base',variableName,belMonteCarloVector);
    
    variableName=sprintf('acyMonteCarloVector%d', partialMapSideLength);
    assignin('base',variableName,acyMonteCarloVector);
end


%% plot results

i=1;
for partialMapSideLength=lengthVector
    
    variableName=sprintf('optMonteCarloVector%d', partialMapSideLength);
    eval(['thisVector =',variableName,';']);
    optResult(i) = mean(thisVector);
    
    variableName=sprintf('dijMonteCarloVector%d', partialMapSideLength);
    eval(['thisVector =',variableName,';']);
    dijResult(i) = mean(thisVector);
    
    variableName=sprintf('belMonteCarloVector%d', partialMapSideLength);
    eval(['thisVector =',variableName,';']);
    belResult(i) = mean(thisVector);
        
    variableName=sprintf('acyMonteCarloVector%d', partialMapSideLength);
    eval(['thisVector =',variableName,';']);
    acyResult(i) = mean(thisVector);
    
    length(i) = partialMapSideLength;
    i = i+1;
end

length = length/(2*dimension);

% figure(2);
% clf;
% hold on;
% plot(length,belResult,'m');
% plot(length,acyResult,'g');
% plot(length,djiResult,'b');
% plot(length,optResult,'r');
% legend('Bellman-Ford','Acyclic','Dijkstra','Optimum')

% figure(3)
% clf
% hold on

% plot(length,2-belResult./optResult,'m');
% plot(length,2-dijResult./optResult,'b')
% plot(length,2-acyResult./optResult,'g')
% plot(length,2-optResult./optResult,'r')
% legend('Bellman-Ford','Dijkstra','Acyclic','Optimum','Location','East')
% ylim([0.77 1.01]);
% xlabel('Relation between full map and partial map sizes')
% ylabel('Relation between optimum path and paths with partial routing')

%data interpolation
opt2=[];
bel2=[];
dij2=[];
acy2=[];
length2 = [];
for i=0:0.02:1
    opt2 = [opt2  pchip(length,2-optResult./optResult,i)];
    bel2 = [bel2  pchip(length,2-belResult./optResult,i)];
    dij2 = [dij2  pchip(length,2-dijResult./optResult,i)];
    acy2 = [acy2  pchip(length,2-acyResult./optResult,i)];
    
    length2 = [length2 i];
end

figure(1)
clf;
hold on;
%plot(length2,bel2,'om','LineWidth',2,'MarkerSize',6);
plot(length2,dij2,'--b','LineWidth',2);
%plot(length2,acy2,'-.g','LineWidth',2);
plot(length2,opt2,'-r','LineWidth',2);
legend('Adaptive routing','Optimum','Location','East')
ylim([0.77 1.01]);
xlabel('Relation between partial map and full map sizes')
ylabel('Relation between paths with partial routing and optimum path')
%title('Analysis of partial map`s size effect over performance');
grid

% Convert y-axis and x-axis values to percentage values
a=[cellstr(num2str(get(gca,'ytick')'*100))]; 
pct = char(ones(size(a,1),1)*'%'); 
new_yticks = [char(a),pct];
set(gca,'yticklabel',new_yticks) 
a=[cellstr(num2str(get(gca,'xtick')'*100))]; 
pct = char(ones(size(a,1),1)*'%'); 
new_xticks = [char(a),pct];
set(gca,'xticklabel',new_xticks) 

%%

%save('part2.mat');


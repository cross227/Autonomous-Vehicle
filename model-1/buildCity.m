
close all;

pos_antennas = [.5 .5; .8 .3];
pos_antennas = [.5 .5; .25 .25];

dimension = 240;

width = 5;
buildings = 15;

%--------------------------------------------------------------------


% CityMap  = SquareCity2Fcn(dimension,width,buildings);
% disp('---City map finished');
% 
% Coverage_matrix  = CoverageFcn(pos_antennas,CityMap,width,buildings);
% disp('---Coverage matrix finished');
% 
% [IntersectionsMap, IntersectionsList] = FindIntersectionsFcn( CityMap, width, buildings );
% disp('---Intersection List finished');
% 
 GraphMatrix = CreateGraphFcn( IntersectionsList, Coverage_matrix );
% disp('---Graph matrix finished');

%%  Create Biograph

% http://www.mathworks.com/matlabcentral/answers/663-problem-with-biograph-layout

OriginNode = 1;
DestinNode = 790;
if DestinNode > size (IntersectionsList,2)
    DestinNode = size (IntersectionsList,2);
end

[dist, path] = FindRouteFcn (GraphMatrix , IntersectionsList, OriginNode, DestinNode);
disp('--Routing finished');

%% Plot City Map

figure(1)
clf
imagesc(CityMap) 
colorbar
set(gca,'YDir','normal')

hold on


%% plot intersections

c = cell(size (IntersectionsList , 2) ,2);                  %create cell array
[c{:,:}] = deal(IntersectionsList.x , IntersectionsList.y); %save values
a = cell2mat(c);                                            %convert to double
scatter(a(:,1),a(:,2), '*','r');


%% Plot Coverage matrix

if(true)
    figure(2)
    imagesc(Coverage_matrix) 
    colorbar
    set(gca,'YDir','normal')
end

%% Plot path over coverage matrix
pathX = zeros(1,size(path,2));
pathY = zeros(1,size(path,2));

figure(2)
hold on

for i=1:size(path,2)    %save [x y] points on vectors pathX and pathY
    pathX(i) = IntersectionsList(path(i)).x;
    pathY(i) = IntersectionsList(path(i)).y;
    
    text(pathX(i) + 3, pathY(i) + 4, int2str(path(i)));
end

plot(pathX,pathY,'--ko',...
    'LineWidth',2,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','w');


%% Show graphs to evaluate path
[SignalVector, EdgeSignalVector] = EvaluatePathFcn( path, IntersectionsList, Coverage_matrix );

if min(EdgeSignalVector) < 0
    EdgeSignalVector = EdgeSignalVector +abs(min(EdgeSignalVector));
end

figure(3)
x1 = 1:size(SignalVector,2);

x2 = 1:size(EdgeSignalVector,2);

plotyy (x1,SignalVector,x2,EdgeSignalVector);

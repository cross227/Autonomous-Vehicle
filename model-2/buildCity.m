
%close all;

pos_antennas = [.4 .6; .8 .3];
%pos_antennas = [.4 .6; .7 .4 ; .1 .1];

dimension = 300;

width = 5;
buildings = 15;

%--------------------------------------------------------------------
if (0)   
    %CityMap  = SquareCity2Fcn(dimension,width,buildings);
    disp('---City map finished');

    [IntersectionsMap, IntersectionsList] = FindIntersectionsFcn( CityMap, width, buildings );
    disp('---Intersection List finished');

    Coverage_matrix  = CoverageFcn(pos_antennas,CityMap,width,buildings);
    disp('---Coverage matrix finished');


%     GraphMatrix = CreateGraphFcn( IntersectionsList, Coverage_matrix );
%     disp('---Graph matrix finished');
end

%% coverage evaluation test

% lowLimit = -36;
% highLimit  = -30;


lowLimit = -60;
highLimit  = -40;

% lowLimit = -135;
% highLimit  = -40;

ResultMatrix = zeros(size(Coverage_matrix,1),size(Coverage_matrix,2));

for i = 1:size(Coverage_matrix,1)
    for j=1:size(Coverage_matrix,2)
        
        value = Coverage_matrix(i,j);
        
        if value < lowLimit
            ResultMatrix(i,j) = 1;
        elseif value > highLimit
            ResultMatrix(i,j) = 0;
        else
            ResultMatrix(i,j) = 1 - (( value - lowLimit)/(highLimit - lowLimit)) ;
        end
    end
end

[GraphMatrix, NoEdges, NoIntersections] = CreateGraphFcn( IntersectionsList, ResultMatrix );
disp('---Graph matrix finished');

if(true)
    figure(5)
    imagesc(ResultMatrix) 
    colorbar
    set(gca,'YDir','normal')
end


ResultMatrix = zeros(size(Coverage_matrix,1),size(Coverage_matrix,2));

for i = 1:size(Coverage_matrix,1)
    for j=1:size(Coverage_matrix,2)
        
        value = Coverage_matrix(i,j);
        
        if value < lowLimit
            ResultMatrix(i,j) = 1;
        elseif value > highLimit
            ResultMatrix(i,j) = 0;
        else
            ResultMatrix(i,j) = 1 - (( value - lowLimit)/(highLimit - lowLimit)) ;
            
            
            
        end
    end
end

[GraphMatrix, NoEdges, NoIntersections] = CreateGraphFcn( IntersectionsList, ResultMatrix );
disp('---Graph matrix finished');


figure(5)
imagesc(ResultMatrix) 
colorbar
set(gca,'YDir','normal')


%% 

%%  Create Biograph ad route


OriginNode = 369;
DestinNode = 292;

if DestinNode > size (IntersectionsList,2)
    DestinNode = size (IntersectionsList,2);
end

if OriginNode > size (IntersectionsList,2)
    OriginNode = size (IntersectionsList,2);
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
    clf
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
[SignalVector, UndesirabilityVector] = EvaluatePathFcn( path, IntersectionsList, ResultMatrix, Coverage_matrix );

figure(3)
x1 = 1:size(SignalVector,2);

x2 = 1:size(UndesirabilityVector,2);

[hAx,hLine1,hLine2] = plotyy (x1,SignalVector,x2,UndesirabilityVector);

title('Signal strength and Undesirability')
xlabel('Traveled distance (in meters)')

ylabel(hAx(1),'Signal strength') % left y-axis
ylabel(hAx(2),'Normalized Undesirability') % right y-axis

AvUnd = mean(UndesirabilityVector);
AvSig = mean(SignalVector);

disp(sprintf('Average undesirability = %f',AvUnd))
disp(sprintf('Average signal = %f',AvSig))

%% variables

scale = 10;

OriginNode = 117;
DestinNode = 57;

%limit points to desired area
latMinLimit = 32235800;
latMaxLimit = 32245000;
longMinLimit = -110969440;
longMaxLimit = -110959255;

%latMinLimit = -inf;
%latMaxLimit = inf;
longMinLimit = -inf;
longMaxLimit = inf;

latLimits = [latMinLimit     latMaxLimit ];
longLimits = [longMinLimit   longMaxLimit];

%% load coverage data

%[coverage, longitude, latitude, rssi, minLong, minLat] = CoverageFcn( 'data4G.csv', latLimits, longLimits, scale);
%[coverage, longitude, latitude, rssi, minLong, minLat] = CoverageFcn( 'data2G.csv', latLimits, longLimits, scale);

%[coverage, longitude, latitude, rssi, minLong, minLat] = CoverageFcn( 'data2G-trip2.csv', latLimits, longLimits, scale);
%[coverage, longitude, latitude, rssi, minLong, minLat] = CoverageFcn( 'data3G-trip2.csv', latLimits, longLimits, scale);
%[coverage, longitude, latitude, rssi, minLong, minLat] = CoverageFcn( 'data4G-trip2.csv', latLimits, longLimits, scale);


%% load intersections list

%[intersectionsList, graphMatrix] = CreateGraphFcn('intersectionsList.txt', minLong, minLat, scale, coverage,'grade');

%[intersectionsList, graphMatrix] = CreateGraphFcn('intersectionsList2.txt', minLong, minLat, scale, coverage,'grade');

%[intersectionsList, graphMatrix] = CreateGraphFcn('intersectionsList3.txt', minLong, minLat, scale, coverage,'grade');

%% find route using signal strength

if DestinNode > size (intersectionsList,2)
    DestinNode = size (intersectionsList,2);
end

[dist, path] = FindRouteFcn (graphMatrix , intersectionsList,  OriginNode, DestinNode);

%% find route based just in distance
[intersectionsListDistance, graphMatrixDistance] = CreateGraphFcn('intersectionsList3.txt', minLong, minLat, scale, coverage,'distance');
[distDistance, pathDistance] = FindRouteFcn (graphMatrixDistance , intersectionsListDistance,  OriginNode, DestinNode);

%% plot 

figure(2)
clf
imagesc(coverage)
colorbar
set(gca,'YDir','normal')

maxc = max(max(coverage(coverage~=0))) + 2;
minc = min(min(coverage));
c = [jet(maxc-minc) ; ones(abs(maxc),3)];
colormap(c);


maxc = max(max(coverage)) + 2;
minc = min(min(coverage(coverage~=-200)));
c = [ones(abs(200+minc),3); jet(maxc-minc)];
colormap(c);


%% Plot path over coverage matrix
pathX = zeros(1,size(path,2));
pathY = zeros(1,size(path,2));

figure(2)
hold on

for i=1:size(path,2)    %save [x y] points on vectors pathX and pathY
    pathX(i) = intersectionsList(path(i)).x;
    pathY(i) = intersectionsList(path(i)).y;
    
    text(pathX(i) + 25, pathY(i) + 25, int2str(path(i)));
end

plot(pathX,pathY,'--ko',...
    'LineWidth',2,...
    'MarkerSize',6,...
    'MarkerEdgeColor','w',...
    'MarkerFaceColor','w');
hold off

%% Plot path over real data map
figure(4)
clf
hold on

c = jet(size(unique(rssi),1));
hSignal = gscatter(longitude/1000000,latitude/1000000,rssi,c,'.',8);    %plot real signal data

%                     PLOT PATH DEFINED USING SIGNAL STRENGTH =============

%save [x y] points on vectors pathX and pathY
for i=1:size(path,2)    
    pathX(i) = intersectionsList(path(i)).xGPS;
    pathY(i) = intersectionsList(path(i)).yGPS;
    
    %t = text(pathX(i) + .0001 , pathY(i)+.0005, int2str(path(i)),'FontWeight','bold');
end
clear t;

%plot path
hGrade = plot(pathX,pathY,'--ko',...
    'LineWidth',2.3,...
    'MarkerSize',9,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','w');

%                     PLOT PATH DEFINED USING JUST DISTANCE ===============

%save [x y] points on vectors pathX and pathY
for i=1:size(pathDistance,2)    
    pathXDistance(i) = intersectionsList(pathDistance(i)).xGPS;
    pathYDistance(i) = intersectionsList(pathDistance(i)).yGPS;
    
    %t = text(pathXDistance(i) + .0001 , pathYDistance(i)+.0005, int2str(pathDistance(i)),'FontWeight','bold');
end
clear t;

%plot path
hDistance = plot(pathXDistance,pathYDistance,'--kd',...
    'LineWidth',2.3,...
    'MarkerSize',8,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','w');

thisX = intersectionsList(OriginNode).xGPS;
thisY = intersectionsList(OriginNode).yGPS;
text(thisX+0.001,thisY,'A','BackgroundColor','w','FontSize',15,'FontWeight','bold');

thisX = intersectionsList(DestinNode).xGPS;
thisY = intersectionsList(DestinNode).yGPS;
text(thisX,thisY+0.001,'B','BackgroundColor','w','FontSize',15,'FontWeight','bold');
        

    
%set up graph
legend ([hDistance,hGrade],'Based on distance','Including signal strength')
legend('off')
legend('toggle')

title('Colected 4G signal strength (dBm) and multiple routes (A -> B)')
xlabel('Longitude')
ylabel('Latitude') % y-axis


plot_google_map
hold off

%% Save final path with GPS coordinates

pathGPS = struct('lat',{},'long',{},'rssi',{});

for i=1:size(path,2)
    this = path(i);
    pathGPS(i).lat = intersectionsList(this).yGPS;
    pathGPS(i).long = intersectionsList(this).xGPS;
    
    if i == size(path,2)
        break
    else
        next = path(i + 1);
        
        p1 = [intersectionsList(this).x     intersectionsList(this).y];
        p2 = [intersectionsList(next).x  intersectionsList(next).y];        

        [average,~,~,distance,grade] = SignalPathFcn(p1,p2,coverage);
        
        pathGPS(i).rssi = grade;
    end
    
end


%% Show graphs to evaluate path
[SignalVector, UndesirabilityVector] = EvaluatePathFcn( path, intersectionsList, coverage, coverage );

figure(3)
x1 = 1:size(SignalVector,2);

x2 = 1:size(UndesirabilityVector,2);

[hAx,hLine1,hLine2] = plotyy (x1,SignalVector,x2,UndesirabilityVector);

title('Signal strength and Undesirability along path')
xlabel('Traveled distance (in meters)')

ylabel(hAx(1),'Signal strength') % left y-axis
ylabel(hAx(2),'Normalized Undesirability') % right y-axis

AvUnd = mean(UndesirabilityVector);
AvSig = mean(SignalVector);

disp(sprintf('Average undesirability = %f',AvUnd))
disp(sprintf('Average signal = %f',AvSig))

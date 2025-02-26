function [intersectionsList, graphMatrix] = CreateGraphFcn( fileName, minLong, minLat, scale, coverage, criterion)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%load intersections list
M = dlmread(fileName);

ids = M(:,1);
latInter=M(:,2);
longInter = M(:,3);
con1 = M(:,4);
con2 = M(:,5);
clear M;

noIntersections = size(latInter,1);

intersectionsList = struct('x',{},'y',{},'xGPS',{},'yGPS',{},'con1',{},'con2',{},'con3',{},'con4',{});

for j=1:noIntersections
    
    i = ids(j);
    
    thisLong = longInter(i) * 1000000;
    thisLat = latInter(i) * 1000000;
    
    thisX = floor((thisLong - minLong)/scale ) +1;
    thisY = floor((thisLat - minLat)/scale ) +1;
    
    intersectionsList(i).x = thisX;
    intersectionsList(i).y = thisY;
    
    intersectionsList(i).xGPS = longInter(i);
    intersectionsList(i).yGPS = latInter(i);
    
    if(con1(i)>0)
        intersectionsList(i).con1 = con1(i);
    end
    
    if(con2(i)>0)
        intersectionsList(i).con2 = con2(i);
    end
end

%% create data for graph
graphCon1 = [];
graphCon2 = [];
graphConW = [];

SNames = fieldnames(intersectionsList);     %save struct field names

xMax = size(coverage,2);
yMax = size(coverage,1);

for i=1:noIntersections
    for j=5:numel(SNames)
        temp = intersectionsList(i).(SNames{j});
        
        if (~isempty (temp))
            
            if((intersectionsList(temp).xGPS*1000000 < minLong)  || (intersectionsList(temp).yGPS*1000000 < minLat))
                break
            end
            
            graphCon1 = [graphCon1      i];
            graphCon2 = [graphCon2      temp];

            p1 = [intersectionsList(i).x     intersectionsList(i).y];
            p2 = [intersectionsList(temp).x  intersectionsList(temp).y];        
            
            %check if point is outside coverage matrix
            if(p1(1)>xMax || p2(1)>xMax || p1(2)>yMax || p2(2) >yMax)
                weight = inf;
            else
                [average,~,~,distance,grade] = SignalPathFcn(p1,p2,coverage);
                
                %define weight based on given parameter
                if (strcmp(criterion,'grade') )
                    weight = grade;
                elseif (strcmp(criterion,'distance') )
                    weight = distance;
                elseif (strcmp(criterion,'average') )
                    weight = -average;    
                else
                    weight = grade;
                end
            end

            graphConW = [graphConW      weight];
            
        end
    end
end

%create graph
graphMatrix = sparse(graphCon1,graphCon2,graphConW);

graphMatrix = tril(graphMatrix + graphMatrix');

end


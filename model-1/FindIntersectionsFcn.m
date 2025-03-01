function [IntersectionsMap, IntersectionsList] = FindIntersectionsFcn( CityMap, width, buildings)
%This function looks for intersection points in the CityMap. It is based in
%the fact that the received map follow a square grid with ome plazas
%The output is a list with data about the intersections: their position and
%interconnections
%
%#PARAMETERS:
%      CityMap: CityMap: matrix that represents the received map, each value is 
%  the height of the building in that point on space. Streets have a 
%  value '-1'. Plazas have a value '0'   
%      width: width of the streets
%      buildings: separtion distance between two buildings (includes the street width)
%
%#OUTPUTS:
%      IntersectionsMap: a matrix with the same dimension of CityMap. All
%   the points are ZEROs but the intersections. Each intersection
%   position has as value a unique ID code.
%       IntersectionsList: array of structures that describes the intersections.
%   It has this structure:  struct('x','y',con1','con2','con3','con4')   
%                     [x y] : an intersection
%                     [con1]: another intersection that is connected to
%                     this one in the form: [x y]
%       directions: 1:right, 2: down, 3: left, 4: up

[MapY, MapX] = size(CityMap);

IntersectionsMap = zeros(MapY, MapX);

IntersectionsList = struct('x',{},'y',{},'con1',{},'con2',{},'con3',{},'con4',{});

x = 1;

IntersectionFound = false;
NoIntersections = 0;

%start point in the half width of a street, near the bottom left corner
StartX = ceil(width/2);
StartY = ceil(width/2);

for y=StartY:buildings:MapY
    for x=StartX:buildings:MapX
        IntersectionFound = false;
        
        if (CityMap(y,x) < 0)              %this point is in a street
            IntersectionFound = true;
            
            %checking for false intersections 
            if(x + width > MapX)           %right border
                if (CityMap(y , x - width) >= 0)
                    IntersectionFound = false;
                end
            elseif (y + width > MapY)    %top border
                if (CityMap(y - width, x) >= 0)
                    IntersectionFound = false;
                end
            elseif (x - width < 0)         %left border
                if (CityMap(y, x + width) >= 0)
                    IntersectionFound = false;
                end
            elseif (y - width < 0)         %bottom border
                if (CityMap(y + width, x) >= 0)
                    IntersectionFound = false;
                end  
            %points far from borders
            elseif (CityMap(y + width, x)>=0) && (CityMap(y - width, x)>=0)        %horizontal street, no intersection   
                IntersectionFound = false;
                
            elseif (CityMap(y, x + width)>=0) && (CityMap(y, x - width)>=0)       %vertical street, no intersection   
                IntersectionFound = false;
      
            end
            
            if(IntersectionFound == true)      %plot and save intersections
                
                NoIntersections = NoIntersections + 1;
                
 
                IntersectionsMap(y,x) = NoIntersections;          %save in the map
                IntersectionsList(NoIntersections).x =  x ;  %add coordinates to List
                IntersectionsList(NoIntersections).y =  y ;  %add coordinates to List
            end
            
        end
    end
end  %all intersections saved on the Map and the List

%definition of connections on each intersection

NoIntersections = size (IntersectionsList,2);
HalfWidth = floor(width/2);
HalfBuildings = floor(buildings/2);

for n = 1:NoIntersections
    StartX = IntersectionsList(n).x;
    StartY = IntersectionsList(n).y;
    
    x = StartX;
    y = StartY;
    
    %right ----------
    while (x + buildings <= MapX)       %check for map end
        
        x = x + HalfBuildings;  
        
        if (CityMap(y,x) > -1)      %it is a building -> no route -> get out
            break;
        end
        %it is a street -> possible route -> look for intersection
        x = x + (buildings - HalfBuildings);
        
        if (IntersectionsMap(y,x) ~= 0)  %it is another intersection\
            
            IntersectionsList(n).con1 = IntersectionsMap(y,x);    %save the values
            
            break;                          %go out
        end
    end
    
    
    %down ----------
    x = StartX;
    y = StartY;
    while (y - buildings > 0)       %check for map end
        
        y = y - HalfBuildings;  
        
        if (CityMap(y,x) > -1)      %it is a building -> no route -> get out
            break;
        end
        %it is a street -> possible route -> look for intersection
        y = y - (buildings - HalfBuildings);
        
        if (IntersectionsMap(y,x) ~= 0)  %it is another intersection
            
            IntersectionsList(n).con2 = IntersectionsMap(y,x);    %save the values
            break;                          %go out
        end
    end
    
    
    %left ----------
    x = StartX;
    y = StartY;
    while (x - buildings > 0)       %check for map end
        
        x = x - HalfBuildings;  
        
        if (CityMap(y,x) > -1)      %it is a building -> no route -> get out
            break;
        end
        %it is a street -> possible route -> look for intersection
        x = x - (buildings - HalfBuildings);
        
        if (IntersectionsMap(y,x) ~= 0)  %it is another intersection
            
            IntersectionsList(n).con3 = IntersectionsMap(y,x);    %save the values
            break;                          %go out
        end
    end
    
    %up -----------
    x = StartX;
    y = StartY;
    while (y + buildings <= MapY)       %check for map end
        
        y = y + HalfBuildings;  
        
        if (CityMap(y,x) > -1)      %it is a building -> no route -> get out
            break;
        end
        %it is a street -> possible route -> look for intersection
        y = y + (buildings - HalfBuildings);
        
        if (IntersectionsMap(y,x) ~= 0)  %it is another intersection
            
            IntersectionsList(n).con4 = IntersectionsMap(y,x);    %save the values
            break;                          %go out
        end
    end
    
end

    





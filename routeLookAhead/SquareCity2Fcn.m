function [CityMap]  = SquareCity2Fcn(dimension,width,buildings)
%Generates a ramdom city map with buildings and some plazas. 
%The buildings have a height choosen bewtween some predefined values
%
%#PARAMETERS:
%      dimension: size of the generated matrix, defined in number of 
%  points on X an Y directions
%      width: width of the streets
%      buildings: separtion distance between two buildings (includes the street width)
%
%#OUTPUTS
%      CityMap: matrix that represents the generated map, each value is 
%  the height of the building in that point on space. Streets have a 
%  value '-1'. Plazas have a value '0'
%
%#PS: 
%       The ammount and size of plazas, as the buildings height defined
%  in variables inside this function code

w=width; %width of streets;
b=buildings; %building separation;
MapX=dimension;% Map dimensions
MapY=dimension;%

MinNoPlazas = 30; %min ammount of plazas on the map
MaxNoPlazas = 50; %max ammount of plazas on the map
MaxSizePlazas = 3;  %measured in number of squares
PlazaHeight = 0;    %assigned height for plaza regions

hroofs=[5 10 15 20];%possible roof heights

%calculate number of streets
NoStreetsX=floor(MapX/b);
NoStreetsY=floor(MapY/b);

%define streets/buildings pattern
StreetsS=[zeros(1,w) ones(1,b-w)];
sizeS = size(StreetsS,2);


StreetsX=zeros(1,MapX);
for i=1:NoStreetsX,     %calculate first pattern
    StreetsX = StreetsX + [zeros(1,(i-1)*sizeS) , StreetsS*hroofs(ceil(rand*4)) ,  zeros(1,(MapX-i*sizeS))];
end

StreetsY=zeros(1,MapY);
for i=1:NoStreetsY,
    StreetsY = StreetsY + [zeros(1,(i-1)*sizeS) , StreetsS ,  zeros(1,(MapY-i*sizeS))];
end


CityMap=zeros(MapX,MapY);
for y=1:MapY,
    if StreetsY(y)>0    
        CityMap(y,:)=StreetsX;      %create a row of buildings & vertical streets
    else
        CityMap(y,:)=ones(1,MapX)*-1;   %assign '-1' to an horizontal street
        if y<MapY,                      
            if StreetsY(y+1)>0          %if next row has buildings, calculate new random roof values (StreetsX)
                StreetsX=zeros(1,MapX);
                for i=1:NoStreetsX,
                    StreetsX = StreetsX + [zeros(1,(i-1)*sizeS) , StreetsS*hroofs(ceil(rand*4)) ,  zeros(1,(MapX-i*sizeS))];
                end
            end
        end
    end
end
%assign '-1' to all streets
for x=1:MapX,
    for y=1:MapY,
        if(CityMap(x,y)==0),
            CityMap(x,y) = -1;
        end
    end
end
    

%creation of empty plazas - ----------------------------------------vvvvvv

NoPlazas = MinNoPlazas + floor(rand()*(MaxNoPlazas - MinNoPlazas));

for n=1:NoPlazas,
    %creation of 1 plaza-------------------------------------vvvvvvv

    %random start point
    StartX = ceil(rand()*MapX);
    StartY = ceil(rand()*MapY);

    %find corner
    if CityMap(StartX, StartY)<=0,       %check if it is a street point
        moveDown = true;
        while (CityMap(StartX, StartY)<=0),
            if(StartX == 1 || StartY == 1),   %check end of the map
                moveDown = false;
            end

            if(moveDown==true),
                StartX = StartX - 1;
                StartY = StartY - 1;
            else
                StartX = StartX + 1;
                StartY = StartY + 1;
            end
        end
    end
    %at this point [StartX, StartY] represents a point inside a building


    %find the lower-left corner of this building
    while (CityMap(StartX-1 , StartY)>0),
        StartX = StartX - 1;
    end
    while (CityMap(StartX, StartY - 1) > 0),
        StartY = StartY - 1;
    end

    %size definition
    SizeX = ceil(rand()*MaxSizePlazas);
    SizeY = ceil(rand()*MaxSizePlazas);

    %calculation of end points
    EndX = StartX + (b-w)*(SizeX + 1) + w*SizeX - 1;
    EndY = StartY + (b-w)*(SizeY + 1) + w*SizeY - 1;

    if(EndX > MapX),
        EndX = MapX;
    end
    if(EndY > MapY),
        EndY = MapY;
    end

    %assign values to the map
    for x = StartX:EndX,
        for y = StartY:EndY,
            CityMap(x,y) = PlazaHeight;
        end
    end
    %end of 1 plaza creation
end

%End of city
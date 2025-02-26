function [CityMap]  = SquareCityFcn(dimension,width,buildings)
%#Generates a city map array using 


w=width; %width of streets;
b=buildings; %building separation;
MapX=dimension;% Map dimensions
MapY=dimension;%


hroofs=[5 10 15 20];%possible roof heights

%calculate number of streets
NoStreetsX=floor(MapX/b);
NoStreetsY=floor(MapY/b);

%define streets/buildings pattern
StreetsS=[zeros(1,w) ones(1,b-w)];
[~,sizeS] = size(StreetsS);


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
%End of city
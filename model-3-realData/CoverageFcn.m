function [ coverageFinal, longitude, latitude, rssi, minLong, minLat ] = CoverageFcn( fileName, latLimits, longLimits, scale)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

margin = 200;


[latitude,longitude,rssi] = importfile(fileName);

%limit points to desired area
latMinLimit = latLimits(1);
latMaxLimit = latLimits(2);
longMinLimit = longLimits(1);
longMaxLimit = longLimits(2);

i = 1;
while(1)        
    lat = latitude(i);
    long = longitude(i);
    
    if( (lat<latMinLimit) ||...             %search for points out of defined region
            (lat>latMaxLimit)||...
            (long<longMinLimit)||... 
            (long>longMaxLimit)) 
        latitude(i) = [];
        longitude(i) = [];
        rssi(i) = [];
    else
       i = i+1;
    end
    
    if(i>size(latitude,1))
        break;
    end
end

figure(1)
scatter(longitude, latitude);


%creation of scaled data
noPoints = size(latitude,1);

maxLong = max(longitude) + margin;
minLong = min(longitude) - margin;

maxLat = max(latitude) + margin;
minLat = min(latitude) - margin;

deltaLat = abs(maxLat - minLat);
deltaLong = abs(maxLong - minLong);

%define size for interpolation results matrixes
sizeX = abs( ceil(deltaLong/scale)) ; 
sizeY = abs( ceil(deltaLat/scale)) ;

%creation of result matrixes
coverage = zeros(sizeY, sizeX);
pointsCount = zeros(sizeY, sizeX);

for i=1:noPoints
   thisX = floor((longitude(i) - minLong)/scale ) +1;
   thisY = floor((latitude(i) - minLat)/scale ) +1;
   thisRssi = rssi(i);
   
   [ coverage, pointsCount] = expand( thisX, thisY, thisRssi, coverage, pointsCount, 12 );
   
end

[ coverageFinal] = averageExpansion(coverage, pointsCount);

end


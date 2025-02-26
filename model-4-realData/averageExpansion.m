function [ coverageOut] = averageExpansion(coverageIn, pointsCountIn )
    
%AVERAGEEXPANSION Summary of this function goes here
%   Detailed explanation goes here

sizeX = size(coverageIn,2);
sizeY = size(coverageIn,1);

for i=1:sizeX
    for j=1:sizeY
        if (pointsCountIn(j,i) > 0)
            coverageOut(j,i) = coverageIn(j,i) / pointsCountIn(j,i);
        else
            coverageOut(j,i) = coverageIn(j,i);
        end
    end
end


end


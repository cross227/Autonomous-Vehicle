function [ coverageOut, pointsCountOut] = expand( x, y, value, coverageIn, pointsCountIn, expansionSize )
%EXPAND Summary of this function goes here
%   Detailed explanation goes here


expansionShape = 'square';

sizeX = size(coverageIn,2);
sizeY = size(coverageIn,1);

pointsCountOut = pointsCountIn;
coverageOut = coverageIn;

%for SQUARE shape:

for i=(x-expansionSize) : (x+expansionSize)
    for j=(y-expansionSize) : (y+expansionSize)
        
        if (i>0 && i<=sizeX && j>0 && j<=sizeY) %check for border condition
            
            dist = sqrt ((x-i)^2 + (y-j)^2);
            
            weight = subplus((expansionSize-dist)/expansionSize);
            
            
            
            %coverageOut(j,i) = coverageOut(j,i) + value * weight;
            coverageOut(j,i) = coverageOut(j,i) + value;
            
            pointsCountOut(j,i) = pointsCountOut(j,i) + 1;
            %pointsCountOut(j,i) = pointsCountOut(j,i) + weight;
        end
    end
end



end

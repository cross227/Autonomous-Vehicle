function [SignalVector, EdgeSignalVector] = EvaluatePathFcn( path, IntersectionsList, SignalMatrix )
%EVALUATEPATHFCN Summary of this function goes here
%   Detailed explanation goes here


sum = 0;

minValue = inf();
maxValue = -inf();
    
NoNodes = size(path,2);

SignalVector = [];

%EdgeSignalVector = zeros(1,NoNodes-1);

EdgeSignalVector = [];

for i=1:NoNodes-1

    StartNode = path(i);
    EndNode = path(i+1);
    
    x1 = IntersectionsList(StartNode).x;
    y1 = IntersectionsList(StartNode).y;
    
    x2 = IntersectionsList(EndNode).x;
    y2 = IntersectionsList(EndNode).y;
    
    d = sqrt( (x1 - x2)^2 + (y1 - y2)^2);   %calculate distance

    dx = x2 - x1;       %distance on X axis

    dy = y2 - y1;       %distance on Y axis

    NoPoints = floor(d);    

    
    %evaluate edges
    [~,~,~,~,grade] = SignalPathFcn([x1,y1],[x2,y2],SignalMatrix);
    
    %EdgeSignalVector(i) = grade;

    %sweep along the path
    for j=1:NoPoints-1  
        if dx>0
            x = ceil ( (j/NoPoints) * dx) + x1;
        else
            x = floor ( (j/NoPoints) * dx) + x1;
        end

        if dy>0
            y = ceil ( (j/NoPoints) * dy) + y1;
        else
            y = floor ( (j/NoPoints) * dy) + y1;
        end

        value = SignalMatrix(y,x);

        sum = sum + value;

        minValue = min(minValue, value);
        maxValue = max(maxValue, value);
        
        SignalVector = [SignalVector    SignalMatrix(y,x)];
        
        EdgeSignalVector = [EdgeSignalVector grade];

    end

end


end


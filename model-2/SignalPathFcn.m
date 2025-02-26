function [average, minValue, maxValue, distance, grade] = SignalPathFcn(p1, p2, SignalMatrix)
%This function receives 2 point coordinates and evaluate the signal values 
%along the path between them. It just will take the shortest path and won't
%consider the signal on the start point. It considers the value on the end
%point.
%
%#PARAMETERS: 
%     p1: origin point in format  [x y]
%     p2: destin point in format  [x y]
%     SignalMatrix: bidimensional matrix of values that will be measured in the calculation
%
%#OUTPUTS:
%     average: average signal value along the path
%     minValue: minimun signal value along the path
%     maxValue: maximun signal value along the path
%     distance: distance value between P1 and P2
%     grade: result of the evaluation equation for this path



x1 = p1(1,1);
y1 = p1(1,2);

x2 = p2(1,1);
y2 = p2(1,2);

distance = sqrt( (x1 - x2)^2 + (y1 - y2)^2);   %calculate distance

dx = x2 - x1;       %distance on X axis

dy = y2 - y1;       %distance on Y axis

NoPoints = floor(distance);    

sum = 0;

minValue = inf();
maxValue = -inf();

%sweep along the path
for i=1:NoPoints-1  
    if dx>0
        x = ceil ( (i/NoPoints) * dx) + x1;
    else
        x = floor ( (i/NoPoints) * dx) + x1;
    end
    
    if dy>0
        y = ceil ( (i/NoPoints) * dy) + y1;
    else
        y = floor ( (i/NoPoints) * dy) + y1;
    end
    
    value = SignalMatrix(y,x);
    
    sum = sum + value;
    
    minValue = min(minValue, value);
    maxValue = max(maxValue, value);

end

average = sum / (NoPoints - 1);

%grade = distance*(average -50)^6 /100000000000;

%grade = distance+(150*log(((-average)-77)/77));

%grade = distance *(1 + 10*(log(-average)));

%grade = ( 10*(log(-average-80)));

distGain = .01;

averageGain = 5;

grade = distance *(distGain + averageGain*average) / (distGain + averageGain);


end






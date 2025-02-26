
OriginNode = 1000;

DestinNode = 1;


lengthVector = 50:5:400; 

updateDistance = 4;     % number of intersections to drive before getting a new coverage map

plotResults = false;

[dist, originalPath] = FindRouteFcn (GraphMatrix , IntersectionsList, OriginNode, DestinNode);


undVector = [];
sigVector  = [];

for t=1:size(lengthVector,2)

    expansionLength = lengthVector(t)  % side length of each coverage map
    RouteLookAhead2;

    undVector(t) = AvUnd;
    sigVector (t) = AvSig;

end

[SignalVector, UndesirabilityVector] = EvaluatePathFcn( originalPath, IntersectionsList, ResultMatrix, Coverage_matrix );
AvUndFull = mean(UndesirabilityVector)
AvSigFull = mean(SignalVector)

figure(2)
plot (lengthVector, 1./undVector*AvUndFull)
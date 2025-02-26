
A = [32.235027	,	-110.953882];
B = [32.235074	,	-110.953882];
C = [32.235121	,	-110.95395975];
D = [32.235121	,	-110.95411525];
E = [32.235168	,	-110.954193];
F = [32.235215	,	-110.95411525];
G = [32.235262	,	-110.9540375];
H = [32.235309	,	-110.9540375];

vec = [A;B;C;D;E;F;G;H];

figure(1)
clf
scatter(vec(:,2),vec(:,1))
hold on

deltaLat =  9.4000e-07;
deltaLong = 1.1107e-06;
deltaAngle = pi/360;

path = [];

%% 1) straight 1
vec2 = [];
j = 1;
for i=A(1):deltaLat:B(1)
    vec2(j,:) = [i  A(2)]; 
    j = j+1;
end
path = [path ; vec2];

scatter(vec2(:,2),vec2(:,1))

%% 2) curve 1
centerLat = B(1);
centerLong = C(2);
radiusLat = max(B(1),C(1)) - min(B(1),C(1));
radiusLong = max(B(2),C(2)) - min(B(2),C(2));
center = [centerLat,centerLong];

vec2 = [];
j = 1;
for ang=0:pi/360:pi/2
    thisLong = cos(ang);
    thisLat = sin(ang);
    
    thisLong = cos(ang)*radiusLong + centerLong;
    thisLat = sin(ang)*radiusLat + centerLat;
    
    
    vec2(j,:) = [thisLat, thisLong];
    j = j+1;
end
path = [path ; vec2];
scatter(vec2(:,2),vec2(:,1));


%% 3) straight 2
vec2 = [];
j = 1;
for i=C(2):-deltaLong:D(2)
    vec2(j,:) = [C(1)  i]; 
    j = j+1;
end
path = [path ; vec2];
scatter(vec2(:,2),vec2(:,1))

%% 4: curve 2
centerLat = E(1);
centerLong = D(2);
radiusLat = max(D(1),E(1)) - min(D(1),E(1));
radiusLong = max(D(2),E(2)) - min(D(2),E(2));
center = [centerLat,centerLong];

vec2 = [];
j = 1;
for ang=-pi/2:-deltaAngle:-pi
    thisLong = cos(ang);
    thisLat = sin(ang);
    
    thisLong = cos(ang)*radiusLong + centerLong;
    thisLat = sin(ang)*radiusLat + centerLat;
    
    
    vec2(j,:) = [thisLat, thisLong];
    j = j+1;
end
path = [path ; vec2];
scatter(vec2(:,2),vec2(:,1));

%% 4) curve 3
centerLat = E(1);
centerLong = F(2);
radiusLat = max(F(1),E(1)) - min(F(1),E(1));
radiusLong = max(F(2),E(2)) - min(F(2),E(2));
center = [centerLat,centerLong];

vec2 = [];
j = 1;
for ang=pi:-deltaAngle:pi/2
    thisLong = cos(ang);
    thisLat = sin(ang);
    
    thisLong = cos(ang)*radiusLong + centerLong;
    thisLat = sin(ang)*radiusLat + centerLat;
    
    
    vec2(j,:) = [thisLat, thisLong];
    j = j+1;
end
path = [path ; vec2];
scatter(vec2(:,2),vec2(:,1));

%% 5) curve 4
centerLat = G(1);
centerLong = F(2);
radiusLat = max(F(1),G(1)) - min(F(1),G(1));
radiusLong = max(F(2),G(2)) - min(F(2),G(2));
center = [centerLat,centerLong];

vec2 = [];
j = 1;
for ang=-pi/2:deltaAngle:0
    thisLong = cos(ang);
    thisLat = sin(ang);
    
    thisLong = cos(ang)*radiusLong + centerLong;
    thisLat = sin(ang)*radiusLat + centerLat;
    
    
    vec2(j,:) = [thisLat, thisLong];
    j = j+1;
end
path = [path ; vec2];
scatter(vec2(:,2),vec2(:,1));

%% 6) straight 3
vec2 = [];
j = 1;
for i=G(1):deltaLat:H(1)
    vec2(j,:) = [i  G(2)]; 
    j = j+1;
end
path = [path ; vec2];

scatter(vec2(:,2),vec2(:,1));

plot_google_map('MapType','satellite');

figure(2)
scatter(path(:,2),path(:,1),'r');
plot_google_map('MapType','satellite');


%% export to file
fileX= fopen('pathX.mat','w');
fileY= fopen('pathY.mat','w');

fprintf(fileX,'%f,',path(:,2));
fprintf(fileY,'%f,',path(:,1));
    
fclose(fileX);
fclose(fileY);


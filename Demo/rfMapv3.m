


len = 400;

inputs1 = [ 4 5 5 4 4 3 1 1;
            3 4 5 5 4 1 1 1;
            1 2 3 4 5 4 3 2;
            1 1 1 4 5 5 5 2;
            1 1 1 4 5 4 5 4;
            1 1 1 1 1 2 3 5;
            1 1 1 1 1 2 3 5;
            1 1 1 1 1 2 3 5];

inputs1 = flipud(inputs1);

route1 = [20 380; 100 380; 200 300; 201 290; 290 200; 280 200; 380 100; 381 20]; 

route1_Y = [];
route1_X = [];

for i=min(route1):max(route1)
    route1_Y = [route1_Y   pchip(route1(:,1), route1(:,2), i)];
    route1_X = [route1_X   i];
end
route1 = [];
route1(:,1) = route1_X;
route1(:,2) = route1_Y;

%-------------------------------
inputs2 = [ 5 4 3 2 1 1 1 1;
            5 5 3 2 1 1 1 1;
            5 5 4 4 3 2 2 2;
            5 5 5 5 5 5 4 2;
            3 4 4 4 5 5 4 4;
            1 2 1 2 3 3 4 5;
            1 1 1 1 1 3 4 5;
            1 1 1 1 1 3 4 5];
        
inputs2 = flipud(inputs2);


route2 = [20 380; 21 300; 150 200; 270 200; 380 100; 381 20]; 

route2_Y = [];
route2_X = [];

for i=min(route2):max(route2)
    route2_Y = [route2_Y   pchip(route2(:,1), route2(:,2), i)];
    route2_X = [route2_X   i];
end
route2 = [];
route2(:,1) = route2_X;
route2(:,2) = route2_Y;


% ---------------------------------
route3 = [20 380; 381 20];


noInputs = 2; 

figure(2)
clf
    
% for i=1:noInputs
%     variableName=sprintf('inputs%d', i);
%     %assignin('base','input',variableName)
%     
%     eval (['input = ',variableName,';']);
% 
%     % 2-D DCT transform
%     f = dct2(input);
%     
%     %Zero-padded matrix
%     filtered = zeros(len, len);
%     size1 = size(input,1);
%     size2 = size(input,2);
%     
%     filtered(1:size1,1:size2) = f;
%    
%     
%     %Inverse 2-D DCT Transform
%     map = (len/4)*idct2(filtered);
%         
%     figure(2)
%     subplot(220 + i);
%     imagesc(map)
%     hold on;
%     set(gca,'YDir','normal')
%     colormap(jet)
%     variableName=sprintf('route%d', i);
%     eval(['x=',variableName,'(:,1); y=',variableName,'(:,2);']);
%     plot(x,y,'--k','LineWidth',4);
%     s = sprintf('Map %d',i);
%     title(s);
% end
    

%for input 1---------------------------
input = inputs1;

% 2-D DCT transform
f = dct2(input);

%Zero-padded matrix
filtered = zeros(len, len);
size1 = size(input,1);
size2 = size(input,2);

filtered(1:size1,1:size2) = f;


%Inverse 2-D DCT Transform
map1 = (len/4)*idct2(filtered);

figure(3)
subplot(121);
imagesc(map1)
hold on;
set(gca,'YDir','normal')
colormap(jet)
plot(route1(:,1),route1(:,2),'--k','LineWidth',4);
plot(route3(:,1),route3(:,2),'w','LineWidth',4);
title('Map 1');

%for input 1---------------------------
input = inputs2;

% 2-D DCT transform
f = dct2(input);

%Zero-padded matrix
filtered = zeros(len, len);
size1 = size(input,1);
size2 = size(input,2);

filtered(1:size1,1:size2) = f;


%Inverse 2-D DCT Transform
map2 = (len/4)*idct2(filtered);

figure(3)
subplot(122);
imagesc(map2)
hold on;
set(gca,'YDir','normal')
colormap(jet)
plot(route1(:,1),route1(:,2),'--k','LineWidth',4);
plot(route2(:,1),route2(:,2),'-.c','LineWidth',4);
plot(route3(:,1),route3(:,2),'w','LineWidth',4);
title('Map 2');

%plot all routes
figure(1)
imagesc(map1)
hold on;
set(gca,'YDir','normal')
colormap(jet)
plot(route1(:,1),route1(:,2),'--k','LineWidth',4);
plot(route3(:,1),route3(:,2),'w','LineWidth',4);
title('Map 1');

figure(2)
imagesc(map2)
hold on;
set(gca,'YDir','normal')
colormap(jet)
plot(route1(:,1),route1(:,2),'--k','LineWidth',4);
plot(route2(:,1),route2(:,2),'-.c','LineWidth',4);
plot(route3(:,1),route3(:,2),'w','LineWidth',4);
title('Map 2');




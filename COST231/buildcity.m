clear all;
w=2; %width of streets;
b=10; %building separation;
hroofs=[5 10 15 20];%possible roof heights
Dhb=10; %height relative to rooftops
%valid height of antenna above street level: 4 to 50m
%valid mobile antenna height: 1 to 3m;
fc=1800; %Carrier frequency (800 to 2000MHz)
hm=1; %mobile antenna height
metro=true;
MapX=300;% Map dimensions
MapY=300;%


NoStreetsX=floor(MapX/b);
NoStreetsY=floor(MapY/b);

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
        CityMap(:,y)=StreetsX;
    else
        CityMap(:,y)=ones(1,MapX)*-1;
        if y<MapY,
            if StreetsY(y+1)>0
                StreetsX=zeros(1,MapX);
                for i=1:NoStreetsX,
                    StreetsX = StreetsX + [zeros(1,(i-1)*sizeS) , StreetsS*hroofs(ceil(rand*4)) ,  zeros(1,(MapX-i*sizeS))];
                end
            end
        end
    end
end

%End of city

p.d=0; %distance;
p.LOS=0; %is it LOS?
p.b=0; %average building length;
p.hr=0; %max roof height;
p.w=0; %average street width
p.IsB=0; %Is it a building?
p.phi=0;
%p.W=[];
%p.HR=[];


pos_antennas = [0.5 0.5]; 

%pos_antennas = [.1 .5;       1  1];

%pos_antennas = [.5 .5;     .2 .2;       .9 .2];
            

            
[NoAntennas, y] = size(pos_antennas);

CoverageMap_final = 0;

for n=1:1:NoAntennas,
    
    disp(strcat('Start of calculation for antenna #',int2str(n), '  /  ',int2str(NoAntennas)))
    
    Tx=[0 0];
    posY = pos_antennas (n, 1);
    posX = pos_antennas (n, 2);

    for x=ceil(MapX*posX):MapX,
        for y=ceil(MapX*posY):MapY,
            if CityMap(x,y)>0,
                Tx=[x y];
                break;
            end
        end
        if sum(Tx)>0
            break;
        end;
    end


    CoverageMap=zeros(MapX,MapY);
    for x=1:1:MapX,
        for y=1:1:MapY,
            m=(Tx(2)-y)/(Tx(1)-x);
            if Tx(1)>x,
                xv=Tx(1):-1:x;
            else
                xv=Tx(1):x;
            end
            if x==Tx(1)
            yv=y;
            else
            yv=round(-(m*(Tx(1)-xv)-Tx(2)));
            end
            B=[];
            firstb=[0 0];
            lastb=[0 0];
            lastw=[0 0];
            firstw=[0 0];
            lasthr=0;
            W=[];
            HR=[];
            wcount=0;
            for i=1:length(xv),
                x2=xv(i);
                y2=yv(i);
               % disp([x2 y2 CityMap(x2,y2) firstw lastw firstb lastb   ])

                if CityMap(x2,y2)>0,
                    if sum(lastw)>0,
                        wd=sqrt((firstw(1)-lastw(1))^2 + (firstw(2)-lastw(2))^2);
                        W=[W wd];
                        lastw=[0 0];
                        firstw=[0 0];
                    end                

                    if sum(firstb)==0,
                        firstb=[x2 y2];
                        lastb=[x2 y2];
                        lasthr=CityMap(x2,y2);
                        HR=[HR lasthr];
                    else
                        lastb=[x2 y2];
                    end

                else
                    if sum(lastb)>0,
                        bd=sqrt((firstb(1)-lastb(1))^2 + (firstb(2)-lastb(2))^2);
                        if size(W)>0,
                            bd=bd+W(end);
                        end
                        B=[B bd];
                        firstb=[0 0];
                        lastb=[0 0];
                    end

                    if sum(firstw)==0,
                        firstw=[x2 y2];
                        lastw=[x2 y2];                    
                    else
                        lastw=[x2 y2];
                    end
                end
            end
            d=sqrt((x-Tx(1))^2+(y-Tx(2))^2);

            p.d=d;
            if isempty(W),
                p.LOS=1;
                if d>50
                    if isempty(HR)
                        p.LOS=1;
                    else
                        p.LOS=0;
                    end
                end
            else
                p.LOS=0;
            end
            p.b=max([B b]);
            p.hr=max(HR);
            p.w=max([W w]);
            if CityMap(x,y)>0
            p.IsB=1;
            else
                p.IsB=0;
            end

            if CityMap(x,y)==-1,
                cos_theta=abs(x-Tx(1))/d;
                theta=acos(cos_theta);
                phi=pi/2-theta;

            else
                cos_theta=abs(y-Tx(2))/d;
                theta=acos(cos_theta);
                phi=pi/2-theta;

            end
            p.phi=phi*180/pi;


                if p.d>=20
                    if p.LOS,
                    Lp=42.6+26*log10(d)+20*log10(fc);
                    else
                    Lp=COST231LpNLOS(p.w,hm,p.phi,p.hr+Dhb,p.hr,p.d,fc,p.b,metro);   
                    end
                    if p.IsB==0,
                        CoverageMap(x,y)=-Lp;
                    else
                        CoverageMap(x,y)=-Lp-20;
                    end
                else
                    Lp=42.6+26*log10(20)+20*log10(fc);
                    if p.IsB==0,
                        CoverageMap(x,y)=-Lp;
                    else
                        CoverageMap(x,y)=-Lp-20;
                    end

                end
                %strcat(num2str(x/MapX, 1), '% of antenna #',int2str(n))
        end
        
        
        
    end

    CoverageMap_final = CoverageMap_final + CoverageMap;    %updates final map
    disp(strcat('End of calculation for antenna #',int2str(n), '  /  ',int2str(NoAntennas)))
end


%next: trace enviroment and create p struct for each point
%once the whole map is traced, then calculate the PL based on the model


%plotting graphs
figure(1)
imagesc(CoverageMap_final) 
colorbar
set(gca,'YDir','normal')




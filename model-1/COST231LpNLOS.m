function [ Lp ] = COST231LpNLOS(w,hm,phi,hb,hr,d,fc,b,metro)
%COST231LpNLOS(w,hm,phi,hb,hr,d,fc,b,metro)
%d in Km; fc in MHz,phi in degrees, hm;hb in meters
Dhm=hr-hm;
L0=COST231L0(d,fc);
Lrts=COST231Lrts(w,fc,Dhm,phi);
Lmsd = 0;
Lmsd=COST231Lmsd(hb,hr,d,fc,b,metro);

if (Lrts+Lmsd)<0
    Lp=L0;
else
    Lp=L0+Lrts+Lmsd;
end

end


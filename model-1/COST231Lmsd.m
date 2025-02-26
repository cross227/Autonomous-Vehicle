function [ Lmsd ] = COST231Lmsd(hb,hr,d,fc,b,metro)
%COST231Lmsd(hb,hr,d,fc,b,metro)
%multiscreen diffraction loss
Dhb=hb-hr;
d=d/1000;
ka = 0;
if hb>hr
    ka=54;
elseif (d>=0.5)&&(hb<=hr)
    ka=54-0.8*Dhb;
elseif (d<0.5)&&(hb<=hr)
    ka=54-0.8*Dhb*d/0.5
end

if hb>hr
    kd=18;
else
    kd=18-15*Dhb/hr;
end

if metro,
    kf=-4+1.5*(fc/925-1);
else
    kf=-4+0.7*(fc/925-1);
end

if hb>hr
    Lbsh=-18*log10(1+Dhb);
else
    Lbsh=0;
end
Lmsd = Lbsh+ka+kd*log10(d)+kf*log10(fc)-9*log10(b);
end


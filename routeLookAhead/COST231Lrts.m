function [ Lrts ] = COST231Lrts(w,fc,Dhm,phi)
%COST231Lrts(w,fc,Dhm,phi)
% roof-top-to-street diffraction and scatter loss

Lori = 0;

if phi<=35,
    Lori=-10+0.354*phi;
elseif phi<=55,
    Lori=2.5+0.075*(phi-35);
elseif phi<=90,
    Lori=4.0-0.114*(phi-55);
end

Lrts = -16.9-10*log10(w)+10*log10(fc)+20*log10(Dhm)+Lori;

end


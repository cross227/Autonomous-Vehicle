function [ L0 ] = COST231L0( d,fc )
%COST231L0 free-space loss
L0= 32.4+20*log10(d/1000)+20*log10(fc);
end


function minf=stn_minf(V)
minf=1./(1+exp(-(V+30)./15));
return
function minf=gpe_minf(V)
minf=1./(1+exp(-(V+37)./10));
return
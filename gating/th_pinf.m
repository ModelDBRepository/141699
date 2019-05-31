function pinf=th_pinf(V)
pinf=1./(1+exp(-(V+60)./6.2));
return
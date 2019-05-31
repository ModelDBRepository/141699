function ninf=gpe_ninf(V)
ninf=1./(1+exp(-(V+50)./14));
return
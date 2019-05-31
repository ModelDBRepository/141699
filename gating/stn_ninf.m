function ninf=stn_ninf(V)
ninf=1./(1+exp(-(V+32)./8.0));
return
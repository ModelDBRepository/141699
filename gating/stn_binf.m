function binf=stn_binf(R)
binf=1./(1+exp(-(R-0.4)./0.1))-1/(1+exp(0.4/0.1));
return
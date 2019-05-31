function tau=gpe_taun(V)
tau=0.05+0.27./(1+exp(-(V+40)./-12));
return
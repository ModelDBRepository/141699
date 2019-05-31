function tau=gpe_tauh(V)
tau=0.05+0.27./(1+exp(-(V+40)./-12));
return
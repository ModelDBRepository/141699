function tau=stn_taun(V)
tau=1+100./(1+exp(-(V+80)./-26));
return
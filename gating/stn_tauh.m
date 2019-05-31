function tau=stn_tauh(V)
tau=1+500./(1+exp(-(V+57)./-3));
return
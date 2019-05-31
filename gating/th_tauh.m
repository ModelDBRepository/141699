function tau=th_tauh(V)
tau=1./(ah(V)+bh(V));

function a=ah(V)
a=0.128*exp(-(V+46)./18);
function b=bh(V)
b=4./(1+exp(-(V+23)./5));
return

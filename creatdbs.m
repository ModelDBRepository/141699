function ID=creatdbs(f,tmax,dt)
%Creates DBS train of frequency f, of length tmax (msec), 
%with time step dt (msec)

t=0:dt:tmax; ID=zeros(1,length(t));
iD=300;
pulse=iD*ones(1,0.3/dt);

i=1;
while i<length(t)
    ID(i:i+0.3/dt-1)=pulse;
    instfreq=f;
    isi=1000/instfreq;
    i=i+round(isi*1/dt);
end
function [Istim, timespike]= createSMC(tmax,dt,freq,cv)
%creates Sensorimotor Cortex (SMC) input to thalamic cells

%Variables:
%tmax - length of input train (msec)
%dt - time step (msec)
%freq - frequency of input train
%cv - coefficient of variation of input train (gamma distribution)

%Output
%Istim - Input train from SMC
%timespike - Timing of each input pulse

t=0:dt:tmax;ism=3.5;
Istim=zeros(1,length(t));
deltasm=5;
pulse=ism*ones(1,deltasm/dt);
i=1; j=1;
A = 1/cv^2;
B  = freq / A;
if cv==0
    instfreq=freq;
else
    instfreq=gamrnd(A,B);
end
ipi=1000/instfreq;
i=i+round(ipi/dt);

while i<length(t)
    timespike(j)=t(i);
    Istim(i:i+deltasm/dt-1)=pulse;
    A = 1/cv^2;
    B  = freq / A;
    if cv==0
        instfreq=freq;
    else
    instfreq=gamrnd(A,B);
    end
    ipi=1000/instfreq;
    i=i+round(ipi/dt);
    j=j+1;
end
%ipi=timespike(2:end)-timespike(1:end-1);
return




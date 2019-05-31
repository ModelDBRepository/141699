function EI = BGnetwork(pd,wstim,freq)

%Usage: EI = BGnetwork(pd,wstim,freq)
%
%Example: error_index=BG(1,1,130);
%
%Variables:
%pd - Variable to determine whether network is under the healthy or 
%Parkinsonian condition. For healthy, pd = 0, for Parkinson's, pd = 1.
%wstim - Variable to determine wither deep brain stimulation is on.
%If DBS is off, wstim = 0. If DBS is on, wstim = 1.
%freq - Determines the frequency of stimulation, in Hz.
%
%
%Author: Rosa So, Duke University 
%Updated 10/11/2011


load('Istim.mat') %loads initial conditions
addpath('gating')

%%Membrane parameters
%In order of Th,STN,GP or Th,STN,GPe,GPi
Cm=1;
gl=[0.05 2.25 0.1]; El=[-70 -60 -65];
gna=[3 37 120]; Ena=[50 55 55]; 
gk=[5 45 30]; Ek=[-75 -80 -80];
gt=[5 0.5 0.5]; Et=0;
gca=[0 2 0.15]; Eca=[0 140 120];
gahp=[0 20 10]; k1=[0 15 10]; kca=[0 22.5 15];
A=[0 3 2 2]; B=[0 0.1 0.04 0.04]; the=[0 30 20 20]; 

%%Synapse parameters
%In order of Igesn,Isnge,Igege,Isngi,Igigi,Igith
gsyn = [1 0.3 1 0.3 1 .08]; Esyn = [-85 0 -85 0 -85 -85];
tau=5; gpeak=0.43;gpeak1=0.3;  

%time step
t=0:dt:tmax;

%%Setting initial matrices
vth=zeros(n,length(t)); %thalamic membrane voltage
vsn=zeros(n,length(t)); %STN membrane voltage
vge=zeros(n,length(t)); %GPe membrane voltage
vgi=zeros(n,length(t)); %GPi membrane voltage
S2=zeros(n,1); S21=zeros(n,1); S3=zeros(n,1); 
S31=zeros(n,1);S32=zeros(n,1); S4=zeros(n,1); 
Z2=zeros(n,1);Z4=zeros(n,1);


%%with or without dbs
Idbs=creatdbs(freq,tmax,dt); %creating DBS train with frequency freq
if ~wstim; Idbs=zeros(1,length(t)); end

%%initial conditions
vth(:,1)=v1;
vsn(:,1)=v2;
vge(:,1)=v3;
vgi(:,1)=v4;

N2=stn_ninf(vsn(:,1)); N3=gpe_ninf(vge(:,1));N4=gpe_ninf(vgi(:,1));
H1=th_hinf(vth(:,1)); H2=stn_hinf(vsn(:,1)); H3=gpe_hinf(vge(:,1));H4=gpe_hinf(vgi(:,1));
R1=th_rinf(vth(:,1)); R2=stn_rinf(vsn(:,1)); R3=gpe_rinf(vge(:,1));R4=gpe_rinf(vgi(:,1));
CA2=0.1; CA3=CA2;CA4=CA2; 
C2=stn_cinf(vsn(:,1));

%%Time loop
for i=2:length(t)        
    V1=vth(:,i-1);    V2=vsn(:,i-1);     V3=vge(:,i-1);    V4=vgi(:,i-1);
    % Synapse parameters 
    S21(2:n)=S2(1:n-1);S21(1)=S2(n);
    S31(1:n-1)=S3(2:n);S31(n)=S3(1);
    S32(3:n)=S3(1:n-2);S32(1:2)=S3(n-1:n);
    
    %membrane paremeters
    m1=th_minf(V1);m2=stn_minf(V2);m3=gpe_minf(V3);m4=gpe_minf(V4);
    n2=stn_ninf(V2);n3=gpe_ninf(V3);n4=gpe_ninf(V4);
    h1=th_hinf(V1);h2=stn_hinf(V2);h3=gpe_hinf(V3);h4=gpe_hinf(V4);
    p1=th_pinf(V1);
    a2=stn_ainf(V2); a3=gpe_ainf(V3);a4=gpe_ainf(V4);
    b2=stn_binf(R2);
    s3=gpe_sinf(V3);s4=gpe_sinf(V4);
    r1=th_rinf(V1);r2=stn_rinf(V2);r3=gpe_rinf(V3);r4=gpe_rinf(V4);
    c2=stn_cinf(V2);

    tn2=stn_taun(V2);tn3=gpe_taun(V3);tn4=gpe_taun(V4);
    th1=th_tauh(V1);th2=stn_tauh(V2);th3=gpe_tauh(V3);th4=gpe_tauh(V4);
    tr1=th_taur(V1);tr2=stn_taur(V2);tr3=30;tr4=30;
    tc2=stn_tauc(V2);
    
    %thalamic cell currents
    Il1=gl(1)*(V1-El(1));
    Ina1=gna(1)*(m1.^3).*H1.*(V1-Ena(1));
    Ik1=gk(1)*((0.75*(1-H1)).^4).*(V1-Ek(1));
    It1=gt(1)*(p1.^2).*R1.*(V1-Et);
    Igith=1.4*gsyn(6)*(V1-Esyn(6)).*S4; 
    
    %STN cell currents
    Il2=gl(2)*(V2-El(2));
    Ik2=gk(2)*(N2.^4).*(V2-Ek(2));
    Ina2=gna(2)*(m2.^3).*H2.*(V2-Ena(2));
    It2=gt(2)*(a2.^3).*(b2.^2).*(V2-Eca(2));
    Ica2=gca(2)*(C2.^2).*(V2-Eca(2));
    Iahp2=gahp(2)*(V2-Ek(2)).*(CA2./(CA2+k1(2)));
    Igesn=0.5*(gsyn(1)*(V2-Esyn(1)).*(S3+S31)); %Igesn=0;
    Iappstn=33-pd*10;
    
    %GPe cell currents
    Il3=gl(3)*(V3-El(3));
    Ik3=gk(3)*(N3.^4).*(V3-Ek(3));
    Ina3=gna(3)*(m3.^3).*H3.*(V3-Ena(3));
    It3=gt(3)*(a3.^3).*R3.*(V3-Eca(3));
    Ica3=gca(3)*(s3.^2).*(V3-Eca(3));
    Iahp3=gahp(3)*(V3-Ek(3)).*(CA3./(CA3+k1(3)));
    Isnge=0.5*(gsyn(2)*(V3-Esyn(2)).*(S2+S21)); %Isnge=0;
    Igege=0.5*(gsyn(3)*(V3-Esyn(3)).*(S31+S32)); %Igege=0;
    Iappgpe=21-13*pd+r;

    %GPi cell currents
    Il4=gl(3)*(V4-El(3));
    Ik4=gk(3)*(N4.^4).*(V4-Ek(3));
    Ina4=gna(3)*(m4.^3).*H4.*(V4-Ena(3));
    It4=gt(3)*(a4.^3).*R4.*(V4-Eca(3));
    Ica4=gca(3)*(s4.^2).*(V4-Eca(3));
    Iahp4=gahp(3)*(V4-Ek(3)).*(CA4./(CA4+k1(3)));
    Isngi=0.5*(gsyn(4)*(V4-Esyn(4)).*(S2+S21)); %Isngi=0;%special
    Igigi=0.5*(gsyn(5)*(V4-Esyn(5)).*(S31+S32)); %Igigi=0;%special
    Iappgpi=22-pd*6;
    
    %Differential Equations for cells
    %thalamic
    vth(:,i)= V1+dt*(1/Cm*(-Il1-Ik1-Ina1-It1-Igith+Istim(i)));
    H1=H1+dt*((h1-H1)./th1);
    R1=R1+dt*((r1-R1)./tr1);
    
    %STN
    vsn(:,i)=V2+dt*(1/Cm*(-Il2-Ik2-Ina2-It2-Ica2-Iahp2-Igesn+Iappstn+Idbs(i)));
    N2=N2+dt*(0.75*(n2-N2)./tn2); 
    H2=H2+dt*(0.75*(h2-H2)./th2);
    R2=R2+dt*(0.2*(r2-R2)./tr2);
    CA2=CA2+dt*(3.75*10^-5*(-Ica2-It2-kca(2)*CA2));
    C2=C2+dt*(0.08*(c2-C2)./tc2); 
    a=find(vsn(:,i-1)<-10 & vsn(:,i)>-10);
    u=zeros(n,1); u(a)=gpeak/(tau*exp(-1))/dt;
    S2=S2+dt*Z2; 
    zdot=u-2/tau*Z2-1/(tau^2)*S2;
    Z2=Z2+dt*zdot;
    
    %GPe
    vge(:,i)=V3+dt*(1/Cm*(-Il3-Ik3-Ina3-It3-Ica3-Iahp3-Isnge-Igege+Iappgpe));
    N3=N3+dt*(0.1*(n3-N3)./tn3);
    H3=H3+dt*(0.05*(h3-H3)./th3);
    R3=R3+dt*(1*(r3-R3)./tr3);
    CA3=CA3+dt*(1*10^-4*(-Ica3-It3-kca(3)*CA3));
    S3=S3+dt*(A(3)*(1-S3).*Hinf(V3-the(3))-B(3)*S3);
    
    %GPi
    vgi(:,i)=V4+dt*(1/Cm*(-Il4-Ik4-Ina4-It4-Ica4-Iahp4-Isngi-Igigi+Iappgpi));
    N4=N4+dt*(0.1*(n4-N4)./tn4);
    H4=H4+dt*(0.05*(h4-H4)./th4);
    R4=R4+dt*(1*(r4-R4)./tr4);
    CA4=CA4+dt*(1*10^-4*(-Ica4-It4-kca(3)*CA4));
    a=find(vgi(:,i-1)<-10 & vgi(:,i)>-10);
    u=zeros(n,1); u(a)=gpeak1/(tau*exp(-1))/dt;
    S4=S4+dt*Z4; 
    zdot=u-2/tau*Z4-1/(tau^2)*S4;
    Z4=Z4+dt*zdot;
end

%%Calculation of error index
EI=calculateEI(t,vth,timespike,tmax);

%%Plots membrane potential for one cell in each nucleus
plotpotentials; 

return
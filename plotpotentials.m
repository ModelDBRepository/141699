figure;
subplot(2,2,1); 
ax=plotyy(t,vth(1,:),t,Istim(1:tmax/dt+1));
set(ax(1),'XLim',[0 tmax],'YLim',[-100 20],'Visible','on')
set(ax(2),'XLim',[0 tmax],'YLim',[-2 30],'Visible','off')
title('Thalamic')
ylabel('Vm (mV)'); xlabel('Time (msec)');

subplot(2,2,2); 
plot(t,vsn(1,:));axis([0 tmax -100 80 ]) 
title('STN');
ylabel('Vm (mV)'); xlabel('Time (msec)');

subplot(2,2,3); 
plot(t,vge(1,:));axis([0 tmax -100 80 ]) 
title('GPe')
ylabel('Vm (mV)'); xlabel('Time (msec)');

subplot(2,2,4); 
plot(t,vgi(1,:));axis([0 tmax -100 80 ]) 
title('GPi')
ylabel('Vm (mV)'); xlabel('Time (msec)');

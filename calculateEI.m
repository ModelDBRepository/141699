function er=calculateEI(t,vth,timespike,tmax)
%Calculates the Error Index (EI)

%Input:
%t - time vector (msec)
%vth - Array with membrane potentials of each thalamic cell
%timespike - Time of each SMC input pulse
%tmax - maximum time taken into consideration for calculation

%Output:
%er - Error index

m=size(vth,1);

e=zeros(1,m);
b1=find(timespike>=200, 1 ); %ignore first 200msec
b2=find(timespike<=tmax-25, 1, 'last' ); %ignore last 25 msec

for i=1:m
    clear compare a b
    compare=[];
    k=1;
    for j=2:length(vth(i,:)) 
        if vth(i,j-1)<-40 && vth(i,j)>-40
            compare(k)=t(j);
            k=k+1;
        end
    end
    for p=b1:b2
        if p~=b2
            a=find(compare>=timespike(p) & compare<timespike(p)+25);
            b=find(compare>=timespike(p)+25 & compare<timespike(p+1));
        elseif b2==length(timespike)
            a=find(compare>=timespike(p) & compare<tmax);
            b=[];
        else
            a=find(compare>=timespike(p) & compare<timespike(p+1));
            b=find(compare>=timespike(p)+25 & compare<timespike(p+1));
        end
        if isempty(a)
            e(i)=e(i)+1;
        elseif size(a,2)>1
            e(i)=e(i)+1;
        end
        if ~isempty(b)
            e(i)=e(i)+length(b);
        end
    end

end
er=mean(e/(b2-b1+1));
return
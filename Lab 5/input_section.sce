//start
clc ;
clear ;
//line inputs
linedata = input("Enter line data:")
Yshunt=input("Enter shunt admittance:")
// line data extraction
from= linedata(: ,1) 
to= linedata(: ,2) 
imp= linedata(: ,3)+ linedata(: ,4)*%i 
half_adm= -linedata(: ,5)*%i 
bus_no= max(max(from,to)); 
Ybus= zeros(bus_no,bus_no);
//Ybus building
for i=1:length(from) 
m=from(i);
n=to(i);
Ybus(m,m)=Ybus(m,m) +1/imp(i)+ (half_adm(i)/2) ;
Ybus(n,n)=Ybus(n,n) +1/imp(i)+ (half_adm(i)/2) ;
Ybus(m,n)= -1/ imp(i);
Ybus(n,m)=Ybus(m,n);
end
//Adding shunt to diagonal elements
for i=1:bus_no
    Ybus(i,i)=Ybus(i,i)+Yshunt(i)
end
//display Ybus
disp("Ybus Admittance is:")
disp(Ybus)
//Input and extract bus data. Taps are avoided
busdata = input("Enter bus data:")
bus=busdata(:,1)
typ = busdata(:,2) 
qmin = busdata(:,9) 
qmax = busdata(:,10) 
p= busdata (:,5)-busdata(:,7) 
q= busdata(:,6)-busdata(:,8) 
v= busdata(:,3).*(cosd(busdata(:,4))+ %i*sind(busdata(:,4)));
//parameter setting
alpha=0.25 //default. Can take alpha as input() if needed
count =0;
err =1;
vn(1)=v(1);
vold =v(1);
//gauss seidal method 
while abs(err)>5*10^(-5)
//while count<23 //testing
    for i =2:bus_no
        sumyv =0;
        for j=1:bus_no
            //if i~=j
                sumyv = sumyv +Ybus(i,j)*v(j);
            //end
        end
    if typ(i)==2
        q(i)=-imag(conj(v(i)*sumyv));
        if q(i)<qmin (i) | q(n)>qmax (i)
            vn(i) =(1/Ybus(i,i)) *(((p(i)-%i*q(i))/(conj(v(i)))) -(sumyv-Ybus(i,i)*v(i)));
            vold(i)=v(i);
            v(i)=vn(i);
            typ(i)=3
            if q(i)<qmin (i)
                q(i)= qmin (i);
                else
                q(i)= qmax (i);
            end
        else
            vn(i) =(1/ Ybus(i,i)) *((( p(i)-%i*q(i))/( conj (v(i)))) -(sumyv -Ybus(i,i)*v(i)));
            ang = atan ( imag (vn(i)),real (vn(i)));
            vn(i)= abs (v(i))*( cos ( ang )+%i* sin (ang));
            vold (i)=v(i);
            v(i)=vn(i);
        end
        elseif typ (i)==3
        vn(i) =(1/ Ybus(i,i)) *((( p(i)-%i*q(i))/( conj (v(i)))) -(sumyv -Ybus(i,i)*v(i)));
        vold (i)=v(i);
        v(i)=vn(i);
    end
    end
    err = max(abs(abs(v)-abs(vold))); 
    count = count+1;
    for i=2:bus_no
        if (err>5*10^(-6) & typ(i)==3)
            v(i)= vold(i)+ alpha*(v(i)-vold(i));
        end
    end
end
//disp output
disp("Voltage rectangular:",v)
volt=abs(v)
angle=atan( imag(v),real(v))*(180/%pi);
disp("Voltage:",volt)
disp("Angle:",angle)
printf("Gauss Seidal Load Flow converged after %i iteration.", count)

//please run or read and edit out unnecessary stuff
//start
clc ;
clear ;
//line inputs
disp("Enter the line data in the order-> From,To,Res,Reat,Half Admit,Tap")
linedata =input("Enter line data:")
Yshunt=input("Enter shunt admittance:")
// line data extraction
from= linedata(:,1) 
to= linedata(:,2) 
imp= linedata(:,3)+ linedata(:,4)*%i 
half_adm= linedata(:,5)*%i
bus_no= max(max(from,to)); 
Ybus= zeros(bus_no,bus_no);
line_number=length(from)
//Ybus building
for i=1:line_number 
m=from(i);
n=to(i);
Ybus(m,m)=Ybus(m,m) +1/imp(i)+ (half_adm(i)) ;
Ybus(n,n)=Ybus(n,n) +1/imp(i)+ (half_adm(i)) ;
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
disp("Enter data in the order-> Bus, type, Vsp, theta, Pgi, Qgi, Pli, Qli, Qmin, Qmax")
busdata = input("Enter bus data:")
bus=busdata(:,1)
typ = busdata(:,2) 
qmin = busdata(:,9) 
qmax = busdata(:,10) 
//net p and q
p= busdata (:,5)- busdata(:,7) 
q= busdata(:,6)- busdata(:,8) 
v= busdata(:,3).*(cosd(busdata(:,4))+ %i*sind(busdata(:,4)));
//parameter setting
//default. Can take alpha as input() if needed
count =0;
err =1;
vold =v;
//gauss seidel method 
while abs(err)>5*10^(-5)
//while count<23 //testing
    for i=2:bus_no
            sumyv=0;
            for j=1:bus_no
                if i~=j
                    sumyv=sumyv+Ybus(i,j)*v(j);
                end
            end
        if typ(i)==2
            q(i)=-imag(conj(v(i))*(sumyv+(Ybus(i,i)*v(i))));
            if q(i)<qmin (i) | q(n)>qmax (i)
                if q(i)<qmin (i)
                    q(i)= qmin (i);
                    else
                    q(i)= qmax (i);
                end
            end
        end
        v(i) =(1/Ybus(i,i)) *(((p(i)-%i*q(i))/(conj(v(i)))) -sumyv);
    end
    count=count+1;
    err=max(abs(abs(v)-abs(vold)));
    vold=v;
end
//Load flow and slack power
Amp=zeros(bus_no,bus_no)
Powerflow=zeros(bus_no,bus_no)
Lineloss=zeros(line_number)
slackpower=0
for start=1:bus_no
    for fin=1:bus_no
        if(start~=fin)
            //-Ybus since off diagonal elements are negative
            Amp(start,fin)=-Ybus(start,fin)*(v(start)-v(fin))
            Amp(fin,start)=-Amp(start,fin)
            Powerflow(start,fin)=v(start)*(conj(Amp(start,fin)))
            Powerflow(fin,start)=v(fin)*(conj(Amp(fin,start)))
            Lineloss(start,fin)=Powerflow(start,fin)+Powerflow(fin,start)
            if(start==1)
                slackpower=slackpower+(conj(v(1))*Amp(1,fin))
            end
        end
    end
end
//making sparse and removing duplicates (1,2) and (2,1)
Lineloss_mod=zeros(bus_no,bus_no)
for temp=1:line_number
    m=from(temp)
    n=to(temp)
    Lineloss_mod(m,n)=Lineloss(m,n)
end
Lineloss_mod=sparse(Lineloss_mod)
//disp output
disp("Voltage rectangular:",v)
volt=abs(v)
angle=atan(imag(v),real(v))*(180/%pi);
disp("Voltage:",volt)
disp("Angle:",angle)
printf("Gauss Seidel Load Flow converged after %i iteration.", count)
disp("Line flow",Powerflow)
disp("Line losses",Lineloss_mod)
disp("Slack bus power",slackpower)

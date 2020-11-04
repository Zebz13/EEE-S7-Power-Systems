clc;
clear;
//input
buses=input("Enter the number of buses:")
line=input("Enter the number of lines:")

Ybus=zeros(buses,buses)
net_data=zeros(line,6)
Yshunt=zeros(1,buses)

row=list()
for i=1:line
    row(i)=string(i)
end
row=list2vec(row)

sh_col=list()
for i=1:buses
    sh_col(i)="Bus"+string(i)
end
sh_col=list2vec(sh_col)

column=['From Bus';'To Bus';'Line res';'Line imp';'ycp';'ycq']

net_data=[ 1 2 0.01 0.04 0.08 0.08;
1 3 0 0.1 0 0;
2 3 0.04 0.16 0.09 0.09;
2 5 0.06 0.18 0.08 0.08;
2 5 0.06 0.18 0.08 0.08;
3 4 0 0.1 0 0;
4 5 0.1 0.3 0 0];
Yshunt=[0 0 0 0 0.3]
net_data=resize_matrix(net_data,-1,-1,"constant")
Yshunt=resize_matrix(Yshunt,-1,-1,"constant")
//Extraction
from=net_data(:,1)
to=net_data(:,2)
z=(net_data(:,3)+net_data(:,4)*%i)
ycp=net_data(:,5)*%i
ycq=net_data(:,6)*%i
Yshunt=Yshunt*%i
//logic
for i=1:line
    p=from(i)
    q=to(i)
    Ybus(p,p)=Ybus(p,p)+1/z(i)+ycp(i)
    Ybus(q,q)=Ybus(q,q)+1/z(i)+ycq(i)
    Ybus(p,q)=Ybus(p,q)-1/z(i)
    Ybus(q,p)=Ybus(q,p)-1/z(i)
end
for i=1:buses
    Ybus(i,i)=Ybus(i,i)+Yshunt(i)
end
//display
x_matrix('The Bus Admittance Matrix',Ybus)
disp("The Bus Admittance Matrix")
disp(Ybus)

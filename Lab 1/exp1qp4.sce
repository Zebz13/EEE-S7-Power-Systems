//Program to find the inductance per phase per metre for a 3 phase double circuit line
clc;
clear;
format('v',20)
r=input("Enter the radius of the conductors in cm: ")
GMR=0.7788*r*10^-2
dab=input("Enter the spacing of A and B in ms: ")
dbc=input("Enter the spacing of B and C in ms: ")
dac1=input("Enter the spacing of A and C'' in ms: ")
dbb1=input("Enter the spacing of B and B'' in ms: ")
dca1=input("Enter the spacing of C and A'' in ms: ")
da1b1=input("Enter the spacing of A'' and B'' in ms: ")
db1c1=input("Enter the spacing of B'' and C'' in ms: ")
daa1=(dac1^2+(dab+dbc)^2)^1/2
dab1=(dab^2+dac1^2)^1/2
dcc1=daa1
dba1=dab1
dbc1=dab1
dcb1=dab1
dac=dab+dbc
dc1a1=dac
Ds1=(GMR^2*daa1^2)^(1/4)
Ds2=(GMR^2*dbb1^2)^(1/4)
Ds3=(GMR^2*dcc1^2)^(1/4)
Ds=(Ds1*Ds2*Ds3)^(1/3)
Dab=(dab*dab1*dba1*da1b1)^(1/4)
Dca=(dac*dca1*dac1*dc1a1)^(1/4)
Dbc=(dbc*dbc1*dcb1*db1c1)^(1/4)
Dm=(Dab*Dbc*Dca)^(1/3)
L=10^(-7)*2*(log(Dm/Ds))*1000
disp("The inductance per phase per metre of given transmission line in H/Km is:",L)



clc;
clear;
format('v',20)
d=input("Enter the diameter of the conductors in cm: ")
dab=input("Enter the spacing of A and B in ms: ")
dbc=input("Enter the spacing of B and C in ms: ")
dca=input("Enter the spacing of C and A in ms: ")
r=(d/2)*10^-2
D=(dab*dbc*dca)^(1/3)
L=(0.5+2*log(D/r))*10^-7
Lkm=L*1000
disp("Inductance per phase per km of given transmission line is:",Lkm)

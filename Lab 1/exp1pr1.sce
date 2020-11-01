clc;
clear;
format('v',20)
d=input("Enter the diameter of the conductors in cm: ")
r=(d/2)*10^-2
//Here equi distant. Hence taking only 1 distance(between adjacent pair)
dab=input("Enter the spacing of A and B in ms: ")
//ab*(ab)*(ab*2)
Dm=((dab^3)*2)^(1/3)
L=(0.5+2*log(Dm/r))*(10^-7)
Lkm=L*1000
disp("Inductance per phase per km of given transmission line is:",Lkm)

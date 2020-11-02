//same code for all//
clc;
clear;

format("v",15)

function d=deq(a,b,c)
    d=(a*b*c)^(1/3)
endfunction

function C= singleCap(d,r)
    C=(%pi*8.85*10^(-12))/(log(d/r))
endfunction

function C= threeCap(d,r)
    C=(2*%pi*8.85*10^(-12))/(log(d/r))
endfunction

function I= chargingI(v,f,c)
    I=v*f*c*2*3.14/(3^(1/2))
endfunction

phase=input("Enter the number of phases of system(1 or 3):")
dia=input("Enter diameter of the conductor in cm:")
r=(dia/2)*(10^-2)
fre=input("Enter the frequency(0 if not given): ")
volt=input("Enter the voltage(0 if not given): ")
unit=input("Enter the unit in KM(1 if perkm):")
lunit=unit*1000
if(phase==1) then
    a=input("Enter distance between conductors in m:");
    C=singleCap(a,r)*lunit;
else if (phase==3) then
    a=input("Enter distance between conductors A and B in m:");
    b=input("Enter distance between conductors B and C in m:");
    c=input("Enter distance between conductors C and A in m:")';
    C=threeCap(deq(a,b,c),r)*lunit;
end
end

i=chargingI(volt,fre,C)
disp("Capacitance of line per "+string(unit)+"km = "+string(C));
disp("Charging current = "+string(i));

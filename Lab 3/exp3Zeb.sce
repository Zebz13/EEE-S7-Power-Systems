clc;
clear;

model=input("Enter 0 for T model and 1 for Pi model:")
rkm=input("Enter series resistance per km:")
lkm=input("Enter series reactance per km(with *%i):")
ykm=input("Enter admittance per km(with *%i):")
distance=input("Enter the length in km:")

r=distance*rkm
l=distance*lkm
y=distance*ykm

z=r+l
temp=z*y/2
a=temp+1
d=a

if model==0 then
    b=z*(1+(temp/2))
    c=y
elseif model==1 then
    c=y*(1+(temp/2))
    b=z
end

disp('The values of ABCD parameters are ')
disp('A = ',a)
disp('B = ',b)
disp('C = ',c)
disp('D = ',d)

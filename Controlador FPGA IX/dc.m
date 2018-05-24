% clear all
close all
clc

num_Gm = 1.0626e+10;
den_Gm = [147 406000 6348];
Gm = tf(num_Gm, den_Gm);

num_Gp = [0 -1.40679e+10 2.8566e+14];
den_Gp = [77763 214774000 3.358092000000000e+12];
Gp = tf(num_Gp, den_Gp);
    
%continuous    
s = tf('s');
c_s = 18.493*(5.6e-5*s+1)/(0.00031*s^2+s);
c_s
[num,den] = tfdata(c_s);
num_cs = cell2mat(num);
den_cs = cell2mat(den);

%roots_m = roots(den_m);
%roots_m_num = roots(num_m);

Gfs = feedback((Gp+Gm)*c_s,1);
%discret
Ts = [1/50000];
c_z = c2d(c_s, Ts(1), 'zoh');
c_z
[num,den] = tfdata(c_z);
num_cz = cell2mat(num);
den_cz = cell2mat(den);

%roots_m = roots(den_m);
% num_m(3)/num_m(2)
 
 Gfz = feedback((c2d(Gp, Ts(1), 'zoh')+c2d(Gm, Ts(1), 'zoh'))*c_z,1);
 
 %analise
 step(Gfs);
 hold on
 step(Gfz);
 

 c_z_1 = c2d(c_s,1,'zoh');
 
%  close all
%  figure
%  plot(ySL)
%  figure
%  plot(uSL)
%[z,p,k] = tf2zp(num_m, den_m); 
%sos = zp2sos(z,p,k) ;
%[r,p,k]= residuez(num_m,den_m);%parciais
%para parciais
%A1 = (num_m(2) + num_m(3))/(roots_m(1)-roots_m(2));%/z-1
%A2 = (num_m(2)*0.9375 + num_m(3))/(roots_m(2)-roots_m(1));%/z-0.9375

% c_sym = poly2sym(cell2mat(num),z)/poly2sym(cell2mat(den),z);
% c_iz = iztrans(c_sym)
% pretty(c_iz)
% simplify(c_iz)
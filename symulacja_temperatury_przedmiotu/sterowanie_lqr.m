%% Simulation of control using LQR - creating our plant and conditions
% Optimal control given quadratic cost function
% with weights Q (state) and R (control effort)
sig = 15;
sig2 = 58;
m = 5;
c = 490;
a = 3;
b = 7;
h = 3;
Ph = 5000;
cp = 1005;
density = 1.3;
Pz = 0;
Pt = 50;
To = 20;

a1 = -sig/(a*b*h*cp*density);
a2 = 0;
a3 = sig2/(m*c);
a4 = -sig2/(m*c);

%disturbance power is not measureable so we cannot use it for control
%we cannot use surrounding temperature to control too
b1 = 1/(a*b*h*cp*density);
%b2 = 1/(a*b*h*cp*density);
%b3 = sig/(a*b*h*cp*density);
b4 = 0;
%b5 = 0;
%b6 = 0;

A = [a1, a2; a3, a4];
B = [b1; b4];
C = [1, 0];
D = [0];

system = ss(A, B, C, D);

plant.system = system;
plant.Ph = 5000;
plant.pp_Pz = 0;
plant.pp_Pt = -50;
plant.pp_To = 22;
plant.pp_T =[16.8061, 16.8106];

%% Compensation of non-measured disturbance
conditions.times = 1:1:2000;                                %timesteps of simulations

ampl = 0;                                                  %max increase of disturbance power in W 
dPz = cumsum(ampl*randn(1, length(conditions.times)));      %non-measured disturbance at t
Pz = dPz + plant.pp_Pz;
Pz(Pz < 50) = 50;                                           %bounds keep dist between 50 W and 300 W
Pz(Pz > 300) = 300;
dPz = Pz - plant.pp_Pz;

conditions.Pz = Pz;
conditions.dPz = dPz;
clear Pz;
clear dPz;

conditions.To = plant.pp_To*ones(1, length(conditions.times));%surrounding temperature

%LQR setup
Q = 100;
R = 1;
K = lqr(plant.system, Q, R)
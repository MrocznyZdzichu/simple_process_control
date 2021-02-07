%%
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
%we can use surrounding temperature for state prediction only
b1 = 1/(a*b*h*cp*density);
%b2 = 1/(a*b*h*cp*density);
b3 = sig/(a*b*h*cp*density);
b4 = 0;
%b5 = 0;
b6 = 0;

A = [a1, a2; a3, a4];
B = [b1 b3; b4 b6];
C = [0, 1];
D = [0];

system = ss(A, B, C, D);
system = c2d(system, 1);

plant.system = system;
plant.Ph = 5000;
plant.pp_Pz = 0;
plant.pp_Pt = -50;
plant.pp_To = 22;
plant.pp_T =[16.8061, 16.8106];

conditions.times = 1:1:2000;                                %timesteps of simulations

ampl = 30;                                                  %max increase of disturbance power in W 
dPz = cumsum(ampl*randn(1, length(conditions.times)));      %non-measured disturbance at t
Pz = dPz + plant.pp_Pz;
Pz(Pz < 50) = 50;                                           %bounds keep dist between 50 W and 300 W
Pz(Pz > 300) = 300;
dPz = Pz - plant.pp_Pz;

conditions.Pz = Pz;
conditions.dPz = dPz;
clear Pz;
clear dPz;

conditions.To = -10*ones(1, length(conditions.times));%surrounding temperature
conditions.noise_u = 50;
conditions.noise_y = 0.05;
conditions.SP = plant.pp_T(2)*ones(length(conditions.times));

%we are cheating and pretenting we know all states
u0 = plant.pp_Pt;
y0 = plant.pp_T';
x0 = y0 - plant.pp_T';
%% Kompensacja zakłóceń przy temperaturze -10
u0 = plant.pp_Pt;
y0 = plant.pp_T';

psi1 = 1e4;
psi2 = 1e6;
psi3 = 1e8;
lambda = 1e0;
Ny = 50;
Nu = 5;

[y1, u1] = sim_MPC(plant, conditions, Ny, Nu, psi1, lambda, u0, y0);
[y2, u2] = sim_MPC(plant, conditions, Ny, Nu, psi2, lambda, u0, y0);
[y3, u3] = sim_MPC(plant, conditions, Ny, Nu, psi3, lambda, u0, y0);
%%
figure()
plot(conditions.times, y1(2, :))
hold on
plot(conditions.times, y2(2, :))
hold on
plot(conditions.times, y3(2, :))
hold on
plot(conditions.times, conditions.SP, '--')
legend(sprintf('Psi/Lambda = %d', psi1),sprintf('Psi/Lambda = %d', psi2),...
        sprintf('Psi/Lambda = %d', psi3), 'Wartość zadana')
    %%
    figure()
plot(conditions.times, y1(1, :))
hold on
plot(conditions.times, y2(1, :))
hold on
plot(conditions.times, y3(1, :))
hold on
plot(conditions.times, conditions.SP, '--')
legend(sprintf('Psi/Lambda = %d', psi1),sprintf('Psi/Lambda = %d', psi2),...
        sprintf('Psi/Lambda = %d', psi3), 'Wartość zadana')
    %%
figure()
plot(conditions.times, u1)
hold on
plot(conditions.times, u2)
hold on
plot(conditions.times, u3)
hold on
plot(conditions.times, conditions.Pz)
legend(sprintf('Psi/Lambda = %d', psi1),sprintf('Psi/Lambda = %d', psi2),...
        sprintf('Psi/Lambda = %d', psi3), 'Moc zakłóceń')
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

plant.system = system;
plant.Ph = 5000;
plant.pp_Pz = 0;
plant.pp_Pt = -50;
plant.pp_To = 22;
plant.pp_T =[16.8061, 16.8106];

%% Compensation of non-measured disturbance
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

conditions.To = -3*ones(1, length(conditions.times));%surrounding temperature
conditions.noise_u = 50;
conditions.noise_y = 0.05;
conditions.SP = plant.pp_T(2)*ones(length(conditions.times));

%we are cheating and pretenting we know all states
u0 = plant.pp_Pt;
y0 = plant.pp_T';
x0 = y0 - plant.pp_T';

Q = 1e8;
R = 1;

[y, u] = sim_lqr(plant, conditions, Q, R, u0, y0, x0);

figure()
subplot(2, 1, 1)
plot(conditions.times, y)
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura w degC')
legend('Pomieszczenia', 'Przedmiotu', 'Wartość zadana')
subplot(2, 1, 2)
plot(conditions.times, u)
hold on
plot(conditions.times, conditions.Pz)
legend('Z klimatyzatora', 'Zakłóceń')
ylabel('Moc w W')
xlabel('Czas symulacji w s')

%% Tracking simulation for different R/Q ratio;
conditions.times = 1:1:7000;                               

ampl = 0;                                                  
dPz = cumsum(ampl*randn(1, length(conditions.times)));      
Pz = dPz + plant.pp_Pz;
Pz(Pz < 50) = 50;                                           
Pz(Pz > 300) = 300;
dPz = Pz - plant.pp_Pz;

conditions.Pz = Pz;
conditions.dPz = dPz;
clear Pz;
clear dPz;

conditions.To = -3*ones(1, length(conditions.times));%surrounding temperature
conditions.noise_u = 50;
conditions.noise_y = 0.05;
conditions.SP = plant.pp_T(2)*ones(1, length(conditions.times));
conditions.SP(200:1500) = 22;
conditions.SP(3200:5500) = 10;

%we are cheating and pretenting we know all states
u0 = plant.pp_Pt;
y0 = plant.pp_T';
x0 = y0 - plant.pp_T';

Q1 = 1e8;
Q2 = 1e7;
Q3 = 1e6;
R = 1;

[y1, u1] = sim_lqr(plant, conditions, Q1, R, u0, y0, x0);
[y2, u2] = sim_lqr(plant, conditions, Q2, R, u0, y0, x0);
[y3, u3] = sim_lqr(plant, conditions, Q3, R, u0, y0, x0);

%% Plot the results
figure()
plot(conditions.times, y1(1, :))
hold on
plot(conditions.times, y2(1, :))
hold on
plot(conditions.times, y3(1, :))
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura pomieszczenia w degC')
legend(sprintf('Q/R = %d', Q1), sprintf('Q/R = %d', Q2), sprintf('Q/R = %d', Q3), 'Wartość zadana')
%%
figure()
plot(conditions.times, y1(2, :))
hold on
plot(conditions.times, y2(2, :))
hold on
plot(conditions.times, y3(2, :))
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura przedmiotu w degC')
legend(sprintf('Q/R = %d', Q1), sprintf('Q/R = %d', Q2), sprintf('Q/R = %d', Q3), 'Wartość zadana')
%%
figure()
plot(conditions.times, u1)
hold on
plot(conditions.times, u2)
hold on
plot(conditions.times, u3)
legend(sprintf('Q/R = %d', Q1), sprintf('Q/R = %d', Q2), sprintf('Q/R = %d', Q3))
ylabel('Moc w W')
xlabel('Czas symulacji w s')

%% Full simulation;
conditions.times = 1:1:7000;                               

ampl = 50;                                                  
dPz = cumsum(ampl*randn(1, length(conditions.times)));      
Pz = dPz + plant.pp_Pz;
Pz(Pz < 50) = 50;                                           
Pz(Pz > 300) = 300;
dPz = Pz - plant.pp_Pz;

conditions.Pz = Pz;
conditions.dPz = dPz;
clear Pz;
clear dPz;

conditions.To = -3*ones(1, length(conditions.times));%surrounding temperature
conditions.noise_u = 50;
conditions.noise_y = 0.05;
conditions.SP = plant.pp_T(2)*ones(1, length(conditions.times));
conditions.SP(200:1500) = 22;
conditions.SP(3200:5500) = 10;

%we are cheating and pretenting we know all states
u0 = plant.pp_Pt;
y0 = plant.pp_T';
x0 = y0 - plant.pp_T';

Q1 = 1e8;
Q2 = 1e7;
Q3 = 1e6;
R = 1;

[y1, u1] = sim_lqr(plant, conditions, Q1, R, u0, y0, x0);
[y2, u2] = sim_lqr(plant, conditions, Q2, R, u0, y0, x0);
[y3, u3] = sim_lqr(plant, conditions, Q3, R, u0, y0, x0);

%% Plot the results
figure()
plot(conditions.times, y1(1, :))
hold on
plot(conditions.times, y2(1, :))
hold on
plot(conditions.times, y3(1, :))
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura pomieszczenia w degC')
legend(sprintf('Q/R = %d', Q1), sprintf('Q/R = %d', Q2), sprintf('Q/R = %d', Q3), 'Wartość zadana')
%%
figure()
plot(conditions.times, y1(2, :))
hold on
plot(conditions.times, y2(2, :))
hold on
plot(conditions.times, y3(2, :))
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura przedmiotu w degC')
legend(sprintf('Q/R = %d', Q1), sprintf('Q/R = %d', Q2), sprintf('Q/R = %d', Q3), 'Wartość zadana')
%%
figure()
plot(conditions.times, u1)
hold on
plot(conditions.times, u2)
hold on
plot(conditions.times, u3)
legend(sprintf('Q/R = %d', Q1), sprintf('Q/R = %d', Q2), sprintf('Q/R = %d', Q3))
ylabel('Moc w W')
xlabel('Czas symulacji w s')

%% Comparison of observers
conditions.times = 1:1:7000;                               

ampl = 50;                                                  
dPz = cumsum(ampl*randn(1, length(conditions.times)));      
Pz = dPz + plant.pp_Pz;
Pz(Pz < 50) = 50;                                           
Pz(Pz > 300) = 300;
dPz = Pz - plant.pp_Pz;

conditions.Pz = Pz;
conditions.dPz = dPz;
clear Pz;
clear dPz;

conditions.To = -3*ones(1, length(conditions.times));%surrounding temperature
conditions.noise_u = 50;
conditions.noise_y = 0.05;
conditions.SP = plant.pp_T(2)*ones(1, length(conditions.times));
conditions.SP(200:1500) = 22;
conditions.SP(3200:5500) = 10;

%we are cheating and pretenting we know all states
u0 = plant.pp_Pt;
y0 = plant.pp_T';
x0 = y0 - plant.pp_T';

Q1 = 1e7;
R = 1;

[y1, u1] = sim_lqr(plant, conditions, Q1, R, u0, y0, x0);
[y2, u2] = sim_lqr(plant, conditions, Q1, R, u0, y0, x0, 'Luenberg', [-0.3, -0.7]);
[y3, u3] = sim_lqr(plant, conditions, Q1, R, u0, y0, x0, 'Kalman', [50, 1e-5]);

%%
figure()
plot(conditions.times, y1(2, :))
hold on
plot(conditions.times, y2(2, :))
hold on
plot(conditions.times, y3(2, :))
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura przedmiotu w degC')
legend('Pomiar stanu', 'Obserwator Luenberga', 'Obserwator Kalmana', 'Wartość zadana')
%%
figure()
plot(conditions.times, y1(1, :))
hold on
plot(conditions.times, y2(1, :))
hold on
plot(conditions.times, y3(1, :))
hold on
plot(conditions.times, conditions.SP, '--')
ylabel('Temperatura pomieszczenia w degC')
legend('Pomiar stanu', 'Obserwator Luenberga', 'Obserwator Kalmana', 'Wartość zadana')
%%
figure()
plot(conditions.times, u1)
hold on
plot(conditions.times, u2)
hold on
plot(conditions.times, u3)
hold on
plot(conditions.times, conditions.Pz)
ylabel('Temperatura przedmiotu w degC')
legend('Pomiar stanu', 'Obserwator Luenberga', 'Obserwator Kalmana', 'Moc zakłóceń')
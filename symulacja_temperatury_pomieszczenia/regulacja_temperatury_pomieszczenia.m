%% 
Pt = 0;
Pz = 0;
dTdt = @(t, T) (Pz + Pt-sig*(T-T0))/(a*b*h*c*den); 

%% Symulacja spod manuala w okolicach punktu pracy
times = [0:60:10800];
Pt = -60*ones(1, length(times));
T0 = 22*ones(1, length(times));

[t, y, z] = sim_manual_dist(times, 0, 18, Pt, T0, 1);
%% Utworzenie modelu liniowego
a = 3;
b = 7;
h = 3;
Ph = 3500;
c = 1005;
sig = 15;
den = 1.3;
Pz = 0;
Pt = -60;
T0 = 22;

syms Pz Pt T
dT = (Pz + Pt-sig*(T-T0))/(a*b*h*c*den);
dTdPz = double(diff(dT, Pz))
dTdPt = double(diff(dT, Pt))
dTdT = double(diff(dT, T))

A = dTdT;
B = [dTdPt, dTdPz];
C = 1;
D = 0;

ss_system = ss(A,B,C,D);
ssd_system = c2d(ss_system, 0.5, 'tustin');
%% Porównanie dokładnej symulacji obiektu z symulacja przy pomocy modelu liniowego
pp_T0 = 22;
pp_T = 18;
pp_Pz = 0;
pp_Pt = -60;

times = [0:60:2*3600];
Pt = -60*ones(1, length(times));
T0 = 12*ones(1, length(times));
y0 = 15;
[t1, y1, z] = sim_manual_dist(times, 0, y0, Pt, T0, 0);
plot(t1,y1)
hold on

u = ones(length(times), 2);
u(:, 1) = Pt;
u(:, 2) = z;
%wspolrzedne odchylek
u(:, 1) = u(:, 1) - pp_Pt;
[y, t] = lsim(ss_system, u, times, y0-pp_T);

%wspolrzedne fizyczne
y = y+pp_T;
plot(t, y)
legend('Model dokładny', 'Model liniowy')
%% porownanie w obecnosci silnych zaklóceń w pobliżu punktu pracy
pp_T0 = 22;
pp_T = 18;
pp_Pz = 0;
pp_Pt = -60;

times = [0:60:2*3600];
Pt = -60*ones(1, length(times));
T0 = 12*ones(1, length(times));
y0 = 10;

[t1, y1, z] = sim_manual_dist(times, 10, y0, Pt, T0, 0);
plot(t1,y1)
hold on

u = ones(length(times), 2);
u(:, 1) = Pt;
u(:, 2) = z;
%wspolrzedne odchylek
u(:, 1) = u(:, 1) - pp_Pt;
[y, t] = lsim(ss_system, u, times, y0-pp_T)

%wspolrzedne fizyczne
y = y+pp_T;
plot(t, y)
legend('Model dokładny', 'Model liniowy')
%% porownanie poza punktem pracy
pp_T0 = 22;
pp_T = 18;
pp_Pz = 0;
pp_Pt = -60;

times = [0:60:2*3600];
Pt = 1200*ones(1, length(times));
T0 = 12*ones(1, length(times));
y0 = 10;
[t1, y1, z] = sim_manual_dist(times, 0, y0, Pt, T0, 0);
plot(t1,y1)
hold on

u = ones(length(times), 2);
u(:, 1) = Pt;
u(:, 2) = z;
%wspolrzedne odchylek
u(:, 1) = u(:, 1) - pp_Pt;
[y, t] = lsim(ss_system, u, times, y0-pp_T)

%wspolrzedne fizyczne
y = y+pp_T;
plot(t, y)
legend('Model dokładny', 'Model liniowy')
%% LQR - powrót do punktu pracy
times = [1:2:600];
ampl = 0;
zakl = cumsum(ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
ampl = 0;
y0 = 18;
T0 = -10*ones(1, length(times));

R1 = 1e5;
Q1 = 1;

R2 = 1e6;
Q2 = 1;

R3 = 1e7;
Q3 = 1;

[t1, y1, u1] = sim_lqr(times, ss_system, SP, zakl, y0, R1, Q1, T0, 0);
[t2, y2, u2] = sim_lqr(times, ss_system, SP, zakl, y0, R2, Q2, T0, 0);
[t3, y3, u3] = sim_lqr(times, ss_system, SP, zakl, y0, R3, Q3, T0, 0);

figure()
subplot(2, 1, 1)
plot(t1, y1)
ylabel('Temperatura w degC')
hold on
plot(t2, y2)
hold on
plot(t3, y3)
legend(sprintf('R = %.f', R1), sprintf('R = %.f', R2), sprintf('R = %.f', R3));

subplot(2, 1, 2)
plot(t1, u1)
hold on
plot(t2, u2)
hold on
plot(t3, u3)
xlabel('Czas symulacji w s')
ylabel('Moc działania klimatyzatora w W')
legend(sprintf('R = %.f', R1), sprintf('R = %.f', R2), sprintf('R = %.f', R3));
%% Kompensacja zakłóceń
times = [1:2:600];
ampl = 200;
zakl = (ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
ampl = 0;
y0 = 18;
T0 = 22*ones(1, length(times));

R1 = 1e5;
Q1 = 1;

R2 = 1e6;
Q2 = 1;

R3 = 1e7;
Q3 = 1;

[t1, y1, u1] = sim_lqr(times, ss_system, SP, zakl, y0, R1, Q1, T0, 0);
[t2, y2, u2] = sim_lqr(times, ss_system, SP, zakl, y0, R2, Q2, T0, 0);
[t3, y3, u3] = sim_lqr(times, ss_system, SP, zakl, y0, R3, Q3, T0, 0);

figure()
subplot(2, 1, 1)
plot(t1, y1)
ylabel('Temperatura w degC')
hold on
plot(t2, y2)
hold on
plot(t3, y3)
legend(sprintf('R = %.f', R1), sprintf('R = %.f', R2), sprintf('R = %.f', R3));

subplot(2, 1, 2)
plot(t1, u1)
hold on
plot(t2, u2)
hold on
plot(t3, u3)
xlabel('Czas symulacji w s')
ylabel('Moc działania klimatyzatora w W')
legend(sprintf('R = %.f', R1), sprintf('R = %.f', R2), sprintf('R = %.f', R3));

%% Test nadążania 1
times = [1:1:3600];
ampl = 0;
zakl = (ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
SP(300:1200) = 25;
SP(1201:3600) = 15;
ampl = 0;
y0 = 18;
T0 = 22*ones(1, length(times));

R1 = 1e5;
Q1 = 1;

R2 = 1e6;
Q2 = 1;

R3 = 1e7;
Q3 = 1;

[t1, y1, u1] = sim_lqr(times, ss_system, SP, zakl, y0, R1, Q1, T0, 0);
[t2, y2, u2] = sim_lqr(times, ss_system, SP, zakl, y0, R2, Q2, T0, 0);
[t3, y3, u3] = sim_lqr(times, ss_system, SP, zakl, y0, R3, Q3, T0, 0);

figure()
subplot(2, 1, 1)
plot(t1, y1)
ylabel('Temperatura w degC')
hold on
plot(t2, y2)
hold on
plot(t3, y3)
hold on
plot(times, SP, '--')
legend(sprintf('R = %.f', R1), sprintf('R = %.f', R2), sprintf('R = %.f', R3), 'Wartość zadana');

subplot(2, 1, 2)
plot(t1, u1)
hold on
plot(t2, u2)
hold on
plot(t3, u3)
xlabel('Czas symulacji w s')
ylabel('Moc działania klimatyzatora w W')
legend(sprintf('R = %.f', R1), sprintf('R = %.f', R2), sprintf('R = %.f', R3));


%% Sprzeżenie od stanu metodą dobierania biegunów - test powrotu do punktu pracy
times = [1:30:1200];
ampl = 0;
zakl = (ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
ampl = 0;
y0 = 25;
T0 = 22*ones(1, length(times));

p1 = -0.005;
[t1, y1, u1] = sim_pole_placement(times, ss_system, SP, zakl, y0, p1, T0, 0);

p2 = -0.01;
[t2, y2, u2] = sim_pole_placement(times, ss_system, SP, zakl, y0, p2, T0, 0);

p3 = -0.02;
[t3, y3, u3] = sim_pole_placement(times, ss_system, SP, zakl, y0, p3, T0, 0);

figure()
subplot(2, 1, 1)
plot(t1, y1)
hold on
plot(t2, y2)
hold on
plot(t3, y3)
ylabel('Temperatura w degC')
legend(sprintf('Biegun = %.3f',p1), sprintf('Biegun = %.3f',p2), sprintf('Biegun = %.3f',p3));

subplot(2, 1, 2)
plot(t1, u1)
hold on
plot(t2, u2)
hold on
plot(t3, u3)
ylabel('Moc z klmatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('Biegun = %.3f',p1), sprintf('Biegun = %.3f',p2), sprintf('Biegun = %.3f',p3));


%% place - kompensacja zakłóceń
times = [1:1:1200];
ampl = 200;
zakl = (ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
ampl = 0;
y0 = 18;
T0 = 22*ones(1, length(times));

p1 = -0.005;
[t1, y1, u1] = sim_pole_placement(times, ss_system, SP, zakl, y0, p1, T0, 0);

p2 = -0.01;
[t2, y2, u2] = sim_pole_placement(times, ss_system, SP, zakl, y0, p2, T0, 0);

p3 = -0.02;
[t3, y3, u3] = sim_pole_placement(times, ss_system, SP, zakl, y0, p3, T0, 0);

figure()
subplot(2, 1, 1)
plot(t1, y1)
hold on
plot(t2, y2)
hold on
plot(t3, y3)
ylabel('Temperatura w degC')
legend(sprintf('Biegun = %.3f',p1), sprintf('Biegun = %.3f',p2), sprintf('Biegun = %.3f',p3));

subplot(2, 1, 2)
plot(t1, u1)
hold on
plot(t2, u2)
hold on
plot(t3, u3)
ylabel('Moc z klmatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('Biegun = %.3f',p1), sprintf('Biegun = %.3f',p2), sprintf('Biegun = %.3f',p3));


%% place - test nadążania
times = [1:1:1200];
ampl = 0;
zakl = (ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
SP(200:500) = 22;
SP(501:750) = 18;
SP(751:1200) = 14;

y0 = 18;
T0 = 22*ones(1, length(times));

p1 = -0.025;
[t1, y1, u1] = sim_pole_placement(times, ss_system, SP, zakl, y0, p1, T0, 0);

p2 = -0.035;
[t2, y2, u2] = sim_pole_placement(times, ss_system, SP, zakl, y0, p2, T0, 0);

p3 = -0.1;
[t3, y3, u3] = sim_pole_placement(times, ss_system, SP, zakl, y0, p3, T0, 0);

figure()
subplot(2, 1, 1)
plot(t1, y1)
hold on
plot(t2, y2)
hold on
plot(t3, y3)
hold on
plot(t3, SP, '--')
ylabel('Temperatura w degC')
legend(sprintf('Biegun = %.3f',p1), sprintf('Biegun = %.3f',p2), sprintf('Biegun = %.3f',p3));

subplot(2, 1, 2)
plot(t1, u1)
hold on
plot(t2, u2)
hold on
plot(t3, u3)
ylabel('Moc z klmatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('Biegun = %.3f',p1), sprintf('Biegun = %.3f',p2), sprintf('Biegun = %.3f',p3));


%% MPC - dla ułatwienia dane we współrzędnych odchyłek kompensacja zakłóceń
psi = 1e1;
lambda = 1e0;
p = 100;
m = 5;

pp_Pt = -60;
pp_Pz = 0;
pp_T = 18;

umin = -3500+pp_Pt;
umax = 3500+pp_T;

times = [0:ssd_system.Ts:600];
t0 = times(1);
ampl = 50;
zakl = (ampl*randn(1,length(times)));

y0 = 18-pp_T;
SP = 18*ones(length(times)+p, 1)-pp_T;
T0 = 22*ones(length(times), 1);

[y,u] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi, lambda, times, zakl, y0, SP, T0);
psi2 = 1e2;
[y2,u2] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi2, lambda, times, zakl, y0, SP, T0);
psi3 = 1e3;
[y3,u3] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi3, lambda, times, zakl, y0, SP, T0);

figure()
subplot(2,1,1)
plot(times, y+pp_T)
hold on
plot(times, y2+pp_T)
hold on
plot(times, y3+pp_T)
hold on
plot(times, SP(1:length(times))+pp_T, '--')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3), 'Wartość zadana');
ylabel('Temperatura powietrza w degC')
subplot(2,1,2)
plot(times, u+pp_Pt)
hold on
plot(times, u2+pp_Pt)
hold on
plot(times, u3+pp_Pt)
ylabel('Moc z klimatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3))

%% Nadążanie
psi = 1e1;
lambda = 1e0;
p = 100;
m = 5;

pp_Pt = -60;
pp_Pz = 0;
pp_T = 18;

umin = -3500+pp_Pt;
umax = 3500+pp_T;

times = [0:ssd_system.Ts:3600];
t0 = times(1);
ampl = 0;
zakl = (ampl*randn(1,length(times)));

y0 = 18-pp_T;
SP = 18*ones(length(times)+p, 1)-pp_T;
SP(600:1500) = 26-pp_T;
SP(1501:2600) = 12-pp_T;
T0 = 22*ones(length(times), 1);

[y,u] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi, lambda, times, zakl, y0, SP, T0);
psi2 = 1e2;
[y2,u2] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi2, lambda, times, zakl, y0, SP, T0);
psi3 = 1e3;
[y3,u3] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi3, lambda, times, zakl, y0, SP, T0);

figure()
subplot(2,1,1)
plot(times, y+pp_T)
hold on
plot(times, y2+pp_T)
hold on
plot(times, y3+pp_T)
hold on
plot(times, SP(1:length(times))+pp_T, '--')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3), 'Wartość zadana');
ylabel('Temperatura powietrza w degC')
subplot(2,1,2)
plot(times, u+pp_Pt)
hold on
plot(times, u2+pp_Pt)
hold on
plot(times, u3+pp_Pt)
ylabel('Moc z klimatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3))

%% MPC - wszystko razem
psi = 1e1;
lambda = 1e0;
p = 100;
m = 5;

pp_Pt = -60;
pp_Pz = 0;
pp_T = 18;

umin = -3500+pp_Pt;
umax = 3500+pp_T;

times = [0:ssd_system.Ts:3600];
t0 = times(1);
ampl = 200;
zakl = (ampl*randn(1,length(times)));

y0 = 18-pp_T;
SP = 18*ones(length(times)+p, 1)-pp_T;
SP(600:1500) = 24-pp_T;
SP(1501:2600) = 16-pp_T;
T0 = 22*ones(length(times), 1);

[y,u] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi, lambda, times, zakl, y0, SP, T0);
psi2 = 1e2;
[y2,u2] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi2, lambda, times, zakl, y0, SP, T0);
psi3 = 1e3;
[y3,u3] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi3, lambda, times, zakl, y0, SP, T0);

figure()
subplot(2,1,1)
plot(times, y+pp_T)
hold on
plot(times, y2+pp_T)
hold on
plot(times, y3+pp_T)
hold on
plot(times, SP(1:length(times))+pp_T, '--')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3), 'Wartość zadana');
ylabel('Temperatura powietrza w degC')
subplot(2,1,2)
plot(times, u+pp_Pt)
hold on
plot(times, u2+pp_Pt)
hold on
plot(times, u3+pp_Pt)
ylabel('Moc z klimatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3))

%% Test z inną temperaturą otoczenia
psi = 1e1;
lambda = 1e0;
p = 100;
m = 12;

pp_Pt = -60;
pp_Pz = 0;
pp_T = 18;

umin = -3500+pp_Pt;
umax = 3500+pp_T;

times = [0:ssd_system.Ts:3600];
t0 = times(1);
ampl = 500;
zakl = (ampl*randn(1,length(times)));

y0 = 18-pp_T;
SP = 18*ones(length(times)+p, 1)-pp_T;
SP(600:1500) = 24-pp_T;
SP(1501:2600) = 16-pp_T;
T0 = -5*ones(length(times), 1);

[y,u] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi, lambda, times, zakl, y0, SP, T0);
psi2 = 1e2;
[y2,u2] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi2, lambda, times, zakl, y0, SP, T0);
psi3 = 1e3;
[y3,u3] = sim_MPC(ssd_system, 1, umin, umax, p, m, psi3, lambda, times, zakl, y0, SP, T0);

figure()
subplot(2,1,1)
plot(times, y+pp_T)
hold on
plot(times, y2+pp_T)
hold on
plot(times, y3+pp_T)
hold on
plot(times, SP(1:length(times))+pp_T, '--')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3), 'Wartość zadana');
ylabel('Temperatura powietrza w degC')
subplot(2,1,2)
plot(times, u+pp_Pt)
hold on
plot(times, u2+pp_Pt)
hold on
plot(times, u3+pp_Pt)
ylabel('Moc z klimatyzatora w W')
xlabel('Czas symulacji w s')
legend(sprintf('psi = %.f', psi), sprintf('psi = %.f', psi2), sprintf('psi = %.f', psi3))


%% PID - regulator P
times = [0:1:3600];

SP = 18*ones(1, length(times));
SP(1: 800) = 8;
SP(801: 1700) = 18;
SP(1701:2500) = 30;

y0 = 22;
To = 7*ones(1, length(times));
ampl = 1500;
zakl = ampl*randn(1, length(times));

K1 = 500;
K2 = 1000;
K3 = 5000;
I = 0;
D = 0;

[y1, u1] = sim_PID(K1, I, D, To, y0, SP,zakl, times, Ph);
[y2, u2] = sim_PID(K2, I, D, To, y0, SP,zakl, times, Ph);
[y3, u3] = sim_PID(K3, I, D, To, y0, SP,zakl, times, Ph);

figure()
subplot(2, 1, 1)
plot(times, y1)
hold on
plot(times, y2)
hold on
plot(times, y3)
hold on
plot(times, SP, '--')
title(sprintf('Temperatura otoczenia: %.1f degC, I = 0, D = 0', To(1)))
ylabel('Temperatura pomieszczenia w degC');
legend(sprintf('K = %0.f', K1), sprintf('K = %0.f', K2), sprintf('K = %0.f', K3), 'Wartość zadana');
subplot(2,1,2)
plot(times, [0,u1])
hold on
plot(times, [0,u2])
hold on
plot(times, [0,u3])
hold on
ylabel('Moc z klimatyzatora w W');
xlabel('Czas w s');


%% PID - regulator PD
times = [0:1:3600];

SP = 18*ones(1, length(times));
SP(1: 800) = 8;
SP(801: 1700) = 18;
SP(1701:2500) = 30;

y0 = 22;
To = 7*ones(1, length(times));
ampl = 1500;
zakl = ampl*randn(1, length(times));

K1 = 700;
K2 = 700;
K3 = 700;
I = 0;
D1 = 1;
D2 = 10;
D3 = 50;

[y1, u1] = sim_PID(K1, I, D1, To, y0, SP,zakl, times, Ph);
[y2, u2] = sim_PID(K2, I, D2, To, y0, SP,zakl, times, Ph);
[y3, u3] = sim_PID(K3, I, D3, To, y0, SP,zakl, times, Ph);

figure()
subplot(2, 1, 1)
plot(times, y1)
hold on
plot(times, y2)
hold on
plot(times, y3)
hold on
plot(times, SP, '--')
title(sprintf('Temperatura otoczenia: %.0f degC, K = 700, I = 0', To(1)))
ylabel('Temperatura pomieszczenia w degC');
legend(sprintf('D = %0.f', D1), sprintf('D = %0.f', D2), sprintf('D = %0.f', D3), 'Wartość zadana');
subplot(2,1,2)
plot(times, [0,u1])
hold on
plot(times, [0,u2])
hold on
plot(times, [0,u3])
hold on
ylabel('Moc z klimatyzatora w W');
xlabel('Czas w s');


%% PID - regulator PI
times = [0:1:3600];

SP = 18*ones(1, length(times));
SP(1: 800) = 8;
SP(801: 1700) = 18;
SP(1701:2500) = 30;

y0 = 22;
To = 7*ones(1, length(times));
ampl = 1500;
zakl = ampl*randn(1, length(times));

K1 = 500;
K2 = 500;
K3 = 500;
I1 = 0;
I2 = 0.002;
I3 = 0.005;
D1 = 0;
D2 = 0;
D3 = 0;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP,zakl, times);
[y2, u2] = sim_PID(K2, I2, D2, To, y0, SP,zakl, times);
[y3, u3] = sim_PID(K3, I3, D3, To, y0, SP,zakl, times);

figure()
subplot(2, 1, 1)
plot(times, y1)
hold on
plot(times, y2)
hold on
plot(times, y3)
hold on
plot(times, SP, '--')
ylabel('Temperatura pomieszczenia w degC');
legend(sprintf('I = %.3f', I1), sprintf('I = %.3f', I2), sprintf('I = %.3f', I3), 'Wartość zadana');
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
ylabel('Moc z klimatyzatora w W');
xlabel('Czas w s');


%% PID - regulator PID
times = [0:1:3600];

SP = 18*ones(1, length(times));
SP(1: 800) = 8;
SP(801: 1700) = 18;
SP(1701:2500) = 30;

y0 = 22;
To = 7*ones(1, length(times));
ampl = 1500;
zakl = ampl*randn(1, length(times));

K1 = 500;
K2 = 500;
K3 = 500;
I1 = 0.00005;
I2 = 0.0002;
I3 = 0.0005;
D1 = 5;
D2 = 5;
D3 = 5;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP,zakl, times);
[y2, u2] = sim_PID(K2, I2, D2, To, y0, SP,zakl, times);
[y3, u3] = sim_PID(K3, I3, D3, To, y0, SP,zakl, times);

figure()
subplot(2, 1, 1)
plot(times, y1)
hold on
plot(times, y2)
hold on
plot(times, y3)
hold on
plot(times, SP, '--')
ylabel('Temperatura pomieszczenia w degC');
legend(sprintf('I = %.5f', I1), sprintf('I = %.5f', I2), sprintf('I = %.5f', I3), 'Wartość zadana');
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
ylabel('Moc z klimatyzatora w W');
xlabel('Czas w s');
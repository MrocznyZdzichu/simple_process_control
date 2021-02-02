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


%% Test
times = [1:1:3600];
ampl = 1500;
zakl = (ampl*randn(1,length(times)));

SP = 18*ones(1, length(times));
SP(300:1200) = 26;
SP(1201:2600) = 12;
ampl = 0;
y0 = 12;
T0 = 15*ones(1, length(times));

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
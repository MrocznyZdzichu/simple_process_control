%% Tworzymy model liniowy
%mierzalnym zakloceniem jest temperatura otoczenia, wiec uwzgledniamy w
%modelu
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

b1 = 1/(a*b*h*cp*density);
%b2 = 1/(a*b*h*cp*density);
b3 = sig/(a*b*h*cp*density);
b4 = 0;
%b5 = 0;
b6 = 0;

A = [a1, a2; a3, a4];
B = [b1, b3; b4, b6];
C = [1, 0];
D = [0, 0];

system = ss(A, B, C, D);
%% Komepensacja zakłóceń
Q = 50;
R1 = 6e-5;
R2 = 10e-5;
R3 = 5e-5;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0;
noise_u = 0;

times = [0:1:600];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));

To = pp_To*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 2), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Moc z klmatyzatora [W]')
xlabel('Czas obserwacji [s]')

%% Komepensacja zakłóceń - z szumem stanu i wyjścia
Q = 50;
R1 = 6e-5;
R2 = 10e-5;
R3 = 5e-5;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0.05;
noise_u = 50;

times = [0:1:600];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));

To = pp_To*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 2), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Moc z klmatyzatora [W]')
xlabel('Czas obserwacji [s]')

%% Test nadążania
Q = 50;
R1 = 1e-1;
R2 = 1e-2;
R3 = 1e-4;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0;
noise_u = 0;

times = [0:1:7000];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));

To = pp_To*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
SP(1000:2500) = pp_T(2) + 9;
SP(3800:5000) = pp_T(2) - 6;
SP(5001:6000) = pp_T(2) + 3;
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 1), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %d', R1), sprintf('R = %d', R2), sprintf('R = %d', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Moc z klmatyzatora [W]')
xlabel('Czas obserwacji [s]')

%% Test nadążania z szumem
Q = 50;
R1 = 1e-1;
R2 = 1e-2;
R3 = 1e-4;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0.05;
noise_u = 50;

times = [0:1:7000];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));

To = pp_To*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
SP(1000:2500) = pp_T(2) + 9;
SP(3800:5000) = pp_T(2) - 6;
SP(5001:6000) = pp_T(2) + 3;
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 1), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %d', R1), sprintf('R = %d', R2), sprintf('R = %d', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Temperatura pomieszczenia [degC]')
xlabel('Czas obserwacji [s]')

%% Test nadążania z zakłóceniami
Q = 50;
R1 = 1e-1;
R2 = 1e-2;
R3 = 1e-4;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0;
noise_u = 0;

times = [0:1:7000];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));

To = pp_To*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
SP(1000:3500) = pp_T(2) + 9;
SP(3501:5900) = pp_T(2) - 6;
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 1), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %d', R1), sprintf('R = %d', R2), sprintf('R = %d', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Temperatura pomieszczenia [degC]')
xlabel('Czas obserwacji [s]')

%% Test nadążania z dla temperatury otoczenia jak za oknem
Q = 50;
R1 = 1e-1;
R2 = 1e-2;
R3 = 1e-4;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0;
noise_u = 0;

times = [0:1:7000];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));

To = 2*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
SP(1000:3500) = pp_T(2) + 9;
SP(3501:5900) = pp_T(2) - 6;
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 1), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f. To = 2 degC', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %d', R1), sprintf('R = %d', R2), sprintf('R = %d', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Temperatura pomieszczenia [degC]')
xlabel('Czas obserwacji [s]')

%% Test nadążania z dla temperatury otoczenia jak za oknem z szumem pomiarowym
Q = 50;
R1 = 1e-1;
R2 = 1e-2;
R3 = 1e-4;

k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0.05;
noise_u = 50;

times = [0:1:7000];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));

To = 2*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
SP(1000:3500) = pp_T(2) + 9;
SP(3501:5900) = pp_T(2) - 6;
%We wspolrzednych odchylek
x_est = [0; 0];

[y1, u1] = sim_poles_kalman(system, Q, R1, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y2, u2] = sim_poles_kalman(system, Q, R2, k, noise_u, noise_y,[0;0], times, Pz, SP, To);
[y3, u3] = sim_poles_kalman(system, Q, R3, k, noise_u, noise_y,[0;0], times, Pz, SP, To);

subplot(2, 1, 1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP(:, 1), '--')
title(sprintf('Porównanie regulatorów z obserwatorem Kalmana. Bieguny sprzężenia: %.2f, %.2f. To = 2 degC', k))
ylabel('Temperatura przedmiotu [degC]')
legend(sprintf('R = %d', R1), sprintf('R = %d', R2), sprintf('R = %d', R3), 'Wartość zadana');
subplot(2, 1, 2)
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
legend(sprintf('R = %.6f', R1), sprintf('R = %.6f', R2), sprintf('R = %.6f', R3))
ylabel('Temperatura pomieszczenia [degC]')
xlabel('Czas obserwacji [s]')
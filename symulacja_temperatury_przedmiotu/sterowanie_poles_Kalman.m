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
R = 6e-5;
k = [-0.1, -0.5];
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

noise_y = 0;
noise_u = 0;

times = [0:1:600];
ampl = 50;

To = pp_To*ones(1, length(times));
SP = pp_T(2)*ones(length(times), 2);
%We wspolrzednych odchylek
x_est = [0; 0];

[y, u] = sim_poles_kalman(system, Q, R, k, noise_u, noise_y,[0;0], times, ampl, SP, To);

subplot(2, 1, 1)
plot(times, y)
hold on
plot(times, y2e)
hold on
plot(times, SP(:, 2), '--')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartość zadana');
subplot(2, 1, 2)
plot(times, u)
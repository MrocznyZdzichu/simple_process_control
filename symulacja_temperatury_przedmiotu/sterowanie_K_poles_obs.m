% Wykorzystujemy obserwator, nie mierzymy temperatury pomieszczenia
%% Tworzymy model liniowy
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
b2 = 1/(a*b*h*cp*density);
b3 = sig/(a*b*h*cp*density);
b4 = 0;
b5 = 0;
b6 = 0;

A = [a1, a2; a3, a4];
B = [b1, b2, b3; b4, b5, b6];
C = [0, 1];
D = [0, 0, 0];

system = ss(A, B, C, D);
dsystem=c2d(system, 1);
%% Symulacja kompensacji zakłóceń
K1 = place(A, B(:, 1), [-0.1 -0.5]);
L1 = place(A', C', [-1.2, -1])';

K2 = place(A, B(:, 1), [-0.3 -0.7]);
L2 = place(A', C', [-1.2, -1.5])';

K3 = place(A, B(:, 1), [-0.1 -0.5]);
L3 = place(A', C', [-1.5, -2])';

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:600];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = pp_Pt;

SP = pp_T(2)*ones(length(times), 2);
%We wspolrzednych odchylek
est_x = [0; 0];

[y1, u1] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 0, 0);
[y2, u2] = sim_Kpoles_obs(times, y, dsystem, K2, L2, SP, Pz, To, est_x, 0, 0);
[y3, u3] = sim_Kpoles_obs(times, y, dsystem, K3, L3, SP, Pz, To, est_x, 0, 0);
[y4, u4] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);

figure()
subplot(2, 2, 1)
plot(times, y1)
hold on
plot(times, SP, '--')
title('Bieguny K = [-0.1 -0.5], bieguny L = [-1.2, -1.5]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 2)
plot(times, y2)
hold on
plot(times, SP, '--')
title('Bieguny K = [-0.3 -0.7], bieguny L = [-1.2, -1.5]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 3)
plot(times, y3)
hold on
plot(times, SP, '--')
title('Bieguny K = [-0.1 -0.5], bieguny L = [-1.5, -2]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 4)
plot(times, y4)
hold on
plot(times, SP, '--')
title('Bieguny K = [-0.1 -0.5] pomiar stanu')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

%% Symulacja nadążania 
K1 = place(A, B(:, 1), [-0.1 -0.5]);
L1 = place(A', C', [-1.2, -1.5])';

K2 = place(A, B(:, 1), [-0.3 -0.7]);
L2 = place(A', C', [-1.2, -1.5])';

K3 = place(A, B(:, 1), [-0.1 -0.5]);
L3 = place(A', C', [-1.5, -2])';

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:4000];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = pp_Pt;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;
%We wspolrzednych odchylek
est_x = [0; 0];

[y1, u1] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 0, 0);
[y2, u2] = sim_Kpoles_obs(times, y, dsystem, K2, L2, SP, Pz, To, est_x, 0, 0);
[y3, u3] = sim_Kpoles_obs(times, y, dsystem, K3, L3, SP, Pz, To, est_x, 0, 0);
[y4, u4] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);

figure()
subplot(2, 2, 1)
plot(times, y1)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.1 -0.5], bieguny L = [-1.2, -1.5]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 2)
plot(times, y2)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.3 -0.7], bieguny L = [-1.2, -1.5]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 3)
plot(times, y3)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.1 -0.5], bieguny L = [-1.5, -2]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 4)
plot(times, y4)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.1 -0.5] pomiar stanu')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

%% Wyjście obarczone szumem
K1 = place(A, B(:, 1), [-0.1 -0.5]);
L1 = place(A', C', [-1.2, -1.5])';

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:4000];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = pp_Pt;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;
%We wspolrzednych odchylek
est_x = [0; 0];

[y1, u1] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 0, 0);
[y2, u2] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 50, 0);
[y3, u3] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 0, 0.05);
[y4, u4] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 0, 0.05);

figure()
subplot(2, 2, 1)
plot(times, y1)
hold on
plot(times, SP(:, 2), '--')
title('Brak szumów pomiarowych')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 2)
plot(times, y2)
hold on
plot(times, SP(:, 2), '--')
title('Szum sterowania')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 3)
plot(times, y3)
hold on
plot(times, SP(:, 2), '--')
title('Szum pomiaru temperatury')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 4)
plot(times, y4)
hold on
plot(times, SP(:, 2), '--')
title('Komplet szumów')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

%% Normalny przypadek testowy
K1 = place(A, B(:, 1), [-0.1 -0.5]);
L1 = place(A', C', [-1.2, -1.5])';

K2 = place(A, B(:, 1), [-0.3 -0.7]);
L2 = place(A', C', [-1.2, -1.5])';

K3 = place(A, B(:, 1), [-0.1 -0.5]);
L3 = place(A', C', [-1.5, -2])';

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:4000];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = pp_Pt;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;
%We wspolrzednych odchylek
est_x = [0; 0];

[y1, u1] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 50, 0.05);
[y2, u2] = sim_Kpoles_obs(times, y, dsystem, K2, L2, SP, Pz, To, est_x, 50, 0.05);
[y3, u3] = sim_Kpoles_obs(times, y, dsystem, K3, L3, SP, Pz, To, est_x, 50, 0.05);
[y4, u4] = sim_polesK(times, y, K1, SP, Pz, To, 50, 0.05);

figure()
subplot(2, 2, 1)
plot(times, y1)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.1 -0.5], bieguny L = [-1.2, -1.5]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 2)
plot(times, y2)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.3 -0.7], bieguny L = [-1.2, -1.5]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 3)
plot(times, y3)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.1 -0.5], bieguny L = [-1.5, -2]')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

subplot(2, 2, 4)
plot(times, y4)
hold on
plot(times, SP(:, 2), '--')
title('Bieguny K = [-0.1 -0.5] pomiar stanu')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');

%% grid search najlepszych biegunów L i K
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:4000];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = pp_Pt;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;
%We wspolrzednych odchylek
est_x = [0; 0];

k1 = linspace(-0.005, -0.5, 4);
k2 = linspace(-0.006, -0.6, 4);
l1 = linspace(-0.005, -0.5, 4);
l2 = linspace(-0.006, -0.6, 4);
best_score = 1e6;

for i = k1
    for ii = k2
        for iii = l1
            for iiii = l2
                K1 = place(A, B(:, 1), [i, ii]);
                L1 = place(A', C', [iii, iiii])';
                [y1, u1] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 50, 0.05);

                score = mean((y1(:, 2)-SP(:, 2)).^2);
                if score < best_score
                    best_score = score;
                    best_k1 = i;
                    best_k2 = ii;
                    best_l1 = iii;
                    best_l2 = iiii;
                end
                res = [i, ii, iii, iiii, score];
                fprintf('Wynik dla k1 = %.3f, k2 = %.3f, l1 = %.3f, l2 = %.3f: %.3f\n', res);
            end
        end
    end
end
%% Pokaz najlepsze
best_score
best_k1
best_k2
best_l1
best_l2

%% Symulacja dla najlepszych
best_k1 = -0.3350;
best_k2 = -0.2040;
best_l1 = -0.3350;
best_l2 = -0.4020;

K1 = place(A, B(:, 1), [best_k1 best_k2]);
L1 = place(A', C', [best_l1, best_l2])';

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:4000];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = pp_Pt;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;
%We wspolrzednych odchylek
est_x = [0; 0];

[y1, u1] = sim_Kpoles_obs(times, y, dsystem, K1, L1, SP, Pz, To, est_x, 50, 0.05);

%% Wykresy
figure()
subplot(2, 1, 1)
plot(times, y1(:, 1))
hold on
plot(times, y1(:, 2))
hold on
plot(times, SP(:, 2), '--')
legend('Temperatura pomieszczenia', 'Temperatura przedmiotu', 'Wartośc zadana');
ylabel('Temperatura w degC')

subplot(2, 1, 2)
plot(times, u1)
hold on
plot(times, SP(:, 2), '--')
ylabel('Moc z klimatyzatora w W')
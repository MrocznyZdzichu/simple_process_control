%% Stworzenie modelu obiektu
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

%% Sprzężenie od stanu - kompensacja zakłóceń w punkcie pracy
% Adx/dt = Ax - B(Kx) = (A-BK)x
% -Kx = u

K1 = place(A, B(:, 1), [-1, -0.5]);
K2 = place(A, B(:, 1), [-0.4, -0.5]);
K3 = place(A, B(:, 1), [-1, -0.25]);
K4 = place(A, B(:, 1), [-0.4, -0.25]);

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
u = 0;

SP = pp_T(2)*ones(length(times), 2);

[y1, u1] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);
[y2, u2] = sim_polesK(times, y, K2, SP, Pz, To, 0, 0);
[y3, u3] = sim_polesK(times, y, K3, SP, Pz, To, 0, 0);
[y4, u4] = sim_polesK(times, y, K4, SP, Pz, To, 0, 0);

figure()
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
hold on
plot(times, y4(:, 1))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')
figure()
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')

figure()
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2))...
)
ylabel('Moc z klimy')
xlabel('Czas symulacji')

%% Nadążanie dla temperatury otoczenia jak w punkcie pracy bez zakłóceń
K1 = place(A, B(:, 1), [-0.1, -0.05]);
K2 = place(A, B(:, 1), [-0.04, -0.05]);
K3 = place(A, B(:, 1), [-0.1, -0.025]);
K4 = place(A, B(:, 1), [-0.04, -0.025]);

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:3600];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));
To = pp_To*ones(1, length(times));
y0 = pp_T;
y = y0;
u = 0;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;

[y1, u1] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);
[y2, u2] = sim_polesK(times, y, K2, SP, Pz, To, 0, 0);
[y3, u3] = sim_polesK(times, y, K3, SP, Pz, To, 0, 0);
[y4, u4] = sim_polesK(times, y, K4, SP, Pz, To, 0, 0);

figure()
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
hold on
plot(times, y4(:, 1))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')
figure()
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura przedmiotu')
xlabel('Czas symulacji')

figure()
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2))...
)
ylabel('Moc z klimy')
xlabel('Czas symulacji')

%% Nadążanie dla temperatury otoczenia jak za oknem bez zakłóceń
K1 = place(A, B(:, 1), [-0.1, -0.05]);
K2 = place(A, B(:, 1), [-0.03, -0.05]);
K3 = place(A, B(:, 1), [-0.1, -0.02]);
K4 = place(A, B(:, 1), [-0.03, -0.02]);

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:3600];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));
To = -1*ones(1, length(times));
y0 = pp_T;
y = y0;
u = 0;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;

[y1, u1] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);
[y2, u2] = sim_polesK(times, y, K2, SP, Pz, To, 0, 0);
[y3, u3] = sim_polesK(times, y, K3, SP, Pz, To, 0, 0);
[y4, u4] = sim_polesK(times, y, K4, SP, Pz, To, 0, 0);

figure()
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
hold on
plot(times, y4(:, 1))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')
figure()
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura przedmiotu')
xlabel('Czas symulacji')

figure()
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2))...
)
ylabel('Moc z klimy')
xlabel('Czas symulacji')

%% Nadążanie dla temperatury otoczenia jak za oknem bez zakłóceń + zakłócenia sterowania i wyjścia
K2 = place(A, B(:, 1), [-0.03, -0.05]);

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:3600];
ampl = 0;
Pz = cumsum(ampl*randn(1, length(times)));
To = -1*ones(1, length(times));
y0 = pp_T;
y = y0;
u = 0;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;

[y1, u1] = sim_polesK(times, y, K2, SP, Pz, To, 0, 0);
[y2, u2] = sim_polesK(times, y, K2, SP, Pz, To, 50, 0);
[y3, u3] = sim_polesK(times, y, K2, SP, Pz, To, 0, 0.05);
[y4, u4] = sim_polesK(times, y, K2, SP, Pz, To, 50, 0.05);

figure()
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
hold on
plot(times, y4(:, 1))
hold on
plot(times, SP(:, 1), '--')
legend('Brak szumów pomiarowych', 'Szum sterowania', 'Szum wyjścia', 'Komplet szumów', 'Wartość zadana')
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')
figure()
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP(:, 1), '--')
legend('Brak szumów pomiarowych', 'Szum sterowania', 'Szum wyjścia', 'Komplet szumów', 'Wartość zadana')
ylabel('Temperatura przedmiotu')
xlabel('Czas symulacji')

figure()
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2))...
)
ylabel('Moc z klimy')
xlabel('Czas symulacji')

%% Nadążanie dla temperatury otoczenia jak za oknem z zakłóceniami
K1 = place(A, B(:, 1), [-0.1, -0.05]);
K2 = place(A, B(:, 1), [-0.03, -0.05]);
K3 = place(A, B(:, 1), [-0.1, -0.02]);
K4 = place(A, B(:, 1), [-0.03, -0.02]);

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:3600];
ampl = 50;
Pz = cumsum(ampl*randn(1, length(times)));
To = -1*ones(1, length(times));
y0 = pp_T;
y = y0;
u = 0;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;

[y1, u1] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);
[y2, u2] = sim_polesK(times, y, K2, SP, Pz, To, 0, 0);
[y3, u3] = sim_polesK(times, y, K3, SP, Pz, To, 0, 0);
[y4, u4] = sim_polesK(times, y, K4, SP, Pz, To, 0, 0);

figure()
plot(times, y1(:, 1))
hold on
plot(times, y2(:, 1))
hold on
plot(times, y3(:, 1))
hold on
plot(times, y4(:, 1))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')
figure()
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K2(1), K2(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K3(1), K3(2)),...
sprintf('k1 = %.2f, k2 = %.2f', K4(1), K4(2)),...
'Wartość zadana'...
)
ylabel('Temperatura przedmiotu')
xlabel('Czas symulacji')

%% Grid search najlepszych biegunów
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:3600];
ampl = 100;
Pz = (ampl*randn(1, length(times)));
To = -1*ones(1, length(times));
y0 = pp_T;
y = y0;
u = 0;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;

k1 = linspace(-0.005, -0.5, 10);
k2 = linspace(-0.006, -0.6, 10);

best_score = 1e6;
for i = k1
    for ii = k2
        K = place(A, B(:, 1), [i, ii]);
        [y1, u] = sim_polesK(times, y, K, SP, Pz, To, 0, 0);
        
        score = mean((y1(:, 2)-SP(:, 2)).^2);
        if score < best_score
            best_score = score;
            best_k1 = i;
            best_k2 = ii;
        end
        
        fprintf('Wynik %.2f dla macierzy sprzężenia [%.2f, %.2f]\n', score, i, ii)
    end
end
best_score
best_k1
best_k2

%% Symulacja dla najlepszego wyniku:
best_k1 = -0.1700;
best_k2 = -0.2040;

K1 = place(A, B(:, 1), [best_k1, best_k2]);

pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

times = [0:1:3600];
ampl = 1500;
Pz = (ampl*randn(1, length(times)));
To = -1*ones(1, length(times));
y0 = pp_T;
y = y0;
u = 0;

SP = pp_T(2)*ones(length(times), 2);
SP(600:1500, :) = pp_T(2)+10;
SP(2200:3000, :) = pp_T(2) - 15;

[y1, u1] = sim_polesK(times, y, K1, SP, Pz, To, 0, 0);

figure()
plot(times, y1(:, 1))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
'Wartość zadana'...
)
ylabel('Temperatura pomieszczenia')
xlabel('Czas symulacji')
figure()
plot(times, y1(:, 2))
hold on
plot(times, SP(:, 1), '--')
legend(...
sprintf('k1 = %.2f, k2 = %.2f', K1(1), K1(2)),...
'Wartość zadana'...
)
ylabel('Temperatura przedmiotu')
xlabel('Czas symulacji')
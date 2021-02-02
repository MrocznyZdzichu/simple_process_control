%% PID - regulator P
times = [0:1:5000];
ampl = 600;
Pz = ampl*randn(1, length(times));
To = 12*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

K1 = 500;
K2 = 1000;
K3 = 2000;
I1 = 0;
I2 = 0;
I3 = 0;
D1 = 0;
D2 = 0;
D3 = 0;

u = 0;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP, Pz, times, 0, 0, 0);
[y2, u2] = sim_PID(K2, I2, D2, To, y0, SP, Pz, times, 0, 0, 0);
[y3, u3] = sim_PID(K3, I3, D1, To, y0, SP, Pz, times, 0, 0, 0);

figure()
subplot(2,1,1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, SP, '--')
title('Porównanie działania regulatorów P')
legend(sprintf('K = %.f', K1), sprintf('K = %.f', K2), sprintf('K = %.f', K3), 'Wartość zadana')
ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')

%% PID - regulator P w towarzystwie szumów
times = [0:1:5000];
ampl = 600;
Pz = ampl*randn(1, length(times));
To = 12*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

K1 = 500;
K2 = 1000;
K3 = 2000;
I1 = 0;
I2 = 0;
I3 = 0;
D1 = 0;
D2 = 0;
D3 = 0;

u = 0;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP, Pz, times, 0, 0, 0);
[y2, u2] = sim_PID(K1, I2, D2, To, y0, SP, Pz, times, 0, 50, 0);
[y3, u3] = sim_PID(K1, I3, D1, To, y0, SP, Pz, times, 0, 0, 0.2);
[y4, u4] = sim_PID(K1, I3, D1, To, y0, SP, Pz, times, 0, 50, 0.2);

figure()
subplot(2,1,1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP, '--')
title('Porównanie działania regulatorów P')
legend('Brak szumów pomiarowych', 'Szum sterowania', 'Szum wyjścia', 'Komplet szumów', 'Wartość zadana')
ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
hold on
legend('Brak szumów pomiarowych', 'Szum sterowania', 'Szum wyjścia', 'Komplet szumów', 'Wartość zadana')
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')

%% Regulator PD - łagodzenie przebiegów, reagowanie na zakłócenia
times = [0:1:5000];
ampl = 600;
Pz = ampl*randn(1, length(times));
To = 12*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

K1 = 1500;
K2 = 1500;
K3 = 1500;
K4 = 1500;
I1 = 0;
I2 = 0;
I3 = 0;
I4 = 0;
D1 = 20;
D2 = 50;
D3 = 100;
D4 = 0;

u = 0;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP, Pz, times, 0, 0, 0);
[y2, u2] = sim_PID(K2, I2, D2, To, y0, SP, Pz, times, 0, 0, 0);
[y3, u3] = sim_PID(K3, I3, D3, To, y0, SP, Pz, times, 0, 0, 0);
[y4, u4] = sim_PID(K4, I4, D4, To, y0, SP, Pz, times, 0, 0, 0);

figure()
subplot(2,1,1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP, '--')
title('Porównanie działania regulatorów PD')
legend(sprintf('K = %.f, D = %.f', K1, D1)...
, sprintf('K = %.f, D = %.f', K2, D2)...
, sprintf('K = %.f, D = %.f', K3, D3)...
, sprintf('K = %.f, D = %.f', K4, D4)...
, 'Wartość zadana')
ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')

%% Regulator PD w towarzystwie szumów pomiarowych
times = [0:1:5000];
ampl = 600;
Pz = ampl*randn(1, length(times));
To = 12*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

K1 = 1500;
K2 = 1500;
K3 = 1500;
K4 = 1500;
I1 = 0;
I2 = 0;
I3 = 0;
I4 = 0;
D1 = 100;
D2 = 100;
D3 = 100;
D4 = 100;

u = 0;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP, Pz, times, 0, 0, 0);
[y2, u2] = sim_PID(K2, I2, D2, To, y0, SP, Pz, times, 0, 50, 0);
[y3, u3] = sim_PID(K3, I3, D3, To, y0, SP, Pz, times, 0, 0, 0.2);
[y4, u4] = sim_PID(K4, I4, D4, To, y0, SP, Pz, times, 0, 50, 0.2);

figure()
subplot(2,1,1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP, '--')
title('Porównanie działania regulatorów PD')
legend('Brak szumów pomiarowych', 'Szum sterowania', 'Szum wyjścia', 'Komplet szumów', 'Wartość zadana')

ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
plot(times, u4)
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')
legend('Brak szumów pomiarowych', 'Szum sterowania', 'Szum wyjścia', 'Komplet szumów', 'Wartość zadana')

%% Regulator PI - likwidacja odchyłki statycznej
times = [0:1:5000];
ampl = 0;
Pz = ampl*randn(1, length(times));
To = 2*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

K1 = 1500;
K2 = 1500;
K3 = 1500;
K4 = 1500;
I1 = 0.0005;
I2 = 0.0002;
I3 = 0.0001;
I4 = 0;
D1 = 10;
D2 = 10;
D3 = 10;
D4 = 10;

u = 0;

[y1, u1] = sim_PID(K1, I1, D1, To, y0, SP, Pz, times, 1, 0, 0);
[y2, u2] = sim_PID(K2, I2, D2, To, y0, SP, Pz, times, 1, 0, 0);
[y3, u3] = sim_PID(K3, I3, D3, To, y0, SP, Pz, times, 1, 0, 0);
[y4, u4] = sim_PID(K4, I4, D4, To, y0, SP, Pz, times, 1, 0, 0);

figure()
subplot(2,1,1)
plot(times, y1(:, 2))
hold on
plot(times, y2(:, 2))
hold on
plot(times, y3(:, 2))
hold on
plot(times, y4(:, 2))
hold on
plot(times, SP, '--')
title('Porównanie działania regulatorów PID')
legend(sprintf('I = %d', I1)...
, sprintf('I = %d', I2)...
, sprintf('I = %d', I3)...
, sprintf('I = %d', I4)...
, 'Wartość zadana')
ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
hold on
plot(times, u2)
hold on
plot(times, u3)
hold on
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')

%% Dobór nastaw grid search, 1. iteracja
times = [0:1:5000];
ampl = 0;
Pz = ampl*randn(1, length(times));
To = 2*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

k = [10, 50, 100, 500, 1000, 1500];
i = logspace(-8, -3, 6);
d = [10, 20, 50, 100, 200, 500];

best_score = 1e6;
best_k = 0;
best_i = 0;
best_d = 0;

for j = 1:length(k)
    for jj = 1:length(i)
        for jjj = 1:length(d)
            [y, u] = sim_PID(k(j), i(jj), d(jjj), To, y0, SP, Pz, times, 1, 0, 0);
            
            score = mean((SP'-y(:,2)).^2);
            fprintf('Wynik regulacji K=%d, I=%d, P=%d - %.d\n', k(j), i(jj), d(jjj), score);
            if score < best_score
                best_score = score;
                best_k = k(j);
                best_i = i(jj);
                best_d = d(jjj);
            end
        end
    end
end
best_k
best_i
best_d
best_score

%% Test wyników 1. iteracji.
times = [0:1:5000];
ampl = 0;
Pz = ampl*randn(1, length(times));
To = 2*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

[y, u] = sim_PID(best_k, best_i, best_d, To, y0, SP, Pz, times, 1);

figure()
subplot(2,1,1)
plot(times, y(:, 2))
hold on
plot(times, y(:, 1))
hold on 
plot(times, SP, '--')
legend('Temperatura obiektu', 'Temperatura pomieszczenia', 'Wartość zadana')
ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')


%% Druga interacja
times = [0:1:5000];
ampl = 0;
Pz = ampl*randn(1, length(times));
To = 2*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

k = [1200, 1300, 1400, 1500, 1700, 2000];
i = logspace(-9, -7, 6);
d = [35, 45, 50, 60, 75, 85];

best_score = 1e6;
best_k = 0;
best_i = 0;
best_d = 0;

for j = 1:length(k)
    for jj = 1:length(i)
        for jjj = 1:length(d)
            [y, u] = sim_PID(k(j), i(jj), d(jjj), To, y0, SP, Pz, times, 1, 0, 0);
            
            score = mean((SP'-y(:,2)).^2);
            fprintf('Wynik regulacji K=%d, I=%d, P=%d - %.d\n', k(j), i(jj), d(jjj), score);
            if score < best_score
                best_score = score;
                best_k = k(j);
                best_i = i(jj);
                best_d = d(jjj);
            end
        end
    end
end
best_k
best_i
best_d
best_score

%% Wyniki 2. iteracji
times = [0:1:5000];
ampl = 0;
Pz = ampl*randn(1, length(times));
To = 2*ones(1, length(times));
y0 = [16, 16];
y = y0;

SP = 16*ones(1, length(times));
SP(800:2800) = 22;
SP(2801:400)= 10;

[y, u] = sim_PID(best_k, best_i, best_d, To, y0, SP, Pz, times, 1);

figure()
subplot(2,1,1)
plot(times, y(:, 2))
hold on
plot(times, y(:, 1))
hold on 
plot(times, SP, '--')
legend('Temperatura obiektu', 'Temperatura pomieszczenia', 'Wartość zadana')
ylabel('Temperatura przedmiotu [degC]')
subplot(2,1,2)
plot(times, u1)
ylabel('Moc z klimatyzatora [W]')
xlabel('Czas [s]')
